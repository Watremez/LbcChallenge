//
//  SplitVc.swift
//  LbcChallenge
//
//  Created by Jean-baptiste Watremez on 13/05/2021.
//

import Foundation
import UIKit

class SplitVc : UISplitViewController {
    private var appVm : AppVm!

    override func loadView() {
        super.loadView()
        updateViewBasedOnViewModel()
    }

    
    func updateViewBasedOnViewModel() {
        appVm = AppVm()
        appVm.appIsLoading.valueChanged = { appLoadingStatus in
            if appLoadingStatus == false {
                guard let navVc = (self.viewControllers[0] as? UINavigationController) else { return }
                guard let adTableVc = (navVc.viewControllers[0] as? AdTableVc) else { return }
                adTableVc.setup(adListVm: self.appVm.adListViewModel!, categoryFilterVm: self.appVm.categoryFilterViewModel!)
            }
        }
        appVm.initFetch()
    }

    
}
