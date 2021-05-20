//
//  CategoryFilterCellV.swift
//  LbcChallenge
//
//  Created by Jean-baptiste Watremez on 20/05/2021.
//

import Foundation
import UIKit

class CategoryFilterCellV : UITableViewCell {
    // Outlets
    var imgPicture : UIImageView!
    var lblTitle : UILabel!

    // Members
    private var mPr_bInitialized : Bool = false
    private var vm : CategoryFilterCellVmProtocol? = nil

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        if !mPr_bInitialized {
            setupImgPicture()
            setupLblTitle()
            
            setupPlacement()
            mPr_bInitialized = true
        }
    }
    
    func setupImgPicture(){
        imgPicture = UIImageView(image: UIImage(named:"Check")!)
        imgPicture.backgroundColor = UIColor.clear
        imgPicture.isHidden = true
        contentView.addSubview(imgPicture)
        imgPicture.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupLblTitle(){
        lblTitle = UILabel()
        lblTitle.textColor = UIColor.black
        contentView.addSubview(lblTitle)
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupPlacement() {
        let viewsDict : [String : Any] = [
            "picture" : (imgPicture as Any),
            "title" : (lblTitle as Any)
            ]
        
        let taille : CGFloat = 20
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[title]-[picture]-|", options: [], metrics: nil, views: viewsDict))

        NSLayoutConstraint.activate([
            imgPicture.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imgPicture.heightAnchor.constraint(equalToConstant: taille),
            imgPicture.widthAnchor.constraint(equalToConstant: taille),
            lblTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])

    }
    
    func setup(withCategoryFilterCellViewModel vm : CategoryFilterCellVmProtocol) {
        self.vm = vm
        lblTitle.text = vm.name
        updateSelectedState()
        vm.selected.valueChanged = { newValue in
            self.updateSelectedState()
        }

    }
    
    private func updateSelectedState(){
        guard let viewModel = self.vm else { return }
        if viewModel.selected.value {
            imgPicture.isHidden = false
        } else {
            imgPicture.isHidden = true
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.vm?.cancelObservers()
    }
    
}

