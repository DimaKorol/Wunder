//
//  CarListScreen+View.swift
//  Wunder
//
//  Created by Dima Korolev on 05/11/2019.
//  Copyright © 2019 Dima Korolev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class CarListScreenViewController: UIViewController {
    
    private let tableView = UITableView().mutate {
        $0.register(cell: CarListItemCell.self)
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 60
    }
    
    private let topBar = TopBarView().mutate {
        $0.title.text = Strings.localized(.listScreenTitle)
    }
    
    private var items: [CarListItemViewModel] = [] {
        didSet { tableView.reloadData() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        
        [tableView, topBar].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            topBar.topAnchor.constraint(equalTo: view.topAnchor),
            topBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            topBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            tableView.topAnchor.constraint(equalTo: topBar.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension CarListScreenViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = items[safe: indexPath.row].expectedValue() else { return UITableViewCell() }
        let cell: CarListItemCell = tableView.dequeueCell(for: indexPath)
        cell.bind(item)
        return cell
    }
}

extension CarListScreenViewController: CarListScreenView {

    func bind(_ viewModel: CarListScreenViewModel) -> Disposable {
        let disposable = CompositeDisposable()
        _ = disposable.insert(topBar.backButton.bind(viewModel.back))
        _ = disposable.insert(viewModel.items.drive(onNext: { [weak self] in self.expectedValue()?.items = $0 }))
        return disposable
    }
}

extension UITableView {
    
    func register<T: UITableViewCell>(cell: T.Type) where T: Reusable {
        register(cell.self, forCellReuseIdentifier: cell.reuseIdentifier)
    }
    
    public func dequeueCell<T: UITableViewCell>(_ cell: T.Type = T.self, for indexPath: IndexPath) -> T where T: Reusable {
        guard
            let cell = (dequeueReusableCell(withIdentifier: cell.reuseIdentifier, for: indexPath) as? T).expectedValue()
        else { return T() }
        return cell
    }
}

extension Array {

    public subscript(safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
