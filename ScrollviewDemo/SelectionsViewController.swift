//
//  SelectionsViewController.swift
//  ScrollviewDemo
//
//  Created by Adrian Kwiatkowski on 05/11/2018.
//  Copyright © 2018 Adrian Kwiatkowski. All rights reserved.
//

class AddingSelectionsViewController: SelectionsViewController {
    
    
    
    override func setupGestureRecognizers() {
        super.setupGestureRecognizers()
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(recognizer:)))
        selectionsView.addGestureRecognizer(longPress)
    }
    
    @objc func handleLongPress(recognizer: UILongPressGestureRecognizer) {
        guard recognizer.state == .began else { return }
        
        let longPressedCenter = Selection(point: recognizer.location(in: selectionsView), isMarked: false)
        
        selectionsArray.append(longPressedCenter)
    }
}

class EditingSelectionsViewController: SelectionsViewController {
    override func setupGestureRecognizers() {
        super.setupGestureRecognizers()
        
        selectionsView.subviews.forEach { (view) in
            let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(recognizer:)))
            view.isUserInteractionEnabled = true
            view.addGestureRecognizer(singleTap)
        }
    }
    
    @objc func handleSingleTap(recognizer: UITapGestureRecognizer) {
        guard let recognizerImageView = recognizer.view as? UIImageView else { return }
        guard let tappedViewIndex: Int = selectionsView.subviews.firstIndex(of: recognizerImageView) else { return }
        
        selectionsArray[tappedViewIndex].isMarked.toggle()
        
        
        let selection = selectionsArray[tappedViewIndex]
        print("selection after toggle: \(selection.isMarked)")
        
        let imageNumber = (tappedViewIndex % 4) + 1
        let imageToSet = selection.isMarked ? "markedSelection\(imageNumber).png" : "selection\(imageNumber).png"
        
        recognizerImageView.image = UIImage(named: imageToSet)
    }
}

var selectionsArray: [Selection] = []

struct Selection {
    let point: CGPoint
    var isMarked: Bool
}

import UIKit

class SelectionsViewController: UIViewController {
    
    lazy var scrollView: UIScrollView = UIScrollView(frame: view.bounds)
    var imageView: UIImageView = UIImageView(image: UIImage(named: "leaflet.jpg"))
    var selectionsView: UIView = UIView()
    var containerView: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSelectionsView()
        setupContainerView()
        setupScrollView()
        
        clearSelectionsView()
        addSubviewsToSelectionsView()
        fillSelectionViewSubviewsWithImages()
        
        setupGestureRecognizers()
    }
    
    func addSubviewsToSelectionsView() {
        //        let selectionWidthRatio: CGFloat = 0.24
        
        
        selectionsArray.enumerated().forEach { (index, selection) in
            //            let imageToSet = returnSelectionVariationImageAsset(number: index, isMarked: selection.isMarked)
            //            let point = selection.point
            
            //            let subviewWidth = imageView.bounds.width * selectionWidthRatio
            //            let subviewHeight = (subviewWidth / imageToSet.size.width) * imageToSet.size.height
            //            let subviewCenterX = point.x - (subviewWidth / 2)
            //            let subviewCenterY = point.y - (subviewHeight / 2)
            
            let selectionCenter = CGPoint(x: selection.point.x, y: selection.point.y)
            let subviewToAdd = UIImageView(frame: CGRect(origin: selectionCenter, size: CGSize()))
            
            selectionsView.addSubview(subviewToAdd)
        }
    }
    
    func fillSelectionViewSubviewsWithImages() {
        selectionsView.subviews.enumerated().forEach { (index, subview) in
            guard let selectionImageView = subview as? UIImageView else { return }
            
            let selection = selectionsArray[index]
            
            selectionImageView.image = returnSelectionVariationImageAsset(number: index, isMarked: selection.isMarked)
        }
    }
    
    func returnSelectionVariationImageAsset(number: Int, isMarked: Bool) -> UIImage {
        let imageVariationNumber = (number % 4) + 1
        let imageVariationName = isMarked ? "markedSelection\(imageVariationNumber).png" : "selection\(imageVariationNumber).png"
        return UIImage(named: imageVariationName) ?? UIImage()
    }
    
    func setupSelectionsView() {
        selectionsView.frame = CGRect(x: 0, y: 0, width: imageView.bounds.width, height: imageView.bounds.height)
    }
    
    func setupContainerView() {
        containerView.frame = CGRect(x: 0, y: 0, width: imageView.bounds.width, height: imageView.bounds.height)
        containerView.addSubview(imageView)
        containerView.addSubview(selectionsView)
    }
    
    func setupScrollView() {
        scrollView.backgroundColor = UIColor.black
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentSize = containerView.bounds.size
        scrollView.addSubview(containerView)
        
        setZoomScale()
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0.0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0.0).isActive = true
    }
    
    func setupGestureRecognizers() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(recognizer:)))
        doubleTap.numberOfTapsRequired = 2
        selectionsView.addGestureRecognizer(doubleTap)
    }
    
    func setZoomScale() {
        let containerViewSize = containerView.bounds.size
        let scrollViewSize = scrollView.bounds.size
        let widthScale = scrollViewSize.width / containerViewSize.width
        let heightScale = scrollViewSize.height / containerViewSize.height
        
        scrollView.minimumZoomScale = min(widthScale, heightScale)
        scrollView.maximumZoomScale = 2.0 / UIScreen.main.scale
        scrollView.zoomScale = scrollView.minimumZoomScale
    }
    
    override func viewWillLayoutSubviews() {
        setZoomScale()
    }
    
    
    
    fileprivate func clearSelectionsView() {
        selectionsView.subviews.forEach { (subview) in
            subview.removeFromSuperview()
        }
    }
}

extension SelectionsViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return containerView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let containerViewSize = containerView.frame.size
        let scrollViewSize = scrollView.bounds.size
        
        let verticalPadding = containerViewSize.height < scrollViewSize.height ? (scrollViewSize.height - containerViewSize.height) / 2 : 0
        let horizontalPadding = containerViewSize.width < scrollViewSize.width ? (scrollViewSize.width - containerViewSize.width) / 2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }
}

//MARK: - gestures
extension SelectionsViewController {
    
    @objc func handleDoubleTap(recognizer: UITapGestureRecognizer) {
        
        if (scrollView.zoomScale > scrollView.minimumZoomScale) {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
        }
    }
}
