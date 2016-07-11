//
//  Sage_Extension.swift
//  FEN9000
//
//  Created by Alexander Georgii-Hemming Cyon on 10/07/16.
//  Copyright © 2016 sajjon. All rights reserved.
//

import Foundation
import Sage

extension Board {
    func drawIn(view view: UIView) {
        for space in self {
            space.drawInView(view: view)
        }
    }
}

extension Piece {
    var value: Double {
        switch self {
        case .King:
            return valueOfKing
        default:
            return relativeValue
        }
    }
}
let valueOfKing: Double = 10000

extension Board.Space {
    func drawInView(view view: UIView) {
        let size: CGFloat = view.frame.width/8
        let frame = CGRect(x: CGFloat(file.index) * size,
                           y: CGFloat(rank.index) * size,
                           width: size,
                           height: size)
        let textFrame = CGRect(x: 0, y: 0, width: size, height: size)
        let fontSize = size * 0.625
        let spaceView = UIView(frame: frame)


        let str = piece.map { String($0.specialCharacter(background: color)) } ?? ""

        let white = UIColor.whiteColor()
        let black = UIColor.blackColor()
        let bg: UIColor = color.isWhite ? white : black
        let tc: UIColor = color.isWhite ? black : white
        spaceView.backgroundColor = bg


        let label = UILabel(frame: textFrame)

        label.textAlignment = .Center
        label.font = .systemFontOfSize(fontSize)
        label.text = str
        label.textColor = tc
        spaceView.addSubview(label)
        view.addSubview(spaceView)
    }
    
}
