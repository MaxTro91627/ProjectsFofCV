//
//  PickerTextField.swift
//  PillBox
//
//  Created by Максим Троицкий
//

import Foundation
import SwiftUI

struct PickerTextField: UIViewRepresentable {
    
    private let textField = UITextField()
    private let pickerView = UIPickerView()
    private let helper = Helper()
    
    var data: [String]
    var placeholder: String
    
    @Binding var lastSelectedIndex: Int?
    
    func makeUIView(context: Context) -> UITextField {
        self.pickerView.delegate = context.coordinator
        self.pickerView.dataSource = context.coordinator
        
        self.textField.placeholder = self.placeholder
        self.textField.inputView = self.pickerView
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self.helper, action: #selector(self.helper.doneButtonAction))
        doneButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(red: 73/255, green: 166/255, blue: 169/255, alpha: 1)], for: .normal)
        toolBar.setItems([flexibleSpace, doneButton], animated: true)
        self.textField.inputAccessoryView = toolBar
        
        self.helper.doneButtonTapped = {
            if self.lastSelectedIndex == nil {
                self.lastSelectedIndex = 0
            }
            self.textField.resignFirstResponder()
        }
        
        self.pickerView.backgroundColor = UIColor(red: 236/255, green: 240/255, blue: 255/255, alpha: 1)
        return self.textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        if let lastSelectedIndex = self.lastSelectedIndex {
            let selectedText = self.data[lastSelectedIndex]
            let font = UIFont.boldSystemFont(ofSize: 18)
            let attributes: [NSAttributedString.Key: Any] = [.font: font]
            uiView.attributedText = NSAttributedString(string: selectedText, attributes: attributes)
            uiView.textAlignment = .right
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(data: self.data) { (index) in
            self.lastSelectedIndex = index
        }
    }
    
    class Helper {
        
        public var doneButtonTapped: (() -> Void)?
        
        @objc func doneButtonAction() {
            self.doneButtonTapped?()
        }
    }
    
    class Coordinator: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
        private var data: [String]
        private var didSelectItem: ((Int) -> Void)?
        
        init(data: [String], didSelectItem: ((Int) -> Void)? = nil) {
            self.data = data
            self.didSelectItem = didSelectItem
        }
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return self.data.count
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return self.data[row]
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            self.didSelectItem?(row)
        }
    }
}
