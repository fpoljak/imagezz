//
//  CollectionViewModel.swift
//  Imagezz
//
//  Created by Frane Poljak on 25/01/2021.
//  Copyright © 2021 fpoljak. All rights reserved.
//

import UIKit
//import Combine

class CollectionViewModel<CellType: UICollectionViewCell & Providable, SectionIdentifierType: Hashable & CaseIterable>: NSObject {
    typealias Item = CellType.ProvidedItem
    typealias DataSource = UICollectionViewDiffableDataSource<SectionIdentifierType, Item>
    
    private weak var collectionView: UICollectionView?
    
    public var items: Binding<[Item]> = .init([])
    
    private var dataSource: DataSource?
    private var cellIdentifier: String
    
    init(collectionView: UICollectionView, cellReuseIdentifier: String) {
        self.cellIdentifier = cellReuseIdentifier
        self.collectionView = collectionView
        super.init()
    }

    private func cellProvider(_ collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell? {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CellType
        cell.provide(item)
        return cell
    }
    
    public func makeDataSource() -> DataSource {
        guard let collectionView = collectionView else { fatalError("CollectionView not found!") }
        let dataSource = DataSource(collectionView: collectionView, cellProvider: cellProvider)
        self.dataSource = dataSource
        return dataSource
    }
}

extension CollectionViewModel {
    func update() {
        DispatchQueue.main.async { [weak self] () in
            guard let dataSource = self?.dataSource else {
                return
            }
            var snapshot = NSDiffableDataSourceSnapshot<SectionIdentifierType, Item>()
            snapshot.appendSections(SectionIdentifierType.allCases as! [SectionIdentifierType])
            snapshot.appendItems(self!.items.value)
            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
        
    public func add(_ items: [Item]) {
        items.forEach {
            self.items.value.append($0)
        }
        update()
    }

    public func remove(_ items: [Item]) {
        items.forEach { item in
            self.items.value.removeAll { $0 == item }
        }
        update()
    }
    
    public func removeAll() {
        items.value.removeAll()
        update()
    }
}
