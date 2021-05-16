//
//  CategoryCellV.swift
//  LbcChallenge
//
//  Created by Jean-baptiste Watremez on 14/05/2021.
//

import Foundation
import UIKit

class CategoryCellV : UITableViewCell {
    // Outlets
    var lblName : UILabel!
    
    // Members
    private var mPr_bInitialized : Bool = false
    private var categoryCellVm : CategoryCellVm!
    var index : Int = -1 {
        didSet {
            updateViewBasedOnViewModel()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        if !mPr_bInitialized {
            setupLblName()
            
            setupPlacement()
            mPr_bInitialized = true
        }
    }
    
    func             updateViewBasedOnViewModel() {
        categoryCellVm = CategoryCellVm(
            categoryAtIndex: self.index,
            onCategoryUpdate: {
                DispatchQueue.main.async {
                    self.lblName.text = self.categoryCellVm.category.name
                }
            })
    }
    
    func setupLblName(){
        lblName = UILabel()
        contentView.addSubview(lblName)
        lblName.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func setupPlacement(){
        let viewsDict : [String : Any] = [
            "name" : (lblName as Any)
        ]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[name]-|", options: [], metrics: nil, views: viewsDict))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[name]-|", options: [], metrics: nil, views: viewsDict))
        
    }
    
    
}
