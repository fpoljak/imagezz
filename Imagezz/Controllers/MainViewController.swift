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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = MainViewModel(collectionView: collectionView)

        configureCollectionView()
        viewModel.loadImagesList()
        
        viewModel.$selectedItem.sink { [unowned self] (item) in
            guard let item = item else {
                return
            }
            let vc = ImageDetailViewController()
            vc.viewModel.imageItem = item
            self.present(vc, animated: true, completion: nil)
        }.store(in: &disposables)
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = viewModel.makeDataSource()
        collectionView.delegate = viewModel
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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // handle orientation change
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.collectionViewLayout = createLayout()
    }
}
