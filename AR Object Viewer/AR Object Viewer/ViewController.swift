//
//  ViewController.swift
//  AR Object Viewer
//
//  Created by Rohan Bimal Raj on 03/10/22.
//

import UIKit
import RealityKit
import Combine

class ViewController: UIViewController {
    
    @IBOutlet weak var expandAndCollapseImageView: UIImageView!
    @IBOutlet weak var menuView: MenuUIView!
    @IBOutlet weak var menuViewBottomContraint: NSLayoutConstraint!
    @IBOutlet var arView: ARView!
    var cancellable:AnyCancellable? = nil
    var isMenuOpen:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        let anchor = AnchorEntity(world: [0,0,-0.5])
        
        cancellable = Entity.loadAsync(named: "AirForce")
            .sink { error in
                print("Error:",error)
            } receiveValue: { entity in
                anchor.addChild(entity)
                self.arView.scene.addAnchor(anchor)
                self.cancellable?.cancel()
            }
    }
    
    func setUp() {
        setUpTapGesture()
        menuViewBottomContraint.constant = -(view.bounds.height * 0.45) + 52
    }
    
    func setUpTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapped))
        expandAndCollapseImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func onTapped() {
        expandAndCollapseImageView.isUserInteractionEnabled = false
        if isMenuOpen {
            menuViewBottomContraint.constant = -(view.bounds.height * 0.45) + 52
        }else {
            menuViewBottomContraint.constant = 0
        }
        UIView.animate(withDuration: 0.75) {
            self.view.layoutIfNeeded()
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
