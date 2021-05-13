//
//  AdDetailV.swift
//  LbcChallenge
//
//  Created by Jean-baptiste Watremez on 13/05/2021.
//

import Foundation
import UIKit


class AdDetailV : UIView {
    // Outlets
    var imgPicture : UIImageView!
    var lblTitle : UILabel!
    var lblPrice : UILabel!
    var lblUrgent : UILabel!
    var lblCategory : UILabel!
    var lblDepositDate : UILabel!
    var lblDescription : UILabel!
    var mnoDescriptionContent : UITextView!

    // Members
    private var mPr_bInitialized : Bool = false
    var viewModel : AdDetailVm = AdDetailVm.empty
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        if !mPr_bInitialized {
            setupImgPicture()
            setupLblTitle()
            setupLblPrice()
//            setupLblUrgent()
//            setupLblCategory()
            setupLblDepositDate()
            setupLblDescription()
            setupMnoDescriptionContent()

            setupPlacement()
            mPr_bInitialized = true
        }
    }
    
    
    func setupImgPicture(){
        imgPicture = UIImageView(image: PictureCache.defaultImage)
        imgPicture.contentMode = .scaleAspectFit
        imgPicture.backgroundColor = UIColor.white
        self.addSubview(imgPicture)
        imgPicture.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupLblTitle(){
        lblTitle = UILabel()
        lblTitle.font = UIFont.preferredFont(forTextStyle: .headline).withSize(24)
        lblTitle.numberOfLines = 0
        lblTitle.lineBreakMode = .byWordWrapping
        self.addSubview(lblTitle)
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupLblPrice(){
        lblPrice = UILabel()
        self.addSubview(lblPrice)
        lblPrice.textColor = .orange
        lblPrice.font = UIFont.preferredFont(forTextStyle: .headline)
        lblPrice.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupLblUrgent(){
        lblUrgent = UILabel()
        lblUrgent.backgroundColor = .white
        lblUrgent.layer.cornerRadius = 5
        lblUrgent.clipsToBounds = true
        lblUrgent.textColor = UIColor.orange
        lblUrgent.font = UIFont.preferredFont(forTextStyle: .caption1)
        lblUrgent.layer.borderWidth = 1
        lblUrgent.layer.borderColor = UIColor.orange.cgColor
        self.addSubview(lblUrgent)
        lblUrgent.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupLblCategory() {
        lblCategory = UILabel()
        lblCategory.font = lblCategory.font.withSize(8)
        self.addSubview(lblCategory)
        lblCategory.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupLblDepositDate(){
        lblDepositDate = UILabel()
        lblDepositDate.font = UIFont.preferredFont(forTextStyle: .caption2)
        lblDepositDate.textColor = .lightGray
        self.addSubview(lblDepositDate)
        lblDepositDate.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupLblDescription() {
        lblDescription = UILabel()
        lblDescription.text = "Description"
        lblDescription.font = UIFont.preferredFont(forTextStyle: .headline).withSize(16)
        self.addSubview(lblDescription)
        lblDescription.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupMnoDescriptionContent() {
        mnoDescriptionContent = UITextView()
        mnoDescriptionContent.font = UIFont.preferredFont(forTextStyle: .callout)
        mnoDescriptionContent.isEditable = false
        self.addSubview(mnoDescriptionContent)
        mnoDescriptionContent.translatesAutoresizingMaskIntoConstraints = false
    }



    func setupPlacement() {
        let viewsDict = [
            "picture" : imgPicture,
            "title" : lblTitle,
            "price" : lblPrice,
            "urgent" : lblUrgent,
            "category" : lblCategory,
            "date" : lblDepositDate,
            "description" : lblDescription,
            "descriptionContent" : mnoDescriptionContent
            ] as [String : Any]
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[picture]|", options: [], metrics: nil, views: viewsDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[title]-|", options: [], metrics: nil, views: viewsDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[description]", options: [], metrics: nil, views: viewsDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[descriptionContent]-|", options: [], metrics: nil, views: viewsDict))

        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[picture]-[title]-[price]-50-[description]-[descriptionContent]-|", options: [], metrics: nil, views: viewsDict))
        
        NSLayoutConstraint.activate([
            lblDepositDate.centerYAnchor.constraint(equalTo: lblPrice.centerYAnchor),
            lblPrice.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            lblDepositDate.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8)
        ])

    }
    
    
    func initViewModel(_ viewModel : AdDetailVm) {
        self.viewModel = viewModel
        imgPicture.image = viewModel.picture
        lblTitle.text = viewModel.title
//        viewModel.category.map { lblCategory.text = $0.name }
//        lblCategory.isHidden = viewModel.category == nil
        lblPrice.text = viewModel.price
        lblDepositDate.text = viewModel.depositDate
        mnoDescriptionContent.text = viewModel.description
//        lblUrgent.isHidden = !viewModel.urgent
//        if viewModel.urgent {
//            lblUrgent.text = " Urgent "
//            let bounds = CGRect(x: 0, y: 0, width: lblUrgent.bounds.width + 40, height: lblUrgent.bounds.height + 20)
//            lblUrgent.bounds = bounds
//        }
    }


}
