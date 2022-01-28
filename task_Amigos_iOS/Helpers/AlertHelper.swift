//
//  AlertHelper.swift
//  task_Amigos_iOS
//
//  Created by Daniel Miolan on 1/26/22.
//

import UIKit
import Foundation

class AlertHelper {
    static func showModal(view: UIViewController, type: AlertType, msg: String) {
        let title = getAlertTypeString(type: type)
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) {
            (action: UIAlertAction!) in
        }
        alertController.addAction(OKAction)
        view.present(alertController, animated: true, completion: nil)
    }
    
    static func getAlertTypeString(type: AlertType) -> String {
        switch type {
            case .error:
                return "Error"
            case .message:
                return "Message"
        }
    }
}
