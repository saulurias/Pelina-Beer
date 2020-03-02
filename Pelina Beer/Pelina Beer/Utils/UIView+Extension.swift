//
//  UIView+Extension.swift
//  BC Movies
//
//  Created by SaulUrias on 02/03/20.
//  Copyright © 2020 saulurias. All rights reserved.
//

import UIKit

extension UIView {
    
    /// Function to add borders with shadow to the views
    func setBorderShadow() {
        layer.shadowColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 1.0).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowOffset = CGSize(width: 0, height: 4)
    }
}
