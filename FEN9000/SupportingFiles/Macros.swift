//
//  Macros.swift
//  FEN9000
//
//  Created by Alexander Georgii-Hemming Cyon on 10/07/16.
//  Copyright © 2016 sajjon. All rights reserved.
//

import Foundation


typealias Closure = () -> Void

func delay(delay: Double, closure: Closure) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(),
        closure
    )
}

func onMain(closure: Closure) {
    dispatch_async(dispatch_get_main_queue()) {
        () -> Void in
        closure()
    }
}