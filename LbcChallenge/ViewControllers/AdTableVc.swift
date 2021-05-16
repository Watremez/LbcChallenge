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

    private var categoryFilterVm : CategoryFilterVm  = CategoryFilterVm()
    private var appVm : AppVm!
    private var adListVm : AdListVm? = nil

    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        safeArea = view.layoutMarginsGuide
        setupTableView()
        setupNavigationBar()
        setupPlacement()
        
        updateViewBasedOnViewModel()
    }
    
    func updateViewBasedOnViewModel() {
        appVm = AppVm()
        appVm.appIsLoading.valueChanged = { appLoadingStatus in
            if appLoadingStatus == false {
                self.adListVm = self.appVm.adListViewModel
                self.adListVm!.reloadTableViewClosure = {
                    self.tableView.reloadData()
                }
                self.tableView.reloadData()
            }
        }
        appVm.initFetch()
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
        navigationItem.rightBarButtonItem = btnFiltrer
    }

    
    func setupPlacement() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }

}


// MARK:  - UITableViewDataSource


extension AdTableVc : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.adListVm?.numberOfCells ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let adListViewModel = self.adListVm else {
            return UITableViewCell()
        }
        let vm = adListViewModel.getCellViewModel(at: indexPath)
        let adCellV = tableView.dequeueReusableCell(withIdentifier: "adCell", for: indexPath) as! AdCellV
        adCellV.setup(vm: vm)
        return adCellV
    }
    
}


// MARK: - UITableViewDelegate


extension AdTableVc : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let adListViewModel = self.adListVm else {
            return
        }
        let vc = AdDetailVc()
        let vm = adListViewModel.getDetailViewModel(at: indexPath)
        vc.setup(vm: vm)
        
        let nc = UINavigationController()
        nc.viewControllers = [vc]
        
        self.showDetailViewController(nc, sender: self)
    }

}
