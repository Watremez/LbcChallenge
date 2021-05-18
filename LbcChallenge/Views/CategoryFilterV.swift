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
    }
    
    func setup(withCategoryFilterViewModel vm : CategoryFilterVmProtocol) {
        self.vm = vm
        guard let viewModel = self.vm else { return }
        self.vm!.choices.valueChanged = { _ in
            self.picker.reloadAllComponents()
            self.updateSelectedCategory()
        }
        self.vm!.selectedCategory.valueChanged = { _ in
            self.updateSelectedCategory()
        }
        if viewModel.choices.loaded {
            self.picker.reloadAllComponents()
        }
        self.updateSelectedCategory()
    }
    
    func updateSelectedCategory() {
        guard let viewModel = self.vm else { return }
        picker.selectRow(viewModel.getSelectedCategoryIndex(), inComponent: 0, animated: false)
    }
    
    
}


// MARK: - UIPickerViewDataSource

extension CategoryFilterV : UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let viewModel = self.vm else { return 0 }
        return viewModel.choices.value.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let viewModel = self.vm else { return nil }
        return viewModel.choices.value[row]
    }
    
}


// MARK: - UIPickerViewDelegate

extension CategoryFilterV : UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let viewModel = self.vm else { return }
        viewModel.selectCategory(at: row)
    }
    
}

