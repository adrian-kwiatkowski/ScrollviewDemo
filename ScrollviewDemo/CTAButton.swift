//
//  CTAButton.swift
//  Blix
//
//  Created by Adrian Kwiatkowski on 17/09/2018.
//  Copyright © 2018 Qpony.pl Sp. z o.o. All rights reserved.
//

import UIKit

class CTAButton: UIButton {

    let disabledBackgroundColor = UIColor(red: 187.0 / 255.0, green: 187.0 / 255.0, blue: 187.0 / 255.0, alpha: 1.0)
    var enabledBackgroundColor = UIColor(red: 52.0 / 255.0, green: 181.0 / 255.0, blue: 123.0 / 255.0, alpha: 1.0)
    
    let labelFont = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.bold)
    let customCornerRadius: CGFloat = 16.0
    
    override var isEnabled: Bool{
        didSet {
            setButtonStyle()
        }
    }
    
    override func awakeFromNib() {
        setButtonStyle()
    }
    
    func setButtonStyle() {
        let color = isEnabled ? enabledBackgroundColor : disabledBackgroundColor
        
        layer.cornerRadius = customCornerRadius
        tintColor = UIColor.white
        
        backgroundColor = color
        titleLabel?.font = labelFont
    }
}
