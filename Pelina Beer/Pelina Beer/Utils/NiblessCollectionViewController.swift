//
//  NiblessCollectionViewController.swift
//  BC Movies
//
//  Created by SaulUrias on 02/03/20.
//  Copyright © 2020 saulurias. All rights reserved.
//

import UIKit

class NiblessCollectionViewController: UICollectionViewController {
    public init(layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }
    
    @available(*,
    unavailable,
    message: "Loading this view controller from a nib is unsupported in favor of initializer dependency injection." )
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    @available(*,
    unavailable,
    message: "Loading this view controller from a nib is unsupported in favor of initializer dependency injection."
    )
    public required init?(coder aDecoder: NSCoder) {
        fatalError("This view is not compatible to load from a nib/storyboard")
    }
}
