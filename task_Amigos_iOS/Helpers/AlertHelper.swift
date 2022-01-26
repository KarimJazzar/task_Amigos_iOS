//
//  AlertHelper.swift
//  task_Amigos_iOS
//
//  Created by Daniel Miolan on 1/26/22.
//

import UIKit
import Foundation

class AlertHelper {
    static func showValidationAlert(view: UIViewController, msg: String) {
        let alertController = UIAlertController(title: "Error:", message: msg, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) {
            (action: UIAlertAction!) in
        }
        alertController.addAction(OKAction)
        view.present(alertController, animated: true, completion: nil)
    }
}
