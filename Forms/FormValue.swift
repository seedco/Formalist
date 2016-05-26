//
//  FormValue.swift
//  Forms
//
//  Created by Indragie Karunaratne on 2016-05-25.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

public class ObserverToken<ValueType>: Equatable {
    private typealias Observer = ValueType -> Void
    private let observer: Observer
    
    private init(observer: Observer) {
        self.observer = observer
    }
}

public func ==<ValueType>(lhs: ObserverToken<ValueType>, rhs: ObserverToken<ValueType>) -> Bool {
    return lhs === rhs
}

public class FormValue<ValueType> {
    private var observerTokens = [ObserverToken<ValueType>]()

    public var value: ValueType {
        didSet {
            for token in observerTokens {
                token.observer(value)
            }
        }
    }
    
    public init(_ initialValue: ValueType) {
        self.value = initialValue
    }
    
    public func addObserver(observer: ValueType -> Void) -> ObserverToken<ValueType> {
        let token = ObserverToken(observer: observer)
        observerTokens.append(token)
        return token
    }
    
    public func removeObserverWithToken(token: ObserverToken<ValueType>) -> Bool {
        if let index = observerTokens.indexOf(token) {
            observerTokens.removeAtIndex(index)
            return true
        } else {
            return false
        }
    }
}
