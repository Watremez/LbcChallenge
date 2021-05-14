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
    var categoryFilterVm : CategoryFilterVm!

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
        setupView()
    }
    
    func setupView(){
        self.categoryFilterV = CategoryFilterV()
        self.categoryFilterV.categoryFilterVm = self.categoryFilterVm
        view.addSubview(categoryFilterV)
        categoryFilterV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoryFilterV.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            categoryFilterV.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            categoryFilterV.topAnchor.constraint(equalTo: safeArea.topAnchor),
            categoryFilterV.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }


}
