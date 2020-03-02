//
//  Alertable.swift
//  BC Movies
//
//  Created by SaulUrias on 02/03/20.
//  Copyright © 2020 saulurias. All rights reserved.
//

import UIKit

protocol Alertable { }

extension Alertable where Self: UIViewController {
    func showAlert(title: String, message: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let done = UIAlertAction(title: "Done", style: .cancel) { _ in }
        alertController.addAction(done)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
