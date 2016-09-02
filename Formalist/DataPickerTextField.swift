//
//  DataPickerTextField.swift
//  Formalist
//
//  Created by Viktor Radchenko on 7/6/16.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import UIKit
import Formalist

public class DataPickerTextField<TypeValue: Equatable>: FloatLabelTextField, UIPickerViewDataSource, UIPickerViewDelegate {

    public var items = [DataPickerValue<TypeValue>]() {
        didSet {
            pickerView?.reloadAllComponents()
            if let selectedValue = selectedValue {
                self.selectPickerValue(selectedValue.value)
            }
        }
    }
    public var selectedValue: FormValue<String>?

    private weak var pickerView: UIPickerView?
    private weak var toolBar: UIToolbar?

    override init(frame: CGRect) {
        super.init(frame: frame)

        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(self.doneButtonAction))

        let toolBar = UIToolbar(frame: CGRectMake(0, 0, self.frame.width, 44))
        toolBar.backgroundColor = UIColor.whiteColor()
        toolBar.setItems([space, doneButton], animated: true)
        self.toolBar = toolBar

        let pickerView = UIPickerView()
        pickerView.showsSelectionIndicator = true
        pickerView.dataSource = self
        pickerView.delegate = self
        self.pickerView = pickerView

        self.inputAccessoryView = toolBar
        self.inputView = pickerView
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func selectPickerValue(value: String) {
        if let index = items.indexOf({$0.title > value}) {
            pickerView?.selectRow(index, inComponent: 0, animated: true)
        }
    }

    // UIPickerViewDataSource

    @objc public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    @objc public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }

    // UIPickerViewDelegate

    @objc public func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       return items[row].title
    }

    public func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if self.items.count > row {
            selectedValue!.value = self.items[row].title
        }
        resignTextView()
    }

    func doneButtonAction() {
        resignTextView()
    }

    func resignTextView() {
        self.resignFirstResponder()
        self.inputAccessoryView?.removeFromSuperview()
        self.inputView?.removeFromSuperview()
    }
}

public struct DataPickerValue<ValueType: Equatable> {
    public let title: String
    public let value: ValueType

    public init(title: String, value: ValueType) {
        self.title = title
        self.value = value
    }
}
