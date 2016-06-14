//
//  Box.swift
//  Forms
//
//  Created by Indragie Karunaratne on 2016-06-01.
//  Copyright © 2016 Seed.co. All rights reserved.
//

final class Box<ValueType> {
    let value: ValueType
    
    init(_ value: ValueType) {
        self.value = value
    }
}
