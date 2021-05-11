//
//  ViewController.swift
//  LbcChallenge
//
//  Created by Jean-baptiste Watremez on 10/05/2021.
//

import UIKit

class ViewController: UIViewController {
    
    var tableView : UITableView = UITableView()
    var safeArea: UILayoutGuide!
    let items = Bundle.main.decodeJsonFile([Item].self, from: "data")
  
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        safeArea = view.layoutMarginsGuide
        setupTableView()
    }
    
    
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.rowHeight = 120
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        tableView.register(ItemCellViewController.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }


}


// MARK:  - UITableViewDatasource


extension ViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ItemCellViewController
        let data = items[indexPath.row]
        cell.initViewModel(
            ItemCellViewModel(
                pictureUrl: data.images_url.thumb,
                category: .automobile,
                title: data.title,
                price: data.price,
                urgent: data.is_urgent,
                delegate: cell)
        )
        return cell
    }
    
    
}


// MARK: - UITableViewDelegate
extension ViewController : UITableViewDelegate {
    
}
