//
//  SelectedCategoryV.swift
//  LbcChallenge
//
//  Created by Jean-baptiste Watremez on 19/05/2021.
//

import Foundation
import UIKit

class SelectedCategoryV : UIView {
    // Outlets
    private var lblCategory : UILabel!
    private var imgCloseButton : UIImageView!
    
    // Members
    private var vm : SelectedCategoryVmProtocol? = nil
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLblCategory()
        setupImgCloseButton()
        setupPlacement()
        self.layer.borderColor  = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 11
        self.backgroundColor = UIColor.white
    }
    
    func setupLblCategory() {
        lblCategory = UILabel()
        self.addSubview(lblCategory)
        lblCategory.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupImgCloseButton() {
        imgCloseButton = UIImageView()
        self.addSubview(imgCloseButton)
        imgCloseButton.translatesAutoresizingMaskIntoConstraints = false
        imgCloseButton.image = UIImage(named:"Close")!
        imgCloseButton.setImageColor(color: UIColor.orange)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onImgCloseButtonTouchUp(tapGestureRecognizer:)))
        imgCloseButton.isUserInteractionEnabled = true
        imgCloseButton.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func onImgCloseButtonTouchUp(tapGestureRecognizer: UITapGestureRecognizer){
        guard let viewModel = self.vm else { return }
        viewModel.onRemoveTouchUp()
    }
    
    func setupPlacement() {
        let viewsDict : [String : Any] = [
            "lblCategory" : (lblCategory as Any),
            "imgCloseButton" : (imgCloseButton as Any)
        ]

        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[lblCategory]-[imgCloseButton]-3-|", options: [], metrics: nil, views: viewsDict))

        NSLayoutConstraint.activate([
            self.lblCategory.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.lblCategory.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -2),

            self.imgCloseButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.imgCloseButton.heightAnchor.constraint(equalToConstant: 16),
            self.imgCloseButton.widthAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    func setup(withSelectedCategoryViewModel vm : SelectedCategoryVmProtocol) {
        self.vm = vm
        guard let viewModel = self.vm else { return }
        self.lblCategory.text = viewModel.selectedCategoryName
    }
    
}
