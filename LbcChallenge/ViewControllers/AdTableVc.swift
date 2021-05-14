//
//  ViewController.swift
//  LbcChallenge
//
//  Created by Jean-baptiste Watremez on 10/05/2021.
//

import UIKit

class AdTableVc: UIViewController {
    
    var tableView : UITableView = UITableView()
    var navigationBar : UINavigationBar = UINavigationBar()
    var safeArea: UILayoutGuide!

    private var adsVm : AdsVm!
    private var categoryFilterVm : CategoryFilterVm  = CategoryFilterVm()

    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        safeArea = view.layoutMarginsGuide
        setupTableView()
        setupNavigationBar()
        setupPlacement()
        
        callToViewModelForUIUpdate()
    }
    
    func callToViewModelForUIUpdate() {
        adsVm = AdsVm(onAdsUpdate: {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }

    @objc func OnFliterClick(){
        
        let vc = CategoryFilterVc()
        vc.categoryFilterVm = self.categoryFilterVm
        
        let nc = UINavigationController()
        nc.viewControllers = [vc]
        
        self.showDetailViewController(nc, sender: self)
        
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 160
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        tableView.register(AdCellV.self, forCellReuseIdentifier: "adCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupNavigationBar() {
        let btnFiltrer = UIBarButtonItem(title: "Filtrer", style: .plain, target: self, action: #selector(OnFliterClick))
        if #available(iOS 13.0, *){
            view.addSubview(navigationBar)
            navigationBar.translatesAutoresizingMaskIntoConstraints = false
            let navigationItem = UINavigationItem()
            navigationItem.rightBarButtonItem = btnFiltrer
            navigationBar.items = [navigationItem]
        } else {
            navigationItem.rightBarButtonItem = btnFiltrer
        }
    }

    func setupPlacement() {
        
        if #available(iOS 13.0, *){
            NSLayoutConstraint.activate([
                navigationBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                navigationBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                navigationBar.topAnchor.constraint(equalTo: safeArea.topAnchor),
                
                navigationBar.bottomAnchor.constraint(equalTo: tableView.topAnchor),
                
                tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
                tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
            ])
            
//            let viewsDict : [String : Any] = [
//                "ads" : tableView,
//                "nav" : navigationBar
//                ]
//            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[nav]", options: [], metrics: nil, views: viewsDict))
        } else {
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
                tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
                tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
            ])
        }



    }

}


// MARK:  - UITableViewDataSource


extension AdTableVc : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adsVm.ads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let oneAd = adsVm.ads[indexPath.row]
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
        let oneAd = adsVm.ads[indexPath.row]
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
