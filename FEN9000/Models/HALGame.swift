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

let timerTime: NSTimeInterval = 0.5
let thinkTimeMs: Int = 400
class HALGame: NSObject {

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

    private var timer: NSTimer!
    func start() {
        timer = NSTimer(timeInterval: timerTime, target: self, selector: #selector(someBackgroundTask(_:)), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
    }

    func someBackgroundTask(timer:NSTimer) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
            guard !self.game.isFinished else {
                self.timer.invalidate()
                return
            }
            self.performNextMove()

            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.delegate?.boardChanged()
            })
        })
    }


    private func performNextMove() {
        playerTurn.performNextMove()
    }
}