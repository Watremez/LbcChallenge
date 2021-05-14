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

        window = UIWindow(frame: UIScreen.main.bounds)
        
        var mainViewController : SplitVc
        if #available(iOS 14.0, *) {
            mainViewController = SplitVc(style: UISplitViewController.Style.doubleColumn)
        } else {
            mainViewController = SplitVc()
        }
        
        let master = UINavigationController()
        let detail = UINavigationController()
        master.viewControllers = [AdTableVc()]
        detail.viewControllers = [AdDetailVc()]
        if #available(iOS 14.0, *) {
            mainViewController.setViewController(master, for: UISplitViewController.Column.primary)
            mainViewController.setViewController(detail, for: UISplitViewController.Column.secondary)
            mainViewController.preferredDisplayMode = UISplitViewController.DisplayMode.oneBesideSecondary
            mainViewController.preferredSplitBehavior = UISplitViewController.SplitBehavior.tile
        } else {
            mainViewController.viewControllers = [master, detail]
        }

        window?.rootViewController = mainViewController

        window?.makeKeyAndVisible()

        return true
    }



}

