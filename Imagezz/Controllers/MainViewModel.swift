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
    
    let imageHeight = UIScreen.main.bounds.size.width / 2
    
    init(collectionView: UICollectionView) {
        super.init(collectionView: collectionView, cellReuseIdentifier: "ImageCollectionViewCell")
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCollectionViewCell")
        collectionView.register(UINib.init(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionViewCell")
        collectionView.register(ImageListFooterReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: ImageListFooterReusableView.reuseIdentifier
        )
        
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
    
    func openImageDetails(_ item: ImageItem) {
        
    }
}

// MARK: - UICollectionViewDelegate Implementation
extension MainViewModel: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items.value[indexPath.item]
        openImageDetails(item)
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
        if scrollY > scrollView.contentSize.height - scrollView.bounds.size.height - imageHeight * 1.5 {
            loadImagesList()
        }
    }
}
