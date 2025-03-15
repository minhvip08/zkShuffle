import { ethers } from "hardhat";

async function main() {
    const [player0, player1] = await ethers.getSigners();
    const diceFactory = await ethers.getContractFactory("Dice");
    const dice = diceFactory.attach("0x5FC8d32690cc91D4c39d9d3abcBD16989F875707");
    const gameId = ethers.BigNumber.from(ethers.utils.randomBytes(32));
    await (await dice.connect(player0).newGame(gameId)).wait();
    console.log("Player ", player0.address.slice(0, 6).concat("..."), "Create Game ", gameId);

    // allow Join Game
    await (await dice.connect(player0).allowJoinGame(gameId)).wait();
}

main();