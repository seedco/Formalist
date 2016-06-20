//
//  Segment.swift
//  Formalist
//
//  Created by Indragie Karunaratne on 3/4/16.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import UIKit

/// Content displayed on a single segment of a segmented control.
///
/// `UISegmentedControl` allows each segment to have either an image
/// or a title associated with it, but not both.
public enum SegmentContent {
    case Image(UIImage)
    case Title(String)
    
    public var objectValue: AnyObject {
        switch self {
        case let .Image(image): return image
        case let .Title(title): return title
        }
    }
}

/// A segment that has content (used to display it in a segmented control)
/// and an associated value.
public struct Segment<ValueType: Equatable> {
    /// The content (image or title) of the segment displayed in the segmented
    /// control.
    public let content: SegmentContent
    
    /// The associated value of the segment.
    public let value: ValueType
    
    /**
     Designated initializer
     
     - parameter content: The content (image or title) of the segment displayed 
     in the segmented control
     - parameter value:   The associated value of the segment
     
     - returns: An initialized instance of the receiver
     */
    public init(content: SegmentContent, value: ValueType) {
        self.content = content
        self.value = value
    }
}
