//
//  ViewController.swift
//  FEN9000
//
//  Created by Alexander Georgii-Hemming Cyon on 09/07/16.
//  Copyright © 2016 sajjon. All rights reserved.
//

import UIKit
import Sage
import Cartography

struct HALMove {
    var move: Move
    var promotion: Piece?
}

class ViewController: UIViewController {

    private lazy var halGame: HALGame = {
        let game = Game(mode: .ComputerVsComputer, variant: .Standard)
        let halGame = HALGame(game: game, delegate: self)
        return halGame
    }()

    private var game: Game {
        return halGame.game
    }

    private var board: Board {
        return game.board
    }

    private lazy var boardView: BoardView = {
        let boardView = BoardView(game: self.game)
        return boardView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        halGame.start()
    }
}

private extension ViewController {
    func setupViews() {
        view.addSubview(boardView)
        constrain(view, boardView) {
            root, board in
            board.centerY == root.centerY
            board.leading == root.leading
            board.trailing == root.trailing
            board.height == root.width
        }
    }
}

extension ViewController: GameDelegate {
    func boardChanged() {
        self.boardView.boardChanged()
    }
}
