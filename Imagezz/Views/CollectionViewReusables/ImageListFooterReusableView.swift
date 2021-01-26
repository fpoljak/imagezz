//
//  ImageListFooterReusableView.swift
//  Imagezz
//
//  Created by Frane Poljak on 26/01/2021.
//  Copyright © 2021 fpoljak. All rights reserved.
//

import UIKit
import Combine

class ImageListFooterReusableView: UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: ImageListFooterReusableView.self)
    }
    
    @Published var showLoader = false
    
    private var disposables: Set<AnyCancellable> = []
    
    lazy var loadingIndicator: UIActivityIndicatorView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.style = .medium
        return $0
    }(UIActivityIndicatorView())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        addSubview(loadingIndicator)
        loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        loadingIndicator.startAnimating()
        
        $showLoader.sink { [unowned self] (newValue) in
            if newValue {
                self.loadingIndicator.startAnimating()
            } else {
                self.loadingIndicator.stopAnimating()
            }
        }.store(in: &disposables)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
