//
//  CategoryFilterV.swift
//  LbcChallenge
//
//  Created by Jean-baptiste Watremez on 14/05/2021.
//

import Foundation
import UIKit


class CategoryFilterV : UIView {
    // Outlets
    private var lblTitle : UILabel!
    var tableView : UITableView!

    // Members
    private var vm : CategoryFilterVmProtocol? = nil
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLblSelectedCategory()
        setupTableView()
        setupPlacement()
    }
    
    func setupLblSelectedCategory(){
        lblTitle = UILabel()
        lblTitle.numberOfLines = 0
        lblTitle.lineBreakMode = .byWordWrapping
        lblTitle.text = "Catégories"
        lblTitle.font = UIFont.preferredFont(forTextStyle: .headline)
        self.addSubview(lblTitle)
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupTableView() {
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        self.addSubview(tableView)
        tableView.register(CategoryFilterCellV.self, forCellReuseIdentifier: "categoryFilterCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }

    
    func setupPlacement() {
        let viewsDict : [String : Any] = [
            "title" : (lblTitle as Any),
            "tableView" : (tableView as Any)
        ]
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[title]|", options: [], metrics: nil, views: viewsDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableView]|", options: [], metrics: nil, views: viewsDict))

        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-30-[title]-[tableView]-|", options: [], metrics: nil, views: viewsDict))
    }
    
    func setup(withCategoryFilterViewModel vm : CategoryFilterVmProtocol) {
        self.vm = vm
        guard let viewModel = self.vm else { return }
        viewModel.choices.valueChanged = { _ in
            self.tableView.reloadData()
        }
        if viewModel.choices.loaded {
            self.tableView.reloadData()
        }
    }
    
    
}



// MARK:  - UITableViewDataSource


extension CategoryFilterV : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = self.vm else { return 0 }
        return viewModel.choices.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = self.vm else { return UITableViewCell() }
        let adCategoryFilterCellV = tableView.dequeueReusableCell(withIdentifier: "categoryFilterCell", for: indexPath) as! CategoryFilterCellV
        let vm = viewModel.getCategoryFilterCellViewModel(at: indexPath.row)
        adCategoryFilterCellV.setup(withCategoryFilterCellViewModel: vm)
        return adCategoryFilterCellV
    }
    
}


// MARK: - UITableViewDelegate


extension CategoryFilterV : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = self.vm else { return }
        viewModel.selectCategory(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
