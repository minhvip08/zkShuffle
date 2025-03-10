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
    modifier onlyGameOwner(uint gameId) {
        require(gameOwners[gameId] == msg.sender, "caller is not game owner.");
        _;
    }

    function cardConfig() external override view returns (DeckConfig) {
        return _cardConfig;
    }

    // a mapping between Dice's gameId
    // to the "global" gameId returned by ShuffleManager
    mapping(uint => uint) shuffleGameIds;

    // a mapping between Dice's gameId and game owners
    mapping(uint => address) gameOwners;

    constructor(IShuffleStateManager _ishuffle) {
        ishuffle = _ishuffle;
        _cardConfig = DeckConfig.Deck36Card;
    }

    function newGame(uint gameId) external {
        uint shuffleGameId = ishuffle.createShuffleGame(2);
        gameOwners[gameId] = msg.sender;
        shuffleGameIds[gameId] = shuffleGameId;
    }

    function allowJoinGame(
        uint gameId
    ) external onlyGameOwner(gameId) {
        bytes memory next = abi.encodeWithSelector(this.moveToShuffleStage.selector, gameId);
        ishuffle.register(shuffleGameIds[gameId], next);
    }

    // Allow players to shuffle the deck, and specify the next state:
    // dealCard0ToPlayer0
    function moveToShuffleStage(
        uint gameId
    ) external onlyShuffleManager {
        bytes memory next = abi.encodeWithSelector(this.dealCard0ToPlayer0.selector, gameId);
        ishuffle.shuffle(shuffleGameIds[gameId], next);
    }

    // Deal the 0th card to player 0 and specify the next state:
    // dealCard1ToPlayer1
    function dealCard0ToPlayer0(
        uint gameId
    ) external onlyShuffleManager {
        BitMaps.BitMap256 memory cards;
        cards._data = 1;    // ...0001
        bytes memory next = abi.encodeWithSelector(this.dealCard1ToPlayer1.selector, gameId);
        ishuffle.dealCardsTo(
            shuffleGameIds[gameId],
            cards,
            0,
            next
        );
    }

    // Deal the 1st card to player 1 and specify the next state:
    // openCard0
    function dealCard1ToPlayer1(
        uint gameId
    ) external onlyShuffleManager {
        BitMaps.BitMap256 memory cards;
        cards._data = 2;    // ...0010
        bytes memory next = abi.encodeWithSelector(this.openCard0.selector, gameId);
        ishuffle.dealCardsTo(
            shuffleGameIds[gameId],
            cards,
            1,
            next
        );
    }

    // Open Card 0 and specify the next state:
    // openCard1
    function openCard0(
        uint gameId
    ) external onlyShuffleManager {
        bytes memory next = abi.encodeWithSelector(this.openCard1.selector, gameId);
        ishuffle.openCards(
            shuffleGameIds[gameId],
            0,
            1,
            next
        );
    }

    // Open the Card 1 and specify the next state:
    // openCard1
    function openCard1(
        uint gameId
    ) external onlyShuffleManager {
        bytes memory next = abi.encodeWithSelector(this.endGame.selector, gameId);
        ishuffle.openCards(
            shuffleGameIds[gameId],
            1,
            1,
            next
        );
    }

    // End the game, GG!
    function endGame(
        uint gameId
    ) external onlyShuffleManager {
        // game-specific cleanup
        ishuffle.endGame(gameId);
    }
}