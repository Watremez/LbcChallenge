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

    // Members
    private var mPr_bInitialized : Bool = false
    var viewModel : AdCellVm!

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

    func setupPlacement() {
        let viewsDict : [String : Any] = [
            "picture" : (imgPicture as Any),
            "title" : (lblTitle as Any),
            "price" : (lblPrice as Any),
            "urgent" : (lblUrgent as Any),
            "category" : (lblCategory as Any),
            "date" : (lblDepositDate as Any)
            ]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[picture(110)]-5-[title]-5-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[urgent]", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[picture]-[price]", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[picture]-[category]", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[picture]-[date]", options: [], metrics: nil, views: viewsDict))

        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-25-[picture(110)]-25-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-25-[title]-5-[price]-5-[category]-5-[date]", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-30-[urgent]", options: [], metrics: nil, views: viewsDict))
        
    }
    
    
    func initViewModel(_ viewModel : AdCellVm) {
        self.viewModel = viewModel
        imgPicture.image = viewModel.picture
        lblTitle.text = viewModel.title
        viewModel.category.map { lblCategory.text = $0.name }
        lblCategory.isHidden = viewModel.category == nil
        lblPrice.text = viewModel.price
        lblDepositDate.text = viewModel.depositDate
        lblUrgent.isHidden = !viewModel.urgent
        if viewModel.urgent {
            lblUrgent.text = " Urgent "
            let bounds = CGRect(x: 0, y: 0, width: lblUrgent.bounds.width + 40, height: lblUrgent.bounds.height + 20)
            lblUrgent.bounds = bounds
        }
    }


}


// MARK: - AsynchronousImageDisplayer

extension AdCellV : AsynchronousImageDisplayer {
    
    
    func imageReady(imageDownloaded: UIImage) {
        imgPicture.image = imageDownloaded
    }
    
}
