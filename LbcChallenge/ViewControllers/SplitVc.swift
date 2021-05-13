//
//  SplitVc.swift
//  LbcChallenge
//
//  Created by Jean-baptiste Watremez on 13/05/2021.
//

import Foundation
import UIKit

class SplitVc : UISplitViewController {
    
    override func loadView() {
        super.loadView()
        let master = UINavigationController()
        let detail = UINavigationController()
        master.viewControllers = [AdTableVc()]
        detail.viewControllers = [AdDetailVc()]
        self.viewControllers = [master, detail]
    }
    
}
