//
//  SecondTabViewController.swift
//  UnoPointSLM
//
//  Created by Amit A on 22/11/18.
//  Copyright © 2018 Amit A. All rights reserved.
//

import UIKit

class SecondTabViewController: UIViewController {
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Second VC will appear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("Second VC will disappear")
    }
}
