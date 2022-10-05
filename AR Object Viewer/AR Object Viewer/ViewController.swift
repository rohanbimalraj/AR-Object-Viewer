//
//  ViewController.swift
//  AR Object Viewer
//
//  Created by Rohan Bimal Raj on 03/10/22.
//

import UIKit
import RealityKit

class ViewController: UIViewController {
    
    @IBOutlet var arView: ARView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cube = ModelEntity(mesh: .generateBox(size: 0.1),materials: [SimpleMaterial(color: .red, isMetallic: true)])
        let anchor = AnchorEntity(world: [0,0,-0.5])
        anchor.addChild(cube)
        arView.scene.addAnchor(anchor)
    }
}
