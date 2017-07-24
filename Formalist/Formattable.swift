//
//  Formattable.swift
//  Formalist
//
//  Created by Viktor Radchenko on 7/21/17.
//  Copyright © 2017 Seed Platform, Inc. All rights reserved.
//

import Foundation

public protocol Formattable {
    func from(input: String) -> String
}
