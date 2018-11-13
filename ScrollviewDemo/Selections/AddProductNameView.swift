//
//  AddProductNameView.swift
//  ScrollviewDemo
//
//  Created by Adrian Kwiatkowski on 13/11/2018.
//  Copyright © 2018 Adrian Kwiatkowski. All rights reserved.
//

import UIKit

class AddProductNameView: UIView {
    @IBOutlet weak var saveButton: CTAButton!
    @IBOutlet weak var textField: UITextField!
    
    public var saveButtonAction: ((String?) -> ())?
    
    override func awakeFromNib() {
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    @objc private func saveButtonTapped() {
        saveButtonAction?(textField.text)
    }
}
