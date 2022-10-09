//
//  MenuUIView.swift
//  AR Object Viewer
//
//  Created by Rohan Bimal Raj on 08/10/22.
//

import UIKit

class MenuUIView: UIView {
    
    @IBOutlet weak var expandAndCollapseImageView: UIImageView!
    @IBOutlet weak var menuViewBottomContraint: NSLayoutConstraint!
    var isMenuOpen:Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()

    }
    
    func setUp() {
        setUpTapGesture()
        print("Rohan's:",UIScreen.main.bounds.height)
        menuViewBottomContraint.constant = -(UIScreen.main.bounds.height * 0.45) + 52
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

}
