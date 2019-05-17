//
//  PGCPickerUtils.swift
//  TestPickerController
//
//  Created by aguilarpgc on 5/17/19.
//  Copyright © 2019 Paul Aguilar. All rights reserved.
//

public protocol PickerSingleOption {
    
    var currentIndexSelected: Int? { set get }
    
    func numberOfRows() -> Int
    func title(forRow row: Int) -> String
    
}

public protocol PickerMultipleOption {
    
    var currentIndexesSelected: [Int]? { set get }
    var numberOfComponents: Int { get }

    func numberOfRows(atComponent component: Int) -> Int
    func title(forRow row: Int, atComponent component: Int) -> String
    
}

typealias PickerSingleHandler   = (_ selection: Int) -> Void
typealias PickerMultipleHandler = (_ selections: [Int]) -> Void
