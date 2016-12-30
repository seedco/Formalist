//
//  PickerField.swift
//  Formalist
//
//  Created by Viktor Radchenko on 7/6/16.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import UIKit

/// An element used to display a float label with input type as a picker view
open class PickerField<ValueType: Equatable>: FloatLabelTextField, UIPickerViewDataSource, UIPickerViewDelegate {

    open var items = [PickerValue<ValueType>]() {
        didSet {
            pickerView.reloadAllComponents()
            pickerView.selectedRow(inComponent: 0)
        }
    }
    fileprivate let pickerView: UIPickerView
    open var didSelectPickerValue: ((_ value: PickerValue<ValueType>) -> Void)?

    override init(frame: CGRect) {
        let pickerView = UIPickerView()
        pickerView.showsSelectionIndicator = true
        self.pickerView = pickerView

        super.init(frame: frame)

        pickerView.dataSource = self
        pickerView.delegate = self
        self.inputView = pickerView

        // hide the caret
        tintColor = .clear
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func selectPickerValue(_ value: PickerValue<ValueType>) {
        if let row = items.index(where: {$0 == value}) {
            selectRow(row)
        }
    }

    public func selectValue(_ value: ValueType) {
        if let row = items.index(where: {$0.value == value}) {
            selectRow(row)
        }
    }

    public func selectRow(_ row: Int) {
        let pickerValue = items[row]
        pickerView.selectRow(row, inComponent: 0, animated: true)
        didSelectPickerValue?(pickerValue)
    }

    // UIPickerViewDataSource

    @objc open func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    @objc open func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }

    // UIPickerViewDelegate

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[row].title
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectRow(row)
    }

    public func updateSelectedValue() {
        let row = pickerView.selectedRow(inComponent: 0)
        selectRow(row)
    }
}

public struct PickerValue<TypeValue: Equatable> {
    public let title: String
    public let value: TypeValue

    public init(title: String, value: TypeValue) {
        self.title = title
        self.value = value
    }
}

public func == <TypeValue: Equatable>(lhs: PickerValue<TypeValue>, rhs: PickerValue<TypeValue>) -> Bool {
    return lhs.title == rhs.title &&
        lhs.value == rhs.value
}
