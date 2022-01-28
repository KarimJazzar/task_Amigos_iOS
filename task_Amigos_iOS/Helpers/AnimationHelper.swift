//
//  AnimationHelper.swift
//  task_Amigos_iOS
//
//  Created by Daniel Miolan on 1/20/22.
//

import Foundation
import UIKit

public class AnimationHelper {
    static func slideX(view: UIView, x: CGFloat) -> Void {
  
        UIView.animate(withDuration: 0.5) {
            view.layer.frame.origin.x = CGFloat(x)
        }
    }
    
    static func fade(view: UIView, alpha: CGFloat) -> Void {
        UIView.animate(withDuration: 0.5) {
            view.alpha = alpha
        }
    }
}
