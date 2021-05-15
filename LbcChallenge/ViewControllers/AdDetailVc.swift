//
//  AdDetailVc.swift
//  LbcChallenge
//
//  Created by Jean-baptiste Watremez on 13/05/2021.
//

import Foundation
import UIKit

class AdDetailVc : UIViewController {
    // Outlets
    var detailView : AdDetailV!

    // Members
    var viewModel : AdDetailVm = AdDetailVm.empty
    
    override func viewWillAppear(_ animated: Bool) {
        self.edgesForExtendedLayout = []

        if viewModel.empty {
            self.title = ""
            self.view.backgroundColor = UIColor.lightGray
            self.detailView.map({ $0.removeFromSuperview() })
        } else {
//            let barHeight : Int = Int(self.navigationController!.navigationBar.frame.height + self.additionalSafeAreaInsets.bottom)
            let barHeight : Int = 0

            self.title = viewModel.title
            self.view.backgroundColor = UIColor.white
            self.viewModel.navBarHeight = barHeight

            self.detailView = AdDetailV()
            self.detailView.initViewModel(self.viewModel)
            self.view.addSubview(self.detailView)
            self.detailView.translatesAutoresizingMaskIntoConstraints = false
            let viewsDict : [String : Any] = [
                "detailView" : (detailView as Any)
                ]
            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[detailView]|", options: [], metrics: nil, views: viewsDict))
            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(\(barHeight))-[detailView]|", options: [], metrics: nil, views: viewsDict))
        }
        
        if let svc = self.splitViewController {
            // Permet d'avoir le bouton back sur la vue détail.
            let ni = self.navigationItem
            ni.setLeftBarButton(svc.displayModeButtonItem, animated: false)
            ni.leftItemsSupplementBackButton = true ;
        }
        
        super.viewWillAppear(animated)
    }
}



// MARK: - AsynchronousImageDisplayer

extension AdDetailVc : AsynchronousImageDisplayer {
    
    
    func imageReady(imageDownloaded: UIImage) {
        self.viewModel.picture = imageDownloaded
        self.detailView.map({
            $0.imgPicture.image = imageDownloaded
        })
    }
    
}
