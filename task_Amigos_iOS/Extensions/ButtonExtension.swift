//
//  ButtonExtension.swift
//  task_Amigos_iOS
//
//  Created by Daniel Miolan on 1/26/22.
//

import UIKit
import Foundation

extension UIButton {
    func roundTopCorners() {
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft , .topRight], cornerRadii: CGSize(width: 8, height: 8))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
}
