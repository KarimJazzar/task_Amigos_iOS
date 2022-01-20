//
//  AnimationHelper.swift
//  task_Amigos_iOS
//
//  Created by Daniel Miolan on 1/20/22.
//

import Foundation
import UIKit

public class AnimationHelper {
    static func SlideX(view: UIView, x: CGFloat) -> Void {
        UIView.animate(withDuration: 0.5) {
            view.frame.origin.x = CGFloat(x)
        }
    }
    
    static func FixPositionX(view: UIView) -> Void {
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {}, completion: {
            finished in view.frame.origin.x = 30 + view.frame.width
        })
    }
}
