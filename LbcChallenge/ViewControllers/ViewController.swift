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
    var ads = [Ad]()
  
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        safeArea = view.layoutMarginsGuide
        setupTableView()

        Notification.Name.AdsDownloaded.onNotified { [weak self] note in
           guard let `self` = self else { return }
            self.ads.removeAll()
            self.ads.append(contentsOf: Content.shared.ads)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
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
        return ads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ItemCellViewController
        let data = ads[indexPath.row]
        cell.initViewModel(
            ItemCellViewModel(
                pictureUrl: data.images_url.thumb,
                category: data.category,
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
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // As soon as the cell is not displayed anymore then cancel its delegate because it could receive an old anychronous downloaded image.
        (cell as! ItemCellViewController).viewModel.delegate = nil
    }
    
}
