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
    var lastScrollY = CGFloat(0)
    var reachedEnd = false
    var isLoading = false
    
    init(collectionView: UICollectionView) {
        super.init(collectionView: collectionView, cellReuseIdentifier: "ImageCollectionViewCell")
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCollectionViewCell")
        collectionView.register(UINib.init(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionViewCell")
    }
    
    func loadImagesList() {
        currentPage += 1
        isLoading = true
        ImageApiService.getImagesList(page: currentPage) { [weak self] (response) in
            guard let this = self else {
                return
            }
            let items = response ?? []
            this.add(items)
            this.reachedEnd = items.count == 0
            this.isLoading = false
        }
    }
    
    func reloadImages() {
        remove(items.value)
        currentPage = 0
        reachedEnd = false
        loadImagesList()
    }
}

// MARK: - UICollectionViewDelegate Implementation
extension MainViewModel: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items.value[indexPath.item]
        // ...
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isLoading || reachedEnd {
            return
        }
        let scrollY = scrollView.contentOffset.y
        let scrollingUp = scrollY < lastScrollY
        lastScrollY = scrollY
        if scrollingUp {
            return
        }
        if scrollY > scrollView.contentSize.height - scrollView.bounds.size.height - 200 {
            loadImagesList()
        }
    }
}
