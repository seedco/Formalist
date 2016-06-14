//
//  WeakBox.swift
//  Forms
//
//  Created by Indragie Karunaratne on 2016-06-02.
//  Copyright © 2016 Seed.co. All rights reserved.
//

final class WeakBox<ValueType: AnyObject> {
    private(set) weak var value: ValueType?
    
    init(_ value: ValueType) {
        self.value = value
    }
}
