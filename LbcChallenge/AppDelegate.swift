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
            
            var mainViewController : SplitVc
            mainViewController = SplitVc()

            let master = UINavigationController()
            let detail = UINavigationController()
            master.viewControllers = [AdTableVc()] // in AdTableVc is instanciated the main ViewModel : AppVm
            detail.viewControllers = [AdDetailVc()]
            mainViewController.viewControllers = [master, detail]
            mainViewController.preferredDisplayMode = .oneBesideSecondary

            window?.rootViewController = mainViewController

            window?.makeKeyAndVisible()
        }

        return true
    }



}

