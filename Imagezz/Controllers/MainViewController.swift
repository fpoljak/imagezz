//
//  MainViewController.swift
//  Imagezz
//
//  Created by Frane Poljak on 25/01/2021.
//  Copyright © 2021 fpoljak. All rights reserved.
//

import UIKit
import Combine

class MainViewController: UIViewController {

    var viewModel: MainViewModel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var disposables: Set<AnyCancellable> = []
    
    let imageHeight = UIScreen.main.bounds.size.width / 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = MainViewModel(collectionView: collectionView)

        configureCollectionView()
        viewModel.loadImagesList()
    }
    
    private func configureCollectionView() {
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCollectionViewCell")
        collectionView.register(UINib.init(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionViewCell")
        collectionView.register(ImageListFooterReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: ImageListFooterReusableView.reuseIdentifier)
        
        collectionView.dataSource = viewModel.makeDataSource()
        collectionView.delegate = self
        collectionView.collectionViewLayout = createLayout()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let height = UIScreen.main.bounds.size.width / 2
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(height))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .zero
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(height))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(0)
        group.contentInsets = .zero
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .zero
        
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50.0))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        section.boundarySupplementaryItems = [footer]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        layout.configuration.interSectionSpacing = 0
        
        return layout
    }
    
    func openImageDetails(_ item: ImageItem) {
        let vc = ImageDetailViewController()
        vc.viewModel.imageItem = item
        present(vc, animated: true, completion: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // handle orientation change
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.collectionViewLayout = createLayout()
    }
}

// MARK: - UICollectionViewDelegate Implementation
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = viewModel.items.value[indexPath.item]
        openImageDetails(item)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if viewModel.isLoading || viewModel.reachedEnd {
            return
        }
        let scrollY = scrollView.contentOffset.y
        let scrollingUp = scrollY < viewModel.lastScrollY
        viewModel.lastScrollY = scrollY
        if scrollingUp {
            return
        }
        if scrollY > scrollView.contentSize.height - scrollView.bounds.size.height - imageHeight * 1.5 {
            viewModel.loadImagesList()
        }
    }
}
