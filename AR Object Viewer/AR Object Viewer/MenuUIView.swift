//
//  MenuUIView.swift
//  AR Object Viewer
//
//  Created by Rohan Bimal Raj on 08/10/22.
//

import UIKit
import ScalingCarousel
import UniformTypeIdentifiers

protocol MenuUIViewDelegate: NSObject {
    func addButtonClicked()
}

class MenuUIView: UIView {
    

    @IBOutlet weak var expandAndCollapseImageView: UIImageView!
    @IBOutlet weak var menuViewBottomContraint: NSLayoutConstraint!
    @IBOutlet weak var carousel: ScalingCarouselView!
    @IBOutlet weak var addOrRemoveButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    weak var delegate: MenuUIViewDelegate? = nil
    var isMenuOpen:Bool = false
    var modelNames:[String] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()

    }
    
    func setUp() {
        carousel.delegate = self
        carousel.dataSource = self
        setUpTapGesture()
        carousel.inset = 100//CGFloat(CFloat(Int((UIScreen.main.bounds.width - 187)/2)))
        menuViewBottomContraint.constant = -(UIScreen.main.bounds.height * 0.45) + 52
        modelNames = ModelNameRetriever.shared.getModelNames()
        addOrRemoveButton.layer.cornerRadius = 40/2
        addButton.layer.cornerRadius = 40/2
        carousel.reloadData()
    }
    
    func setUpTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapped))
        expandAndCollapseImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func onTapped() {
        expandAndCollapseImageView.isUserInteractionEnabled = false
        if isMenuOpen {
            menuViewBottomContraint.constant = -(UIScreen.main.bounds.height * 0.45) + 52
        }else {
            menuViewBottomContraint.constant = 0
        }
        UIView.animate(withDuration: 0.75) {
            self.superview?.layoutIfNeeded()
            if self.isMenuOpen {
                self.expandAndCollapseImageView.transform = CGAffineTransformIdentity
            }else {
                self.expandAndCollapseImageView.transform = CGAffineTransform(rotationAngle: .pi)
            }
        }completion: { _ in
            self.isMenuOpen.toggle()
            self.expandAndCollapseImageView.isUserInteractionEnabled = true
        }
    }

    @IBAction func addButtonAction(_ sender: UIButton) {
        delegate?.addButtonClicked()
    }
}

extension MenuUIView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modelNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselCell", for: indexPath) as! CarouselCell
        cell.modelName = modelNames[indexPath.row]
        DispatchQueue.main.async {
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        carousel.didScroll()
    }
    
}
