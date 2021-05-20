//
//  CategoryFilterCellVm.swift
//  LbcChallenge
//
//  Created by Jean-baptiste Watremez on 20/05/2021.
//

import Foundation

protocol CategoryFilterCellVmProtocol {
    var id : Int { get }
    var name : String { get }
    var selected : Observable<Bool> { get }
    
    func select(_ value: Bool)
    func cancelObservers()
}

class CategoryFilterCell : CategoryFilterCellVmProtocol {
    private(set) var id : Int
    private(set) var name: String
    private(set) var selected: Observable<Bool>
    
    init(id: Int, name: String, selected: Bool) {
        self.id = id
        self.name = name
        self.selected = Observable<Bool>(initialValue: selected)
    }


    func select(_ value: Bool) {
        self.selected.value = value
    }
    
    func cancelObservers(){
        selected.valueChanged = nil
    }
}
