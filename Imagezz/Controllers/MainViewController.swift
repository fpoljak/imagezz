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
    
    private var tokens = [AnyCancellable]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        viewModel = MainViewModel(collectionView: collectionView)

        configureCollectionView()
        viewModel.loadImagesList()
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = viewModel.makeDataSource()
        collectionView.delegate = viewModel
        collectionView.collectionViewLayout = createLayout()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let height = UIScreen.main.bounds.size.width / 2
        // orientation change!!!
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(height))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .zero
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(height))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(0)
        group.contentInsets = .zero
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .zero
        
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
