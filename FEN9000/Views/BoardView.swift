//
//  BoardView.swift
//  FEN9000
//
//  Created by Alexander Georgii-Hemming Cyon on 09/07/16.
//  Copyright © 2016 sajjon. All rights reserved.
//

import UIKit
import Sage

protocol BoardDelegate: class {
    func boardChanged()
}
class BoardView: UIView, BoardDelegate {

    var game: Game?

    init(game: Game) {
        self.game = game
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        subviews.forEach { $0.removeFromSuperview() }
        guard let board = game?.board else { return }
        print(board.ascii)
        board.drawIn(view: self)
        print("\(subviews.count) subviews")
    }

    func boardChanged() {
        setNeedsLayout()
        layoutIfNeeded()
    }
}