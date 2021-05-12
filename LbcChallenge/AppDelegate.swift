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

        let viewController = ViewController()
        window?.rootViewController = viewController

        window?.makeKeyAndVisible()

        return true
    }



}

