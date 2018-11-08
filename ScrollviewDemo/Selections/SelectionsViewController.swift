//
//  SelectionsViewController.swift
//  ScrollviewDemo
//
//  Created by Adrian Kwiatkowski on 05/11/2018.
//  Copyright © 2018 Adrian Kwiatkowski. All rights reserved.
//



import UIKit

// data mock
var selectionsCoordinatesInRealm: [Selection] = []

struct Selection {
    let point: CGPoint
    var isMarked: Bool
}

class SelectionsViewController: UIViewController {
    lazy var scrollView: UIScrollView = UIScrollView(frame: view.bounds)
    var imageView: UIImageView = UIImageView(image: UIImage(named: "leaflet.jpg"))
    var selectionsView: UIView = UIView()
    var containerView: UIView = UIView()
    
    var additionalGestures: AdditionalGestures
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSelectionsView()
        setupContainerView()
        setupScrollView()
        
        refreshSelectionsView()
        
        setupGestureRecognizers()
        additionalGestures.setupAdditionalGestures(forView: selectionsView)
        additionalGestures.gestureDelegate = self
    }
    
    init(mode: AdditionalGestures) {
        self.additionalGestures = mode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
}

// MARK: - SelectionsView operations
extension SelectionsViewController {
    func refreshSelectionsView() {
        removeSubviewsFromSelectionsView()
        addEmptySubviewsToSelectionsView()
        fillSelectionViewSubviewsWithImages()
    }
    
    func removeSubviewsFromSelectionsView() {
        selectionsView.subviews.forEach { (subview) in
            subview.removeFromSuperview()
        }
    }
    
    func addEmptySubviewsToSelectionsView() {
        selectionsCoordinatesInRealm.enumerated().forEach { (index, selection) in
            let selectionCenter = CGPoint(x: selection.point.x, y: selection.point.y)
            let subviewToAdd = UIImageView(frame: CGRect(origin: selectionCenter, size: CGSize()))
            
            selectionsView.addSubview(subviewToAdd)
        }
    }
    
    func fillSelectionViewSubviewsWithImages() {
        let selectionWidthRatio: CGFloat = 0.24 // selection width should take 24% of the leaflet's width
        
        selectionsView.subviews.enumerated().forEach { (index, subview) in
            guard let selectionImageView = subview as? UIImageView else { return }
            
            let selection = selectionsCoordinatesInRealm[index]
            let point = selection.point
            let imageToSet = returnSelectionVariationImageAsset(number: index, isMarked: selection.isMarked)
            
            let subviewWidth = imageView.bounds.width * selectionWidthRatio
            let subviewHeight = (subviewWidth / imageToSet.size.width) * imageToSet.size.height
            let subviewCenterX = point.x - (subviewWidth / 2)
            let subviewCenterY = point.y - (subviewHeight / 2)
            
            selectionImageView.image = imageToSet
            selectionImageView.frame = CGRect(x: subviewCenterX, y: subviewCenterY, width: subviewWidth, height: subviewHeight)
        }
    }
    
    func returnSelectionVariationImageAsset(number: Int, isMarked: Bool) -> UIImage {
        let imageVariationNumber = (number % 4) + 1
        let imageVariationName = isMarked ? "markedSelection\(imageVariationNumber).png" : "selection\(imageVariationNumber).png"
        return UIImage(named: imageVariationName) ?? UIImage()
    }
}

// MARK: - basic gestures
extension SelectionsViewController {
    func setupGestureRecognizers() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(recognizer:)))
        doubleTap.numberOfTapsRequired = 2
        selectionsView.addGestureRecognizer(doubleTap)
    }
    
    @objc func handleDoubleTap(recognizer: UITapGestureRecognizer) {
        
        if (scrollView.zoomScale > scrollView.minimumZoomScale) {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
        }
    }
}

// MARK: - UIScrollViewDelegate
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
}

// MARK: - AdditionalGestureDelegate
extension SelectionsViewController: AdditionalGestureDelegate {
    func additionalGesture(_ gesture: AdditionalGestures, tappedAt view: UIImageView) {
        guard let tappedViewIndex: Int = selectionsView.subviews.firstIndex(of: view) else { return }
        
        selectionsCoordinatesInRealm[tappedViewIndex].isMarked.toggle()
        
        fillSelectionViewSubviewsWithImages()
    }
    
    func additionalGesture(_ gesture: AdditionalGestures, longpressedAt point: CGPoint) {
        let selectionWidthRatio: CGFloat = 0.24 // selection width should take 24% of the leaflet's width
        let imageToSet = UIImage(named: "greenSelection.png") ?? UIImage()
        let newSelectionView = UIImageView(image: imageToSet)
        
        let newSelectionViewWidth = imageView.bounds.width * selectionWidthRatio
        let newSelectionViewHeight = (newSelectionViewWidth / imageToSet.size.width) * imageToSet.size.height
        let newSelectionViewCenterX = point.x - (newSelectionViewWidth / 2)
        let newSelectionViewCenterY = point.y - (newSelectionViewHeight / 2)
        
        newSelectionView.frame = CGRect(x: newSelectionViewCenterX, y: newSelectionViewCenterY, width: newSelectionViewWidth, height: newSelectionViewHeight)
        selectionsView.addSubview(newSelectionView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            newSelectionView.removeFromSuperview()
            selectionsCoordinatesInRealm.append(Selection(point: point, isMarked: false))
            self.refreshSelectionsView()
        }
    }
}

