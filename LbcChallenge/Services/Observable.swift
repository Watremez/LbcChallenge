//
//  Observable.swift
//  LbcChallenge
//
//  Created by Jean-baptiste Watremez on 15/05/2021.
//

import Foundation


class Observable<T> {
    
    var value: T {
        didSet {
            DispatchQueue.main.async {
                self.valueChanged?(self.value)
                self.loaded = true
            }
        }
    }
    private(set) var loaded : Bool = false
    
    var valueChanged: ((T) -> Void)?
    
    init(initialValue : T) {
        self.value = initialValue
    }
    
}
