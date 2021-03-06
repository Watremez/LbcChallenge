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
                adTableVc.setup(
                    adListViewModel: self.appVm.adListViewModel!,
                    categoryFilterViewModel: self.appVm.categoryFilterViewModel!,
                    whereToGetSelectedCategoryViewModel: self.appVm.getSelectedCategoryViewModel
                )
            }
        }
        appVm.alertMessage.valueChanged = { message in
            message.map { messageConfirmed in
                let alert = UIAlertController(title: "", message: messageConfirmed, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)            }
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
