//
//  CategoryFilterVc.swift
//  LbcChallenge
//
//  Created by Jean-baptiste Watremez on 14/05/2021.
//

import Foundation
import UIKit

class CategoryFilterVc: UIViewController {
    
    var categoryFilterV : CategoryFilterV!
    var safeArea: UILayoutGuide!
    
    weak var vm : CategoryFilterVm? = nil

    override func viewWillAppear(_ animated: Bool) {
        print("View will appear")
        self.title = "Filtrer les catégories d'annonces"
        self.view.backgroundColor = UIColor.white

        setupView()

        if let svc = self.splitViewController {
            // Permet d'avoir le bouton back sur la vue détail.
            let ni = self.navigationItem
            ni.setLeftBarButton(svc.displayModeButtonItem, animated: false)
            ni.leftItemsSupplementBackButton = true ;
        }
        
        super.viewWillAppear(animated)
    }
  
    override func loadView() {
        print("Load view")
        super.loadView()

        view.backgroundColor = .white
        safeArea = view.layoutMarginsGuide
    }
    
    func setupView(){
        guard let viewModel = self.vm else { return }
        print("Setup View")
        self.categoryFilterV = CategoryFilterV()
        self.categoryFilterV.setup(vm: viewModel)
        view.addSubview(categoryFilterV)
        categoryFilterV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoryFilterV.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            categoryFilterV.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            categoryFilterV.topAnchor.constraint(equalTo: safeArea.topAnchor),
            categoryFilterV.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    func setup(vm: CategoryFilterVm){
        print("Setup ViewModel")
        self.vm = vm
    }


}
