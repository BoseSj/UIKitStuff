//
//  ViewController.swift
//  CompositionalLayout
//
//  Created by SJ Basak on 28/04/26.
//

import UIKit
import Combine


final class ViewController: UIViewController, UICollectionViewDelegate {

    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: ViewController.createLayout()
    )
    
    private var collectionController = CollectionController()
    private var cancellable: Set<AnyCancellable> = .init()
    
    private var dataSource: UICollectionViewDiffableDataSource<String, Int>!
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpView()
    }
    
    override func updateProperties() {
        if let snapShot = self.collectionController.snapShot {
            self.dataSource.apply(snapShot)
        }
    }

}


/// UI
private extension ViewController {
    func setUpView() {
        self.title = "Compositional Layout"
        
        self.collectionView.register(ImageCVCell.self, forCellWithReuseIdentifier: ImageCVCell.identifier)
        self.collectionView.delegate = self
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.frame = self.view.bounds
        self.view.addSubview(self.collectionView)
        
        self.dataSource = UICollectionViewDiffableDataSource(
            collectionView: self.collectionView,
            cellProvider: {
                collectionView, indexPath, item in
                
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ImageCVCell.identifier,
                    for: indexPath
                ) as! ImageCVCell
                cell.populateData(with: item)
                
                return cell
        })
    }
}

/// Layout
extension ViewController {
    static func sectionLayout() -> NSCollectionLayoutSection {
        /// Item
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1/2),
                heightDimension: .fractionalHeight(1)
            )
        )
        let subitem = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1/2)
            )
        )
        let topsubitem = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1/2),
                heightDimension: .fractionalHeight(1)
            )
        )
        
        for cellItem in [item, subitem, topsubitem] {
            cellItem.contentInsets = .init(
                top: 5, leading: 5, bottom: 5, trailing: 5
            )
        }
        
        /// Group
        let topsubgroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1/2)
            ),
            repeatingSubitem: topsubitem,
            count: 2
        )
        let subgroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/2),
                heightDimension: .fractionalHeight(1)
            ),
            subitems: [
                topsubgroup, subitem
            ]
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1/5)
            ),
            subitems: [
                item, subgroup
            ]
        )
        
        /// Section
        return NSCollectionLayoutSection(group: group)
    }
    static func alternateSectionLayout(
        scrolling: UICollectionLayoutSectionOrthogonalScrollingBehavior = .continuous
    ) -> NSCollectionLayoutSection {
        /// Item
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1/2),
                heightDimension: .fractionalHeight(1)
            )
        )
        let subitem = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1/2)
            )
        )
        let topsubitem = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1/2),
                heightDimension: .fractionalHeight(1)
            )
        )
        
        for cellItem in [item, subitem, topsubitem] {
            cellItem.contentInsets = .init(
                top: 5, leading: 5, bottom: 5, trailing: 5
            )
        }
        
        /// Group
        let topsubgroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1/2)
            ),
            repeatingSubitem: topsubitem,
            count: 2
        )
        let subgroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/2),
                heightDimension: .fractionalHeight(1)
            ),
            subitems: [
                topsubgroup, subitem
            ]
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1/5)
            ),
            subitems: [
                subgroup, item
            ]
        )
        
        /// Section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = scrolling
        return section
    }
    
    static func createLayout() -> UICollectionViewCompositionalLayout {
        /// Layout
        return UICollectionViewCompositionalLayout(sectionProvider: { index, _ in
            if index == 0 {
                sectionLayout()
            } else if index == 1 {
                alternateSectionLayout(scrolling: .continuousGroupLeadingBoundary)
            } else {
                alternateSectionLayout(scrolling: .paging)
            }
        })
    }
}
