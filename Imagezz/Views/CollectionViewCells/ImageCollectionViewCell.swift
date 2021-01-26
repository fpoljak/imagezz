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
    
    var item: ImageItem?
    
    @IBOutlet weak private var imageView: UIImageView!
    
    let size = UIScreen.main.bounds.size.width * UIScreen.main.scale / 2
    
    private lazy var imageFilter: ImageFilter = AspectScaledToFillSizeFilter(size: CGSize(width: size, height: size))
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.contentMode = .scaleAspectFill
        let gradientLayer = CAGradientLayer()
        let size = UIScreen.main.bounds.size.width / 2
        gradientLayer.frame = CGRect(origin: .zero, size: CGSize(width: size, height: size))
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.lightGray.withAlphaComponent(0.3).cgColor]
        contentView.layer.insertSublayer(gradientLayer, below: contentView.layer.sublayers!.last!)
        imageView.backgroundColor = .clear
    }
    
    func provide(_ item: ImageItem) {
        self.item = item
        imageView.image = nil // to prevent briefly showing wrong image
        imageView.af.setImage(withURL: item.downloadUrl, placeholderImage: nil, filter: imageFilter, imageTransition: .crossDissolve(0.25), runImageTransitionIfCached: true)
    }
}
