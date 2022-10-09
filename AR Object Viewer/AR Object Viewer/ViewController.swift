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
    
    @IBOutlet var arView: ARView!
    var cancellable:AnyCancellable? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
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
}
