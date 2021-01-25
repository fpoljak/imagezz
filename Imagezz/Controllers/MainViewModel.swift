//
//  MainViewModel.swift
//  Imagezz
//
//  Created by Frane Poljak on 25/01/2021.
//  Copyright © 2021 fpoljak. All rights reserved.
//

import UIKit
import Combine

class MainViewModel: CollectionViewModel<ImageCollectionViewCell, ImageListSection> {
    var currentPage = 0
    
    init(collectionView: UICollectionView) {
        super.init(collectionView: collectionView, cellReuseIdentifier: "ImageCollectionViewCell")
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCollectionViewCell")
        collectionView.register(UINib.init(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionViewCell")
    }
    
    func loadImagesList() {
        currentPage += 1
        ImageApiService.getImagesList(page: currentPage) { [weak self] (response) in
            guard let this = self else {
                return
            }
            print(response ?? [])
            this.add(response ?? [])
        }
    }
    
    func reloadImages() {
        remove(items.value)
        currentPage = 0
        loadImagesList()
    }
}

// MARK: - UICollectionViewDelegate Implementation
extension MainViewModel: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items.value[indexPath.item]
        // ...
    }
}
