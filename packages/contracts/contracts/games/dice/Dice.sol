// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "../../shuffle/Storage.sol";
import "../../shuffle/IShuffleStateManager.sol";

contract Dice is IBaseGame {
    IShuffleStateManager public ishuffle;
    DeckConfig _cardConfig;

    // check whether the caller is the shuffle nanager
    modifier onlyShuffleManager() {
        require(address(ishuffle) == msg.sender, "caller is not shuffle manager.");
        _;
    }

    // check whether the caller is the game owner
    modifier onlyGameOwner(string memory gameId) {
        require(gameOwners[gameId] == msg.sender, "caller is not game owner.");
        _;
    }

    function cardConfig() external override view returns (DeckConfig) {
        return _cardConfig;
    }

    // a mapping between Dice's gameId
    // to the "global" gameId returned by ShuffleManager
    mapping(string => uint256) public shuffleGameIds;

    // a mapping between Dice's gameId and game owners
    mapping(string => address) public gameOwners;

    constructor(IShuffleStateManager _ishuffle) {
        ishuffle = _ishuffle;
        _cardConfig = DeckConfig.Deck6Card;
    }

    function newGame(string memory gameId, uint8 numPlayers) external returns (uint256) {
        uint256 shuffleGameId = ishuffle.createShuffleGame(numPlayers);
        gameOwners[gameId] = msg.sender;
        shuffleGameIds[gameId] = shuffleGameId;
    }

    // Get shuffleGameId by gameId
    function getShuffleGameId(string memory gameId) external view returns (uint256) {
        return shuffleGameIds[gameId];
    }

    function allowJoinGame(
        string memory gameId
    ) external onlyGameOwner(gameId) {
        bytes memory next = abi.encodeWithSelector(this.moveToShuffleStage.selector, gameId);
        ishuffle.register(shuffleGameIds[gameId], next);
    }

    // Allow players to shuffle the deck, and specify the next state:
    // dealCard0ToPlayer0
    function moveToShuffleStage(
        string memory gameId
    ) external onlyShuffleManager {
        bytes memory next = abi.encodeWithSelector(this.dealCard0ToPlayer0.selector, gameId);
        ishuffle.shuffle(shuffleGameIds[gameId], next);
    }

    // Deal the 0th card to player 0 and specify the next state:
    // openCard0
    function dealCard0ToPlayer0(
        string memory gameId
    ) external onlyShuffleManager {
        BitMaps.BitMap256 memory cards;
        cards._data = 1;    // ...0001
        bytes memory next = abi.encodeWithSelector(this.openCard0.selector, gameId);
        ishuffle.dealCardsTo(
            shuffleGameIds[gameId],
            cards,
            0,
            next
        );
    }

    // Open Card 0 and specify the next state:
    // endGame
    function openCard0(
        string memory gameId
    ) external onlyShuffleManager {
        bytes memory next = abi.encodeWithSelector(this.endGame.selector, gameId);
        ishuffle.openCards(
            shuffleGameIds[gameId],
            0,
            1,
            next
        );
    }

    // End the game, GG!
    function endGame(
        string memory gameId
    ) external onlyShuffleManager {
        // game-specific cleanup

        ishuffle.endGame(shuffleGameIds[gameId]);
    }
}