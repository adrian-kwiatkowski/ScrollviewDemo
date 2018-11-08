//
//  MenuViewController.swift
//  ScrollviewDemo
//
//  Created by Adrian Kwiatkowski on 06/11/2018.
//  Copyright © 2018 Adrian Kwiatkowski. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func addingModeButtonTapped(_ sender: Any) {
        let vc = SelectionsViewController(mode: AddingMode())
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func editingModeButtonTapped(_ sender: Any) {
        let vc = SelectionsViewController(mode: EditingMode())
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
