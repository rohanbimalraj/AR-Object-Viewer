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
    
    @IBOutlet weak var controlPanelView: UIView!
    @IBOutlet weak var expandAndCollapseImageView: UIImageView!
    @IBOutlet weak var menuViewBottomContraint: NSLayoutConstraint!
    @IBOutlet weak var carousel: ScalingCarouselView!
    @IBOutlet weak var addOrRemoveButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    weak var delegate: MenuUIViewDelegate? = nil
    var isMenuOpen: Bool = false
    private let defaultModels: [String] = ["toy_drummer.usdz", "toy_biplane.usdz", "AirForce.usdz"]
    //var modelNames: [String] = []
    var models: [ARModel] = []
    private var currntItemIndex = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
        self.layoutIfNeeded()
    }
    
    func setUp() {
        carousel.delegate = self
        carousel.dataSource = self
        setUpTapGesture()
        deleteButton.isHidden = true
        carousel.inset = 100//CGFloat(CFloat(Int((UIScreen.main.bounds.width - 187)/2)))
        menuViewBottomContraint.constant = -(UIScreen.main.bounds.height * 0.45) + 52
        addOrRemoveButton.layer.cornerRadius = 40/2
        playButton.layer.cornerRadius = 19
        deleteButton.layer.cornerRadius = 19
        addButton.layer.cornerRadius = 20
        controlPanelView.addDropShadow(with: 20)
        playButton.isHidden = true
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
    
    func setTitleForAddOrRemoveButton() {
        if defaultModels.contains(where: {$0 == self.models[currntItemIndex].name}) {
            deleteButton.isHidden = true
        }else {
            deleteButton.isHidden = false
        }
        if self.models[currntItemIndex].inScene {
            addOrRemoveButton.setTitle("Remove", for: .normal)
            guard self.models[currntItemIndex].animationAvailable else {
                playButton.isHidden = true
                return
            }
            playButton.isHidden = false
            if self.models[currntItemIndex].isPlaying {
                playButton.setImage(UIImage(systemName: "stop.fill"), for: .normal)
            }else {
                playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            }
        }else {
            addOrRemoveButton.setTitle("Add", for: .normal)
            playButton.isHidden = true
        }
    }
    func addNewModel(name: String) {
        DispatchQueue.main.async {
            let model = ARModel(name: name)
            self.models.insert(model, at: self.currntItemIndex)
            self.carousel.reloadData()
            self.deleteButton.isHidden = false
        }
    }
    @IBAction func deleteButtonAction(_ sender: UIButton) {
        let modelName = self.models[currntItemIndex].name
        self.models[currntItemIndex].removeFromParent()
        self.models = models.filter({$0.name != modelName})
        carousel.reloadData()
        LocalFileManager.shared.deleteItem(with: modelName)
        if defaultModels.contains(where: {$0 == self.models[currntItemIndex].name}) {
            deleteButton.isHidden = true
        }else {
            deleteButton.isHidden = false
        }
        
    }
    @IBAction func playButtonAction(_ sender: UIButton) {
        if !self.models[currntItemIndex].isPlaying {
            self.models[currntItemIndex].startAnimation()
            playButton.setImage(UIImage(systemName: "stop.fill"), for: .normal)

        }else {
            self.models[currntItemIndex].stopAnimation()
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)

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
        //setTitleForAddOrRemoveButton()
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setTitleForAddOrRemoveButton()
    }
}
extension UIView {
    func addDropShadow(with cornerRadius: CGFloat) {
        //To round the corners
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        
        //To add shadow
        self.layer.shadowRadius = 7
        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset = CGSize(width: 3, height: 5)
        self.layer.shadowColor = UIColor.darkGray.withAlphaComponent(0.7).cgColor
        self.layer.masksToBounds = false
        
    }
}
