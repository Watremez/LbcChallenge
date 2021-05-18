//
//  ItemCell.swift
//  LbcChallenge
//
//  Created by Jean-baptiste Watremez on 11/05/2021.
//

import Foundation
import UIKit

class AdCellV : UITableViewCell {
    // Outlets
    var imgPicture : UIImageView!
    var lblTitle : UILabel!
    var lblPrice : UILabel!
    var lblUrgent : UILabel!
    var lblCategory : UILabel!
    var lblDepositDate : UILabel!
    var activityIndicator: UIActivityIndicatorView!

    // Members
    private var mPr_bInitialized : Bool = false
    private var vm : AdCellVmProtocol? = nil

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        if !mPr_bInitialized {
            setupImgPicture()
            setupLblTitle()
            setupLblPrice()
            setupLblUrgent()
            setupLblCategory()
            setupLblDepositDate()
            setupActivityIndicator()
            
            setupPlacement()
            mPr_bInitialized = true
        }
    }
    
    func setupImgPicture(){
        imgPicture = UIImageView(image: PictureCache.defaultImage)
        imgPicture.contentMode = .scaleAspectFill
        imgPicture.layer.cornerRadius = 10
        imgPicture.clipsToBounds = true
        imgPicture.backgroundColor = UIColor.white
        imgPicture.isHidden = false
        contentView.addSubview(imgPicture)
        imgPicture.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupLblTitle(){
        lblTitle = UILabel()
        lblTitle.font = UIFont.preferredFont(forTextStyle: .headline)
        lblTitle.numberOfLines = 0
        lblTitle.lineBreakMode = .byWordWrapping
        contentView.addSubview(lblTitle)
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupLblPrice(){
        lblPrice = UILabel()
        contentView.addSubview(lblPrice)
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
        contentView.addSubview(lblUrgent)
        lblUrgent.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupLblCategory() {
        lblCategory = UILabel()
        lblCategory.font = lblCategory.font.withSize(8)
        contentView.addSubview(lblCategory)
        lblCategory.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupLblDepositDate(){
        lblDepositDate = UILabel()
        lblDepositDate.font = UIFont.preferredFont(forTextStyle: .caption2)
        lblDepositDate.textColor = .lightGray
        contentView.addSubview(lblDepositDate)
        lblDepositDate.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView()
        self.activityIndicator.isHidden = true
        activityIndicator.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        contentView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupPlacement() {
        let viewsDict : [String : Any] = [
            "picture" : (imgPicture as Any),
            "title" : (lblTitle as Any),
            "price" : (lblPrice as Any),
            "urgent" : (lblUrgent as Any),
            "category" : (lblCategory as Any),
            "date" : (lblDepositDate as Any),
            "activity" : (activityIndicator as Any)
            ]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[picture(110)]-5-[title]-5-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[urgent]", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[picture]-[price]", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[picture]-[category]", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[picture]-[date]", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[activity(picture)]", options: [], metrics: nil, views: viewsDict))

        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-25-[picture(110)]-25-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-25-[title]-5-[price]-5-[category]-5-[date]", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-30-[urgent]", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-25-[activity(picture)]", options: [], metrics: nil, views: viewsDict))

    }
    
    func setup(withCellViewModel vm : AdCellVmProtocol) {
        self.vm = vm
        lblTitle.text = vm.title
        lblCategory.text = vm.category
        lblPrice.text = vm.price
        lblDepositDate.text = vm.depositDate
        if vm.urgent {
            lblUrgent.text = " URGENT "
            lblUrgent.isHidden = false
        } else {
            lblUrgent.isHidden = true
        }
        
        if vm.thumbPicture.loaded {
            imgPicture.image = vm.thumbPicture.value
            imgPicture.isHidden = false
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
        } else {
            self.imgPicture.isHidden = true
            self.activityIndicator.startAnimating()
            self.activityIndicator.isHidden = false
        }
        vm.thumbPicture.valueChanged = { image in
            self.imgPicture.image = image
            self.imgPicture.isHidden = false
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
        }

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.vm?.cancelObservers()
    }
    
}
