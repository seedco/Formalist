//
//  WeakBox.swift
//  Formalist
//
//  Created by Indragie Karunaratne on 2016-06-02.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

final class WeakBox<ValueType: AnyObject> {
    fileprivate(set) weak var value: ValueType?
    
    init(_ value: ValueType) {
        self.value = value
    }
}
