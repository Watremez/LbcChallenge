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
    var chkActivated : UISwitch!

    // Members
    private var mPr_bInitialized : Bool = false
    var viewModel : CategoryCellVm!

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        if !mPr_bInitialized {
            setupLblName()
            setupchkActivated()
            
            setupPlacement()
            mPr_bInitialized = true
        }
    }
    
    func setupLblName(){
        lblName = UILabel()
        contentView.addSubview(lblName)
        lblName.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func setupchkActivated(){
        chkActivated = UISwitch()
        contentView.addSubview(chkActivated)
        chkActivated.translatesAutoresizingMaskIntoConstraints = false
        chkActivated.addTarget(self, action: <#T##Selector#>, for: <#T##UIControl.Event#>)
    }
    
    
    func setupPlacement(){
        let viewsDict = [
            "name" : lblName,
            "activated" : chkActivated
            ] as [String : Any]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[name]-[activated]-|", options: [], metrics: nil, views: viewsDict))

        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[name]-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[activated]-|", options: [], metrics: nil, views: viewsDict))

    }
    
    
    func initViewModel(_ viewModel : CategoryCellVm) {
        self.viewModel = viewModel
        lblName.text = viewModel.name
        chkActivated.setOn(viewModel.activated, animated: false)
    }

    
}
