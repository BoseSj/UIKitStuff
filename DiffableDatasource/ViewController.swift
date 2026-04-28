//
//  ViewController.swift
//  DiffableDatasource
//
//  Created by SJ Basak on 27/04/26.
//

import UIKit
import Combine



enum BasketSection {
    case `main`
}

struct Fruit: Hashable, Identifiable, Sendable {
    let id = UUID()
    let name: String

    static let dummyData: [Fruit] = [
        Fruit(name: "Apple"),
        Fruit(name: "Banana"),
        Fruit(name: "Orange"),
        Fruit(name: "Mango"),
        Fruit(name: "Grapes"),
        Fruit(name: "Pineapple"),
        Fruit(name: "Strawberry"),
        Fruit(name: "Blueberry"),
        Fruit(name: "Watermelon"),
        Fruit(name: "Papaya"),
        Fruit(name: "Kiwi"),
        Fruit(name: "Peach")
    ]
}

@MainActor
final class ViewController: UIViewController, UITableViewDelegate {
    private let tableView = {
        let tbl = UITableView()
        tbl.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return tbl
    }()
    
    private var fruitList: Set<Fruit> = .init()
    private var fruits: [Fruit] {
        Array(fruitList).sorted(by: { $0.name < $1.name })
    }
    
    private var dataSource: UITableViewDiffableDataSource<BasketSection, Fruit>!
    
    private var isLoading: Bool = false {
        didSet {
            self.updateLoadingState()
        }
    }
    private let loader = UIActivityIndicatorView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.addData()
    }
    
    private func updateLoadingState() {
        if self.isLoading {
            self.loader.startAnimating()
        } else {
            self.loader.stopAnimating()
        }
    }
}

/// Actions
private extension ViewController {
    func addData() {
        guard !self.isLoading else { return }
        Task {
            self.isLoading = true
            defer { self.isLoading = false }
            for fruit in Fruit.dummyData {
                self.fruitList.insert(fruit)
                
                self.updateDataSource()
                
                try await Task.sleep(for: .seconds(2))
            }
        }
    }
    
    func updateDataSource() {
        var snapShot = NSDiffableDataSourceSnapshot<BasketSection, Fruit>()
        snapShot.appendSections([.main])
        snapShot.appendItems(self.fruits)
        
        self.dataSource.apply(snapShot)
    }
}

/// UI
private extension ViewController {
    func setupView() {
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.tableView)
        self.tableView.frame = self.view.bounds
        self.tableView.delegate = self
        
        self.dataSource = UITableViewDiffableDataSource(
            tableView: self.tableView,
            cellProvider: { tableView, indexPath, fruit in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            cell.textLabel?.text = fruit.name
            
            return cell
        })
        
        self.title = "Fruit Basket"
        
        self.loader.translatesAutoresizingMaskIntoConstraints = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.loader)
        self.navigationItem.leftBarButtonItem?.hidesSharedBackground = true
    }
}

/// TableView
extension ViewController {
    func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        UISwipeActionsConfiguration(
            actions: [UIContextualAction(
                style: .destructive,
                title: "Remove",
                handler: { _, _, _ in
                    if self.fruits.count > indexPath.row {
                        self.fruitList.remove(self.fruits[indexPath.row])
                        self.updateDataSource()
                    }
                }
            )]
        )
    }
}
