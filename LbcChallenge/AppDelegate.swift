//
//  AppDelegate.swift
//  LbcChallenge
//
//  Created by Jean-baptiste Watremez on 10/05/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var content = Content.shared
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        if #available(iOS 13.0, *){
            
        } else {
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.tintColor = UIColor.orange

            var mainViewController : SplitVc
            mainViewController = SplitVc()
            mainViewController.setup(withAppViewModel: AppVm(apiService: ApiService(), domainUrlString: "https://raw.githubusercontent.com/leboncoin/paperclip/master/"))

            let master = UINavigationController()
            master.navigationBar.backgroundColor = UIColor.white
            master.viewControllers = [AdTableVc()]

            let detail = UINavigationController()
            detail.navigationBar.backgroundColor = UIColor.white
            detail.viewControllers = [AdDetailVc()]

            mainViewController.viewControllers = [master, detail]
            mainViewController.preferredDisplayMode = .oneBesideSecondary

            window?.rootViewController = mainViewController

            window?.makeKeyAndVisible()
        }

        return true
    }



}

