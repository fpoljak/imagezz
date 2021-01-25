//
//  ImageCollectionViewCell.swift
//  Imagezz
//
//  Created by Frane Poljak on 25/01/2021.
//  Copyright © 2021 fpoljak. All rights reserved.
//

import UIKit
import AlamofireImage

public enum ImageListSection: CaseIterable {
    case main
}

class ImageCollectionViewCell: UICollectionViewCell, Providable {
    typealias ProvidedItem = ImageItem
    
    @IBOutlet weak private var imageView: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func provide(_ item: ImageItem) {
        imageView?.af.setImage(withURL: item.downloadUrl)
    }
}
