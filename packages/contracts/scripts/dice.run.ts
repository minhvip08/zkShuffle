import WebSocket from "ws";
import { v4 as uuidv4 } from "uuid";
import dotenv from "dotenv";
import { ethers } from "hardhat";
import { Dice__factory, Dice, ShuffleManager } from "../types";
import { deploy_shuffle_manager } from "./dice.deploy";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { dnld_aws, P0X_DIR, sleep } from "@zk-shuffle/jssdk/src/shuffle/utility";
import { resolve } from "path";
import { GameTurn, ZKShuffle } from "@zk-shuffle/jssdk";

dotenv.config();

const PORT = parseInt(process.env.WSS_PORT || "3000");
const wss = new WebSocket.Server({ port: PORT });

console.log(`WebSocket Server running on PORT: ${PORT}`);

const clients = new Map<string, WebSocket>();

/**
 * Singleton Class to Manage Game State
 */
class GameService {
    private static instance: GameService;
    private shuffleManager: ShuffleManager | undefined;
    private shuffleGame: Dice | undefined;
    private players: SignerWithAddress[] | undefined;

    private constructor() {}

    public static getInstance(): GameService {
        if (!GameService.instance) {
            GameService.instance = new GameService();
        }
        return GameService.instance;
    }

    public async initializeContracts() {
        if (!this.shuffleManager || !this.shuffleGame) {
            console.log("Deploying Contracts...");
            this.players = await ethers.getSigners();
            this.shuffleManager = await deploy_shuffle_manager(this.players[0]);
            console.log(`ShuffleManager deployed at: ${this.shuffleManager.address}`);

            this.shuffleGame = await new Dice__factory(this.players[0]).deploy(
                this.shuffleManager.address,
            );
            console.log(`Dice deployed at: ${this.shuffleGame.address}`);
        }
    }

    public async player_run(owner: SignerWithAddress, gameId: number) {
        if (!this.shuffleManager) {
            throw new Error("ShuffleManager is not initialized");
        }

        console.log("Player ", owner.address.slice(0, 6).concat("..."), "init shuffle context!");
        let encrypt_wasm;
        let encrypt_zkey;
        // For numCards = 6
        encrypt_wasm = resolve(P0X_DIR, "./wasm/encrypt.wasm");
        encrypt_zkey = resolve(P0X_DIR, "./zkey/encrypt.zkey");

        const player = await ZKShuffle.create(
            this.shuffleManager.address,
            owner,
            await ZKShuffle.generateShuffleSecret(),
            resolve(P0X_DIR, "./wasm/decrypt.wasm"),
            resolve(P0X_DIR, "./zkey/decrypt.zkey"),
            encrypt_wasm,
            encrypt_zkey,
        );
    
        let playerIdx = await player.joinGame(gameId);
        console.log(
            "Player ",
            owner.address.slice(0, 6).concat("..."),
            "Join Game ",
            gameId,
            " asigned playerId ",
            playerIdx,
        );

        // play game
        let turn: GameTurn = GameTurn.NOP;
        let revealedCard: number | null = null;

        while (turn !== GameTurn.Complete) {
            turn = await player.checkTurn(gameId);
            //console.log("player ", playerIdx, " state : ", state, " nextBlock ", nextBlock)
            if (turn != GameTurn.NOP) {
                switch (turn) {
                    case GameTurn.Shuffle:
                        console.log("Player ", playerIdx, " 's Shuffle turn!");
                        await player.shuffle(gameId);
                        break;
                    case GameTurn.Deal:
                        console.log("Player ", playerIdx, " 's Deal Decrypt turn!");
                        await player.draw(gameId);
                        break;
                        case GameTurn.Open:
                            console.log("Player ", playerIdx, " 's Open Decrypt turn!");
                            let cards = await player.openOffchain(gameId, [playerIdx]);
                            console.log("Player ", playerIdx, " open offchain hand card ", cards[0]);
                            cards = await player.open(gameId, [playerIdx]);
                            console.log("Player ", playerIdx, " open onchain hand card ", cards[0]);
                            revealedCard = cards[0];
                            break;
                          case GameTurn.Complete:
                            console.log("Player ", playerIdx, " 's Game End!");
                            break;
                          default:
                            console.log("err turn ", turn);
                }
            }

            await sleep(1000);
        }

        return revealedCard;
    }

    public async rollDice(clientId: string) {
        try {
            if (this.shuffleGame && this.players) {
                await (await this.shuffleGame.connect(this.players[0]).newGame(clientId)).wait();
                const gameId = (await this.shuffleGame.connect(this.players[0]).getShuffleGameId(clientId)).toNumber();

                console.log(
                    "Player ",
                    this.players[0].address.slice(0, 6).concat("..."),
                    "Create Game ",
                    clientId,
                );

                await (await this.shuffleGame.connect(this.players[0]).allowJoinGame(clientId)).wait();
                if (this.shuffleManager) {
                    
                    const [playercard0, playercard1] = await Promise.all([this.player_run(this.players[0], gameId), this.player_run(this.players[1], gameId)]);
                    console.log("Player 0 revealed card: ", playercard0);
                    console.log("Player 1 revealed card: ", playercard1);
                    if (playercard0) {
                        return playercard0;
                    } else {
                        return playercard1;
                    }
                } else {
                    throw new Error("ShuffleManager is not initialized");
                }

            } else {
                throw new Error("Contracts or players are not initialized");
            }
        } catch (error) {
            console.error("Error starting new game:", error);
            return null;
        }
    }
}

function setupWebSocketServer() {
    wss.on("connection", (ws, request) => {
        const clientId = (request.headers["currentroomid"] as string) || uuidv4();
        console.log(`Client Connected: ${clientId}`);
        clients.set(clientId, ws);

        ws.send(JSON.stringify({ event: "CONNECTED", clientId }));

        ws.on("message", async (data) => {
            try {
                const message = JSON.parse(data.toString());
                console.log("Received WebSocket Message:", message);

                if (message.action === "ROLL_DICE") {
                    await handleDiceRoll(message);
                }
            } catch (error) {
                console.error("Error processing WebSocket message:", error);
            }
        });

        ws.on("close", () => {
            console.log(`Client ${clientId} disconnected`);
            clients.delete(clientId);
        });

        ws.on("error", (error) => {
            console.error(`WebSocket Error for client ${clientId}:`, error);
        });
    });
}

async function handleDiceRoll(message: any) {
    try {
        const gameService = GameService.getInstance();
        const result = await gameService.rollDice(message.clientId);
        if (result !== null) {
            console.log(`Dice rolled: ${result} for Client ${message.clientId}`);
            const clientWs = clients.get(message.clientId);
            if (clientWs && clientWs.readyState === WebSocket.OPEN) {
                clientWs.send(
                    JSON.stringify({
                        event: "DICE_ROLLED",
                        clientId: message.clientId,
                        result: result,
                        requestId: message.requestId,
                    })
                );
                console.log(`Sent response to Client ${message.clientId}`);
            } else {
                console.warn(`Client ${message.clientId} is not connected`);
            }
        }
        
    } catch (error) {
        console.error("Error handling dice roll:", error);
    }
}

setupWebSocketServer();

const gameService = GameService.getInstance();
gameService.initializeContracts();
