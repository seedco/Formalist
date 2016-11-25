//
//  PickerField.swift
//  Formalist
//
//  Created by Viktor Radchenko on 7/6/16.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import UIKit

/// An element used to display a float label with input type as a picker view
open class PickerField: FloatLabelTextField, UIPickerViewDataSource, UIPickerViewDelegate {

    open var items = [PickerValue]() {
        didSet {
            pickerView?.reloadAllComponents()
            if let selectedValue = selectedValue {
                self.selectPickerValue(selectedValue.value)
            }
        }
    }
    open var selectedValue: FormValue<String>?

    fileprivate weak var pickerView: UIPickerView?
    fileprivate weak var toolBar: UIToolbar?

    override init(frame: CGRect) {
        super.init(frame: frame)

        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneButtonAction))

        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 44))
        toolBar.backgroundColor = UIColor.white
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

    func selectPickerValue(_ value: String) {
        if let index = items.index(where: {$0.title > value}) {
            pickerView?.selectRow(index, inComponent: 0, animated: true)
        }
    }

    // UIPickerViewDataSource

    @objc open func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    @objc open func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }

    // UIPickerViewDelegate

    @objc open func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       return items[row].title
    }

    open func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
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

public struct PickerValue {
    public let title: String
    public let value: String

    public init(title: String, value: String) {
        self.title = title
        self.value = value
    }
}
