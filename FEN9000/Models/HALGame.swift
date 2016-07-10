//
//  HALGame.swift
//  FEN9000
//
//  Created by Alexander Georgii-Hemming Cyon on 10/07/16.
//  Copyright © 2016 sajjon. All rights reserved.
//

import Foundation
import Sage

protocol GameDelegate: class {
    func boardChanged()
}

class HALGame {

    let game: Game
    private weak var delegate: GameDelegate?
    private let white: ChessAI
    private let black: ChessAI

    init(game: Game, delegate: GameDelegate) {
        self.game = game
        self.delegate = delegate
        self.white = HAL(game: game, color: .White)
        self.black = HAL(game: game, color: .Black)
    }

    private var playerTurn: ChessAI {
        let player = game.playerTurn == .White ? white : black
        return player
    }


    func start() {
        while !game.isFinished {
            performNextMove()
            delegate?.boardChanged()
        }
    }

    private func performNextMove() {
        playerTurn.performNextMove()
    }
}