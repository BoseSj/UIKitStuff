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
        Task {
            do {
                snapShot = NSDiffableDataSourceSnapshot<String, Int>()
                
                try await Task.sleep(for: .seconds(0.7))
                self.snapShot?.appendSections([self.sections[0]])
                self.snapShot?.appendItems(self.items)
                
                try await Task.sleep(for: .seconds(0.7))
                self.snapShot?.appendSections([self.sections[1]])
                self.snapShot?.appendItems(self.secondItems)
                
                try await Task.sleep(for: .seconds(0.7))
                self.snapShot?.appendSections([self.sections[2]])
                self.snapShot?.appendItems(self.thirdItems)
            }
        }
    }
}
