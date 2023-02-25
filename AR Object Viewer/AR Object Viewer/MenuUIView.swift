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
    func addOrRemoveButtonClicked(model: ARModel)
}

class MenuUIView: UIView {
    

    @IBOutlet weak var expandAndCollapseImageView: UIImageView!
    @IBOutlet weak var menuViewBottomContraint: NSLayoutConstraint!
    @IBOutlet weak var carousel: ScalingCarouselView!
    @IBOutlet weak var addOrRemoveButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    weak var delegate: MenuUIViewDelegate? = nil
    var isMenuOpen: Bool = false
    //var modelNames: [String] = []
    var models: [ARModel] = []
    private var currntItemIndex = 0

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
        addOrRemoveButton.layer.cornerRadius = 40/2
        addButton.layer.cornerRadius = 40/2
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let modelNames = LocalFileManager.shared.getItemNamesInDirectory() ?? []
            modelNames.forEach { [weak self] name in
                let model = ARModel(name: name)
                self?.models.append(model)
            }
            self.carousel.reloadData()
        }
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
            self.setTitleForAddOrRemoveButton()
            self.isMenuOpen.toggle()
            self.expandAndCollapseImageView.isUserInteractionEnabled = true            
        }
    }
    
    private func setTitleForAddOrRemoveButton() {
        if self.models[currntItemIndex].inScene {
            addOrRemoveButton.setTitle("Remove", for: .normal)
        }else {
            addOrRemoveButton.setTitle("Add", for: .normal)
        }
    }

    @IBAction func addOrRemoveButtonClicked(_ sender: UIButton) {
        onTapped()
        Timer.scheduledTimer(withTimeInterval: 0.85, repeats: false) { timer in
            self.delegate?.addOrRemoveButtonClicked(model: self.models[self.currntItemIndex])
            timer.invalidate()
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
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselCell", for: indexPath) as! CarouselCell
        cell.model = models[indexPath.row]
        DispatchQueue.main.async {
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        carousel.didScroll()
        currntItemIndex = carousel.currentCenterCellIndex?.row ?? 0
        setTitleForAddOrRemoveButton()
    }
    
}
