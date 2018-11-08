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
    var gestureDelegate: AdditionalGestureDelegate? { get set }
}

protocol AdditionalGestureDelegate: class {
    func additionalGesture(_ gesture: AdditionalGestures, performedGestureAt point: CGPoint)
}

class AddingMode: AdditionalGestures {
    weak var gestureDelegate: AdditionalGestureDelegate?
    
    func setupAdditionalGestures(forView: UIView) {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(recognizer:forView:)))
        forView.addGestureRecognizer(longPress)
    }
    
    @objc func handleLongPress(recognizer: UILongPressGestureRecognizer, forView: UIView) {
        guard recognizer.state == .began else { return }
        let longPressedCenter = recognizer.location(in: forView)
        
        gestureDelegate?.additionalGesture(self, performedGestureAt: longPressedCenter)
    }
}

class EditingMode: AdditionalGestures {
    weak var gestureDelegate: AdditionalGestureDelegate?
    
    func setupAdditionalGestures(forView: UIView) {
        forView.subviews.forEach { (view) in
            let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(recognizer:forView:)))
            view.isUserInteractionEnabled = true
            view.addGestureRecognizer(singleTap)
        }
    }
    
    @objc func handleSingleTap(recognizer: UITapGestureRecognizer, forView: UIView) {
        guard let recognizerImageView = recognizer.view as? UIImageView else { return }
        guard let tappedViewIndex: Int = forView.subviews.firstIndex(of: recognizerImageView) else { return }
        
        selectionsCoordinatesInRealm[tappedViewIndex].isMarked.toggle()
        
        
        let selection = selectionsCoordinatesInRealm[tappedViewIndex]
        print("selection after toggle: \(selection.isMarked)")
        
        let imageNumber = (tappedViewIndex % 4) + 1
        let imageToSet = selection.isMarked ? "markedSelection\(imageNumber).png" : "selection\(imageNumber).png"
        
        recognizerImageView.image = UIImage(named: imageToSet)
    }
}
