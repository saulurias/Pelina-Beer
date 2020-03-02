//
//  NiblessView.swift
//  BC Movies
//
//  Created by SaulUrias on 02/03/20.
//  Copyright © 2020 saulurias. All rights reserved.
//

import UIKit

class NiblessView: UIView {
    public init() {
        super.init(frame: .zero)
    }
    
    @available(*,
    unavailable,
    message: "Loading this view controller from a nib is unsupported in favor of initializer dependency injection."
    )
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
