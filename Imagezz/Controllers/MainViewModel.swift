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
    
    @Published var isLoading = false
    
    private var disposables: Set<AnyCancellable> = []
    
    init(collectionView: UICollectionView) {
        super.init(collectionView: collectionView, cellReuseIdentifier: "ImageCollectionViewCell")
        
        // trigger update to show/hide loader on bottom
        $isLoading.sink { [unowned self] (newValue) in
            self.update()
        }.store(in: &disposables)
    }
    
    override func makeDataSource() -> CollectionViewModel<ImageCollectionViewCell, ImageListSection>.DataSource {
        let dataSource = super.makeDataSource()
        
        dataSource.supplementaryViewProvider = { [unowned self] collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionFooter else {
                return nil
            }
            
            guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ImageListFooterReusableView.reuseIdentifier, for: indexPath) as? ImageListFooterReusableView else {
                return nil
            }
            
            footer.showLoader = self.isLoading
            
            return footer
        }
        
        return dataSource
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
        removeAll()
        currentPage = 0
        reachedEnd = false
        loadImagesList()
    }
}
