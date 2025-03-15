import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { ethers } from "hardhat";
import { v4 as uuidv4 } from "uuid"; // Tạo clientId duy 
import WebSocket from "ws";
import dotenv from "dotenv";
dotenv.config();
import {
  DecryptVerifier__factory,
  Dice__factory,
  Shuffle_encryptVerifier30Card__factory,
  Shuffle_encryptVerifier__factory,
  ShuffleManager__factory
} from "../types";

const wss = new WebSocket.Server({ port: parseInt(process.env.WSS_PORT || "3000") });
console.log("WebSocket Server running on PORT:", process.env.WSS_PORT);

const clients = new Map<string, WebSocket>();

wss.on("connection", (ws, request) => {
  console.log("WebSocket Client Connected:",request.headers["currentroomid"]);
  const clientId = request.headers["currentroomid"] as string || uuidv4();
  console.log("WebSocket Client Connected with clientId:", clientId);
  clients.set(clientId, ws);

  ws.send(JSON.stringify({ event: "CONNECTED", clientId }));


  ws.on("message", async (data) => {
    const message = JSON.parse(data.toString());
    console.log("Received WebSocket Message:", message);

    // Demo: Roll Dice
    if (message.action === "ROLL_DICE") {

      const diceResult = Math.floor(Math.random() * 6) + 1;
      console.log(`Dice rolled: ${diceResult} for Client ${message.clientId}`);

      const clientWs = clients.get(message.clientId);
      if (clientWs && clientWs.readyState === WebSocket.OPEN) {
        clientWs.send(JSON.stringify({
          event: "DICE_ROLLED",
          clientId: message.clientId,
          result: diceResult,
          requestId: message.requestId
        }));
        console.log(`Sent response to Client ${message.clientId}`);
      } else {
        console.warn(`Client ${message.clientId} is not connected`);
      }

    }
  });

  ws.on("close", () => {
    console.log(" WebSocket Client Disconnected");
  });
});




// Depploys contract for decryption.
async function deployDecrypt(owner: SignerWithAddress) {
  return await new DecryptVerifier__factory(owner).deploy();
}

// Deploys contract for shuffle encrypt.
async function deployShuffleEncrypt(owner: SignerWithAddress) {
  return await new Shuffle_encryptVerifier__factory(owner).deploy();
}

async function deployShuffleEncryptCARD30(owner: SignerWithAddress) {
  return await new Shuffle_encryptVerifier30Card__factory(owner).deploy();
}

async function deployShuffleEncryptCARD5(owner: SignerWithAddress) {
    return await new Shuffle_encryptVerifier30Card__factory(owner).deploy();
}

async function deploy_shuffle_manager(owner: SignerWithAddress) {
    const encrypt6 = await deployShuffleEncrypt(owner);
    const encrypt30 = await deployShuffleEncryptCARD30(owner);
    const encrypt5 = await deployShuffleEncryptCARD5(owner);
    const decrypt = await deployDecrypt(owner);

    const crypto = await (await ethers.getContractFactory("zkShuffleCrypto")).deploy();
    const sm = await (
        await ethers.getContractFactory("ShuffleManager", {
            libraries: {
                zkShuffleCrypto: crypto.address,
            },
        })
    ).deploy(decrypt.address, encrypt6.address, encrypt30.address, encrypt5.address);
    return ShuffleManager__factory.connect(sm.address, owner);
}

async function main() {
    const players = await ethers.getSigners();
    const shuffleManager = await deploy_shuffle_manager(players[0]);
    console.log(`ShuffleManager deployed to: ${shuffleManager.address}`);
    const game = await new Dice__factory(players[0]).deploy(shuffleManager.address);
    console.log(`Dice deployed to: ${game.address}`);


    // TODO: Listen to events
    // listen (IPC or HTTP) from the backend 
}

main();