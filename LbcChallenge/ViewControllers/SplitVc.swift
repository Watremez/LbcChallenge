//
//  SplitVc.swift
//  LbcChallenge
//
//  Created by Jean-baptiste Watremez on 13/05/2021.
//

import Foundation
import UIKit

class SplitVc : UISplitViewController {
    private var appVm : AppVmProtocol!

    override func loadView() {
        super.loadView()
        self.delegate = self
    }

    func setup(withAppViewModel appViewModel : AppVmProtocol) {
        appVm = appViewModel
        appVm.appIsLoading.valueChanged = { appLoadingStatus in
            if appLoadingStatus == false {
                guard let navVc = (self.viewControllers[0] as? UINavigationController) else { return }
                guard let adTableVc = (navVc.viewControllers[0] as? AdTableVc) else { return }
                adTableVc.setup(withAdListViewModel: self.appVm.adListViewModel!, andCategoryFilterViewModel: self.appVm.categoryFilterViewModel!)
            }
        }
        appVm.initFetch()
    }

    
}


// MARK:  - UISplitViewControllerDelegate


extension SplitVc : UISplitViewControllerDelegate {

    func splitViewController(_ splitViewController: UISplitViewController,
                    collapseSecondary secondaryViewController: UIViewController,
                    onto primaryViewController: UIViewController) -> Bool {
        if let secVcAsNc = secondaryViewController as? UINavigationController
           , let topVc = secVcAsNc.topViewController as? AdDetailVc
           , topVc.vm == nil {
            return true
        } else {
            return false
        }
    }
    
}
