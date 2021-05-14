//
//  Notification.swift
//  LbcChallenge
//
//  Created by Jean-baptiste Watremez on 12/05/2021.
//

import Foundation


extension Notification.Name {
    static let AdsDownloaded = Notification.Name("Ads downloaded")
    static let CategoriesDownloaded = Notification.Name("Categories downloaded")
    static let SelectedCategory = Notification.Name("Selected category")

    func post(object: Any? = nil, userInfo: [AnyHashable : Any]? = nil) {
        NotificationCenter.default.post(name: self, object: object, userInfo: userInfo)
    }

    @discardableResult
    func onNotified(object: Any? = nil, queue: OperationQueue? = nil, using: @escaping (Notification) -> Void) -> NSObjectProtocol {
        return NotificationCenter.default.addObserver(forName: self, object: object, queue: queue, using: using)
    }
}
