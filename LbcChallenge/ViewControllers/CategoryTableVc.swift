//
//  CategoryTableVc.swift
//  LbcChallenge
//
//  Created by Jean-baptiste Watremez on 13/05/2021.
//

import Foundation
import UIKit

class CategoryTableVc: UIViewController {
    
    var tableView : UITableView = UITableView()
    var safeArea: UILayoutGuide!
    
    private var categoriesVm : CategoriesVm!
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.title = "Filtrer les catégories d'annonces"
        self.view.backgroundColor = UIColor.white
        
        if let svc = self.splitViewController {
            // Permet d'avoir le bouton back sur la vue détail.
            let ni = self.navigationItem
            ni.setLeftBarButton(svc.displayModeButtonItem, animated: false)
            ni.leftItemsSupplementBackButton = true ;
        }
        
        super.viewWillAppear(animated)
    }
  
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        safeArea = view.layoutMarginsGuide
        setupTableView()
        callToViewModelForUIUpdate()
    }
    
    func callToViewModelForUIUpdate() {
        categoriesVm = CategoriesVm(onCategoriesUpdate: {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.register(CategoryCellV.self, forCellReuseIdentifier: "categoryCell")
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


extension CategoryTableVc : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesVm.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        _ = categoriesVm.categories[indexPath.row]
        let categoryCellV = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryCellV
        categoryCellV.index = indexPath.row
        return categoryCellV
    }
    
}


// MARK: - UITableViewDelegate



extension CategoryTableVc : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}
