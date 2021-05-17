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
    private weak var vm : CategoryFilterVmProtocol? = nil
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLblSelectedCategory()
        setupCategorySelectionPicker()
        setupPlacement()
    }
    
    func setupLblSelectedCategory(){
        lblSelectedCategory = UILabel()
        lblSelectedCategory.numberOfLines = 0
        lblSelectedCategory.lineBreakMode = .byWordWrapping
        lblSelectedCategory.text = "Afficher les annonces du type : "
        self.addSubview(lblSelectedCategory)
        lblSelectedCategory.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupCategorySelectionPicker(){
        picker = UIPickerView()
        self.picker.dataSource = self
        self.picker.delegate = self
        self.addSubview(picker)
        picker.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func setupPlacement() {
        let viewsDict : [String : Any] = [
            "selectedCategory" : (lblSelectedCategory as Any),
            "categoryPicker" : (picker as Any)
        ]
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[selectedCategory]|", options: [], metrics: nil, views: viewsDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[categoryPicker]|", options: [], metrics: nil, views: viewsDict))

        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[selectedCategory]-[categoryPicker]", options: [], metrics: nil, views: viewsDict))
        
//        picker.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
//        picker.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
//        picker.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    func setup(withCategoryFilterViewModel vm : CategoryFilterVmProtocol) {
        self.vm = vm
        guard let viewModel = self.vm else { return }
        self.vm!.categories.valueChanged = { _ in
            self.picker.reloadAllComponents()
        }
        self.vm!.selectedCategory.valueChanged = { maybeNewlySelectedCategory in
            self.updateSelectedCategory()
        }
        if viewModel.categories.loaded {
            self.picker.reloadAllComponents()
        }
        if viewModel.selectedCategory.loaded {
            self.updateSelectedCategory()
        }
    }
    
    func updateSelectedCategory() {
        guard let viewModel = self.vm else { return }
        var bPickedPresetDone : Bool = false
        viewModel.selectedCategory.value.map { cat in
            if let index = viewModel.categories.value.firstIndex(where: { oneCategory in
                oneCategory.id == cat.id
            }) {
                picker.selectRow(index + 1, inComponent: 0, animated: false)
                bPickedPresetDone = true
            }
        }
        if !bPickedPresetDone {
            picker.selectRow(0, inComponent: 0, animated: false)
        }
    }
    
    
}


// MARK: - UIPickerViewDataSource

extension CategoryFilterV : UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let viewModel = self.vm else { return 0 }
        return viewModel.categories.value.count + 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let viewModel = self.vm else { return nil }
        if row == 0 {
            return "Toutes les catégories"
        } else {
            return viewModel.categories.value[row-1].name
        }
    }
    
}


// MARK: - UIPickerViewDelegate

extension CategoryFilterV : UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let viewModel = self.vm else { return }
        viewModel.selectCategory(at: row)
    }
    
}

