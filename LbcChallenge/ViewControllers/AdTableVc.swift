//
//  ViewController.swift
//  LbcChallenge
//
//  Created by Jean-baptiste Watremez on 10/05/2021.
//

import UIKit

class AdTableVc: UIViewController {
    
    var tableView : UITableView = UITableView()
    var safeArea: UILayoutGuide!
  
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        safeArea = view.layoutMarginsGuide
        setupTableView()

        Notification.Name.AdsDownloaded.onNotified { [weak self] note in
           guard let `self` = self else { return }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 160
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        tableView.register(AdCellV.self, forCellReuseIdentifier: "adCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }


}


// MARK:  - UITableViewDataSource


extension AdTableVc : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let ads = Content.shared.ads
        return ads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let oneAd = Content.shared.ads[indexPath.row]
        let adCellV = tableView.dequeueReusableCell(withIdentifier: "adCell", for: indexPath) as! AdCellV
        adCellV.initViewModel(
            AdCellVm(
                pictureUrl: oneAd.images_url.thumb,
                category: oneAd.category,
                title: oneAd.title,
                price: oneAd.price,
                urgent: oneAd.is_urgent,
                depositDate: oneAd.creation_date,
                viewThatUsesThisViewModel: adCellV)
        )
        return adCellV
    }
    
}


// MARK: - UITableViewDelegate
extension AdTableVc : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // As soon as the cell is not displayed anymore then cancel its delegate because it could receive an old anychronous downloaded image.
        (cell as! AdCellV).viewModel.oneViewThatUsesThisViewModel = nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = AdDetailVc()
        let oneAd = Content.shared.ads[indexPath.row]
        let oneAdViewModel = AdDetailVm(
            pictureUrl: oneAd.images_url.small,
            category: oneAd.category,
            title: oneAd.title,
            price: oneAd.price,
            urgent: oneAd.is_urgent,
            depositDate: oneAd.creation_date,
            description: oneAd.description,
            viewThatUsesThisViewModel: vc
        )
        vc.viewModel = oneAdViewModel
        
        let nc = UINavigationController()
        nc.viewControllers = [vc]
        
        self.showDetailViewController(nc, sender: self)
    }

}
