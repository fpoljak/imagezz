//
//  ImageDetailViewController.swift
//  Imagezz
//
//  Created by Frane Poljak on 26/01/2021.
//  Copyright © 2021 fpoljak. All rights reserved.
//

import UIKit
import Combine
import AlamofireImage

class ImageDetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var viewModel = ImageDetailViewModel()
    
    private var disposables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.$imageItem.sink { [unowned self] (item) in
            guard let item = item else {
                return
            }
            self.imageView.af.setImage(withURL: item.downloadUrl)
            self.titleLabel.text = "Author: \(item.author)"
        }.store(in: &disposables)
    }
    
    @IBAction func close() {
        dismiss(animated: true, completion: nil)
    }
}
