//
//  CollectionController.swift
//  CompositionalLayout
//
//  Created by SJ Basak on 28/04/26.
//


import UIKit
import Combine

@Observable
class CollectionController {
    private let sections      = ["first", "second", "third"]
    private let items         = Array(1...8)
    private let secondItems   = Array(9...19)
    private let thirdItems    = Array(20...30)
    
    var snapShot: NSDiffableDataSourceSnapshot<String, Int>?
    
    init() {
        var snap = NSDiffableDataSourceSnapshot<String, Int>()
        
        snap.appendSections([self.sections[0]])
        snap.appendItems(self.items)
        snap.appendSections([self.sections[1]])
        snap.appendItems(self.secondItems)
        snap.appendSections([self.sections[2]])
        snap.appendItems(self.thirdItems)
        
        self.snapShot = snap
    }
}
