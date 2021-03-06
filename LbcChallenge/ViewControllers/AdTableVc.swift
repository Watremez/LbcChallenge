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

    private var adListVm : AdListVmProtocol? = nil
    private var categoryFilterVm : CategoryFilterVmProtocol? = nil
    private var whereToGetSelectedCategoryVm : (() -> SelectedCategoryVmProtocol?)? = nil

    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        safeArea = view.layoutMarginsGuide
        setupTableView()
        setupNavigationBar()
        setupPlacement()
    }
    
    func setup(adListViewModel adListVm : AdListVmProtocol, categoryFilterViewModel categoryFilterVm : CategoryFilterVmProtocol, whereToGetSelectedCategoryViewModel whereToGetSelectedCategoryVm : @escaping () -> SelectedCategoryVmProtocol?) {
        self.adListVm = adListVm
        self.adListVm!.reloadTableViewClosure = {
            self.tableView.reloadData()
            self.setupSelectedCategoryBarButton()
        }
        self.tableView.reloadData()
        
        self.categoryFilterVm = categoryFilterVm
        
        self.whereToGetSelectedCategoryVm = whereToGetSelectedCategoryVm
    }

    @objc func OnFliterClick(){
        guard let catFilterVm = self.categoryFilterVm else { return }
        let vc = CategoryFilterVc()
        vc.setup(withCategoryFilterViewModel: catFilterVm)
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
    
    func setupSelectedCategoryBarButton(){
        if let getVm = self.whereToGetSelectedCategoryVm {
            if let selCatVm = getVm() {
                let selectedCategoryView = SelectedCategoryV()
                selectedCategoryView.setup(withSelectedCategoryViewModel: selCatVm)
                navigationItem.leftBarButtonItem = UIBarButtonItem(customView: selectedCategoryView)
                return
            }
        }
        navigationItem.leftBarButtonItem = nil
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
        adCellV.setup(withCellViewModel: vm)
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
        vc.setup(withAdDetailViewModel: vm)
        
        let nc = UINavigationController()
        nc.viewControllers = [vc]
        
        self.showDetailViewController(nc, sender: self)
    }

}
