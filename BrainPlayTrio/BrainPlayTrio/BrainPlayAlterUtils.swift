//
//  Utils.swift
//  BrainPlayTrio
//
//  Created by BrainPlay Trio on 2024/12/23.
//

import UIKit

class BrainPlayAlterUtils {
    static func showAlert(title: String, message: String, from viewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}
