//
//  AdditionalGestures.swift
//  ScrollviewDemo
//
//  Created by Adrian Kwiatkowski on 08/11/2018.
//  Copyright © 2018 Adrian Kwiatkowski. All rights reserved.
//

import UIKit

protocol AdditionalGestures {
    func setupAdditionalGestures(forView: UIView)
    func disableGestureRecognizer()
    func enableGestureRecognizer()
    var gestureDelegate: AdditionalGestureDelegate? { get set }
}

protocol AdditionalGestureDelegate: class {
    func additionalGesture(_ gesture: AdditionalGestures, longpressedAt point: CGPoint)
    func additionalGesture(_ gesture: AdditionalGestures, tappedAt view: UIImageView)
}

class AddingMode: AdditionalGestures {
    weak var gestureDelegate: AdditionalGestureDelegate?
    var longPress: UILongPressGestureRecognizer = UILongPressGestureRecognizer()
    let hintDisplayedAlready = UserDefaults.standard.bool(forKey: "hintShown")
    
    func setupAdditionalGestures(forView: UIView) {
        longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(recognizer:)))
        
        forView.addGestureRecognizer(longPress)
    }
    
    @objc func handleLongPress(recognizer: UILongPressGestureRecognizer) {
        guard recognizer.state == .began else { return }
        let longPressedCenter = recognizer.location(in: recognizer.view)
        
        gestureDelegate?.additionalGesture(self, longpressedAt: longPressedCenter)
    }
    
    func disableGestureRecognizer() {
        longPress.isEnabled = false
    }
    
    func enableGestureRecognizer() {
        longPress.isEnabled = true
    }
}

class EditingMode: AdditionalGestures {
    weak var gestureDelegate: AdditionalGestureDelegate?
    
    func setupAdditionalGestures(forView: UIView) {
        forView.subviews.forEach { (view) in
            let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(recognizer:)))
            view.isUserInteractionEnabled = true
            view.addGestureRecognizer(singleTap)
        }
    }
    
    @objc func handleSingleTap(recognizer: UITapGestureRecognizer) {
        guard let recognizerImageView = recognizer.view as? UIImageView else { return }
        gestureDelegate?.additionalGesture(self, tappedAt: recognizerImageView)
    }
    
    func disableGestureRecognizer() {
    }
    
    func enableGestureRecognizer() {
    }
}
