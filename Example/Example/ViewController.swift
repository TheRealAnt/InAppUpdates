//
//  ViewController.swift
//  Example
//
//  Created by Antonie on 2019/08/10.
//  Copyright © 2019 antonie. All rights reserved.
//

import UIKit
import InAppUpdates

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        InAppUpdates().accessAppStoreApi()
    }


}

