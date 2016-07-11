//
//  HAL.swift
//  FEN9000
//
//  Created by Alexander Georgii-Hemming Cyon on 10/07/16.
//  Copyright © 2016 sajjon. All rights reserved.
//

import Foundation
import Sage

protocol ChessAI {
    func performNextMove()
}

class HAL: ChessAI {
    private let game: Game
    private let myColor: Color

    private var board: Board {
        return game.board
    }

    private var myPieces: [Piece] {
        return myColor == .Black ? board.blackPieces : board.whitePieces
    }

    private var opponentPieces: [Piece] {
        return myColor == .Black ? board.whitePieces : board.blackPieces
    }

    init(game: Game, color: Color) {
        self.game = game
        self.myColor = color
    }

    func performNextMove() {
        guard let move = optimalMoveIn(game: game.copy(), thinkingAheadBy: 10) else { return }
        do {
            if let promotion = move.promotion {
                try game.execute(move: move.move, promotion: promotion)
            } else {
                try game.execute(move: move.move)
            }
        } catch {
            print("cant perform move")
        }
    }

    private func optimalMoveIn(game game: Game, thinkingAheadBy depth: Int) -> HALMove? {
        guard var bestMoveSoFar = game.availableMoves().first else { return nil }
        var valueOfBestMove = Double.min
        let dueDate = NSDate.future(thinkTimeMs*1000, unit: .Nanosecond)
        var alpha = Double.min
        var beta = Double.max
        for depthIndex in 0..<depth {
            for move in game.availableMoves() {
                guard dueDate.moreMsLeftThan(10) else { break }
                let gameCopy = game.copy()
                do {
                    try gameCopy.execute(move: move)
//                    print(gameCopy.board.ascii)
                } catch {
                    print("cant do move")
                }
                let valueOfMove = alphaBeta(gameCopy,
                                            dueDate: dueDate,
                                            depth: depthIndex,
                                            alpha: alpha,
                                            beta: beta,
                                            maxPlayer: false)

                if valueOfMove > valueOfBestMove {
                    valueOfBestMove = valueOfMove
                    bestMoveSoFar = move
                }
                alpha = Double.min
                beta = Double.max
            }

        }
        return HALMove(move: bestMoveSoFar, promotion: nil)
    }

    private func alphaBeta(game: Game, dueDate: NSDate, depth: Int, alpha: Double, beta: Double, maxPlayer: Bool) -> Double {
        var alpha = alpha
        var beta = beta
        let availableMoves = game.availableMoves()
        guard depth > 0 && dueDate.moreMsLeftThan(30)
            else {
                let value = evaluate(game: game)
                return value
        }
        for move in availableMoves {
            let gameCopy = game.copy()
            do {
                try gameCopy.execute(move: move)
//                print(gameCopy.board.ascii)
            } catch {
                print("cant do move")
            }
            let newAlphaBeta = alphaBeta(gameCopy, dueDate: dueDate, depth: depth-1, alpha: alpha, beta: beta, maxPlayer: !maxPlayer)
            if maxPlayer {
                alpha = max(alpha, newAlphaBeta)
            } else {
                beta = min(beta, newAlphaBeta)
            }
            if beta <= alpha {
                break
            }
        }
        let value = maxPlayer ? alpha : beta
        return value
    }

    private func evaluate(game game: Game) -> Double {
        let myPiecesValue = valueOf(pieces: myPieces)
        let opponentPiecesValue = valueOf(pieces: opponentPieces)
        let value = myPiecesValue - opponentPiecesValue
        return value
    }

    private func valueOf(pieces pieces: [Piece]) -> Double {
        var sum: Double = 0
        for piece in pieces {
            sum += piece.value
        }
        return sum
    }
}
