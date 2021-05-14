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
    private var lblSelectedCategory : UILabel!
    private var picker : UIPickerView!
    
    // Members
    var categoryFilterVm : CategoryFilterVm! {
        didSet {
            self.categoryFilterVm.categoriesUpdated = onCategoriesUpdated
            self.categoryFilterVm.categorySelectionUpdated = onCategorySelectionUpdated

            setupLblSelectedCategory()
            setupCategorySelectionPicker()
            
            setupPlacement()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    func onCategoriesUpdated() {
        DispatchQueue.main.async {
            self.picker.reloadAllComponents()
        }
    }
    
    func onCategorySelectionUpdated(maybeNewlySelectedCategory : Category?) {
        if let selectedCategory = maybeNewlySelectedCategory {
            self.lblSelectedCategory.text = String("N'afficher que les annonces de la catégorie : \(selectedCategory.name)")
        } else {
            self.lblSelectedCategory.text = "Afficher toutes les annonces"
        }
    }
    
    func setupLblSelectedCategory(){
        lblSelectedCategory = UILabel()
        lblSelectedCategory.numberOfLines = 0
        lblSelectedCategory.lineBreakMode = .byWordWrapping
        self.addSubview(lblSelectedCategory)
        lblSelectedCategory.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupCategorySelectionPicker(){
        picker = UIPickerView()
        self.picker.dataSource = self
        self.picker.delegate = self
        self.addSubview(picker)
        picker.translatesAutoresizingMaskIntoConstraints = false
        var bPickedPresetDone : Bool = false
        if let selectedCategory = self.categoryFilterVm.categorySelected {
            if let index = self.categoryFilterVm.categories.firstIndex { oneCategory in
                oneCategory.id == selectedCategory.id
            } {
                picker.selectRow(index + 1, inComponent: 0, animated: false)
                bPickedPresetDone = true
            }
        }
        if !bPickedPresetDone {
            picker.selectRow(0, inComponent: 0, animated: false)
        }
    }
    
    
    func setupPlacement() {
        let viewsDict : [String : Any] = [
            "selectedCategory" : (lblSelectedCategory as Any),
            "categoryPicker" : (picker as Any)
        ]
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[selectedCategory]|", options: [], metrics: nil, views: viewsDict))
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[selectedCategory]", options: [], metrics: nil, views: viewsDict))

        picker.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        picker.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
        picker.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    
}


// MARK: - UIPickerViewDataSource

extension CategoryFilterV : UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.categoryFilterVm.categories.count + 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return "Toutes les catégories"
        } else {
            return self.categoryFilterVm.categories[row-1].name
        }
    }
    
}


// MARK: - UIPickerViewDelegate

extension CategoryFilterV : UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            self.categoryFilterVm.categorySelected = nil
        } else {
            self.categoryFilterVm.categorySelected = self.categoryFilterVm.categories[row-1]
        }
    }
    
}

