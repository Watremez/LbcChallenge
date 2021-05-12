//
//  ItemCell.swift
//  LbcChallenge
//
//  Created by Jean-baptiste Watremez on 11/05/2021.
//

import Foundation
import UIKit

class ItemCellViewController : UITableViewCell {
    
    private var mPr_bInitialized : Bool = false

    var viewModel : ItemCellViewModel!
    var imgPicture : UIImageView!
    var lblTitle : UILabel!
    var lblPrice : UILabel!
    var lblUrgent : UILabel!

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
            
            setupPlacement()
            mPr_bInitialized = true
        }
    }
    
    func setupImgPicture(){
        imgPicture = UIImageView(image: UIImage(named:"DefaultPicture")!)
        imgPicture.contentMode = .scaleAspectFill
        imgPicture.layer.cornerRadius = 10
        imgPicture.clipsToBounds = true
        imgPicture.backgroundColor = UIColor.lightGray
        contentView.addSubview(imgPicture)
        imgPicture.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupLblTitle(){
        lblTitle = UILabel()
        contentView.addSubview(lblTitle)
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupLblPrice(){
        lblPrice = UILabel()
        contentView.addSubview(lblPrice)
        lblPrice.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupLblUrgent(){
        lblUrgent = UILabel()
        lblUrgent.backgroundColor = .white
        lblUrgent.layer.cornerRadius = 5
        lblUrgent.clipsToBounds = true
        lblUrgent.textColor = UIColor.orange
        lblUrgent.font = lblUrgent.font.withSize(12)
        lblUrgent.layer.borderWidth = 1
        lblUrgent.layer.borderColor = UIColor.orange.cgColor
        contentView.addSubview(lblUrgent)
        lblUrgent.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupPlacement() {
        let viewsDict = [
            "picture" : imgPicture,
            "title" : lblTitle,
            "price" : lblPrice,
            "urgent" : lblUrgent,
            ] as [String : Any]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[picture(110)]-[title]->=5-[price]-5-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[urgent]", options: [], metrics: nil, views: viewsDict))

        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[picture(110)]->=0-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[title]", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[price]", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[urgent]", options: [], metrics: nil, views: viewsDict))
    }
    
    
    func initViewModel(_ viewModel : ItemCellViewModel) {
        let formatter = NumberFormatter()

        self.viewModel = viewModel
        imgPicture.image = viewModel.picture
        lblTitle.text = viewModel.title
        formatter.numberStyle = .currency
        formatter.currencyCode = "EUR"
        formatter.locale = Locale(identifier: "fr-FR")
        lblPrice.text = formatter.string(from: NSNumber(value: viewModel.price)) ?? "n/a"
        lblUrgent.isHidden = !viewModel.urgent
        if viewModel.urgent {
            lblUrgent.text = " Urgent "
            let bounds = CGRect(x: 0, y: 0, width: lblUrgent.bounds.width + 40, height: lblUrgent.bounds.height + 20)
            lblUrgent.bounds = bounds
        }
    }


}


// MARK: - ItemCellViewModelProtocolDelegate

extension ItemCellViewController : ItemCellViewModelProtocolDelegate {
    
    
    func imageReady(imageDownloaded: UIImage) {
        imgPicture.image = imageDownloaded
    }
    
}
