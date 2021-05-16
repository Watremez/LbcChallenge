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
    var vm : AdDetailVm? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        self.edgesForExtendedLayout = []

        
        if self.vm == nil {
            self.title = ""
            self.view.backgroundColor = UIColor.lightGray
            self.detailView.map({ $0.removeFromSuperview() })
        } else {
            self.view.addSubview(self.detailView)
            self.detailView.translatesAutoresizingMaskIntoConstraints = false
            let viewsDict : [String : Any] = [
                "detailView" : (detailView as Any)
                ]
            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[detailView]|", options: [], metrics: nil, views: viewsDict))
            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[detailView]|", options: [], metrics: nil, views: viewsDict))
        }
        
        if let svc = self.splitViewController {
            // Permet d'avoir le bouton back sur la vue détail.
            let ni = self.navigationItem
            ni.setLeftBarButton(svc.displayModeButtonItem, animated: false)
            ni.leftItemsSupplementBackButton = true ;
        }
        
        super.viewWillAppear(animated)
    }
    
    
    func setup(vm: AdDetailVm) {
        self.vm = vm
        self.title = self.vm!.title
        self.view.backgroundColor = UIColor.white
        self.detailView = AdDetailV()
        self.detailView.setup(vm: self.vm!)
    }

    
}
