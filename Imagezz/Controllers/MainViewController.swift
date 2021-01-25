//
//  MainViewController.swift
//  Imagezz
//
//  Created by Frane Poljak on 25/01/2021.
//  Copyright © 2021 fpoljak. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    var viewModel: MainViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        viewModel = MainViewModel()

        print("loading images...")
        viewModel.loadImagesList()
    }
}
