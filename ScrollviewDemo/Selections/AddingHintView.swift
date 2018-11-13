//
//  AddingHintView.swift
//  ScrollviewDemo
//
//  Created by Adrian Kwiatkowski on 13/11/2018.
//  Copyright © 2018 Adrian Kwiatkowski. All rights reserved.
//

import UIKit

class AddingHintView: UIView {

    @IBOutlet weak var hintLabel: UILabel!
    
}


extension UIView {
    class func initFromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)?[0] as! T
    }
}
