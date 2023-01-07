//
//  ViewController.swift
//  AR Object Viewer
//
//  Created by Rohan Bimal Raj on 03/10/22.
//

import UIKit
import RealityKit
import Combine
import UniformTypeIdentifiers
import ARKit
import FocusEntity

class ViewController: UIViewController {
    
    @IBOutlet var arView: ARView!
    @IBOutlet weak var menuView: MenuUIView!
    var cancellable:AnyCancellable? = nil
    let anchor = AnchorEntity(world: [0,0,-0.5])
    var focusEntity: FocusEntity? = nil
    private var modelName: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        if !(LocalFileManager.shared.getValue(for: UserDefaultKeys.FIRST_STARTUP.rawValue) ?? false) {
            LocalFileManager.shared.createFolderForModels()
            LocalFileManager.shared.setValue(set: true, for: UserDefaultKeys.FIRST_STARTUP.rawValue)
        }
        menuView.delegate = self
        arView.scene.addAnchor(anchor)
        focusEntity = FocusEntity(on: self.arView, focus: .classic)
        enableTapGesture()
   }
    private func configure() {
        arView.automaticallyConfigureSession = false
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.vertical, .horizontal]
        arView.session.run(config)
    }
    
    private func enableTapGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        self.arView.addGestureRecognizer(gesture)
        self.arView.isUserInteractionEnabled = false
    }
    
    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        print("Rohan's tap")
        let tapLocation = recognizer.location(in: self.arView)
        let results = self.arView.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .any)
        if let firstResult = results.first {
            let position = simd_make_float3(firstResult.worldTransform.columns.3)
            loadModel(at: position)
        }else {
            
        }
    }
    
    private func loadModel(at position: SIMD3<Float>) {
        guard let url = LocalFileManager.shared.getModelUrl(name: modelName) else {return}
        cancellable = Entity.loadAsync(contentsOf: url)
            .sink { error in
                print("Error:",error)
            } receiveValue: { entity in
                
                let anchor = AnchorEntity(world: position)
                self.arView.scene.addAnchor(anchor)
                anchor.addChild(entity)
                anchor.name = self.modelName
                self.cancellable?.cancel()
            }
    }
}
extension ViewController: MenuUIViewDelegate {
    func addOrRemoveButtonClicked(modelName: String) {
        
        self.modelName = modelName
        self.arView.isUserInteractionEnabled = true
    }
    
    func addButtonClicked() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.usdz])
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = true
        documentPicker.modalPresentationStyle = .overFullScreen
        self.present(documentPicker, animated: true)
    }
}

extension ViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        urls.forEach { url in
            guard url.startAccessingSecurityScopedResource() else {return}
            LocalFileManager.shared.copyItemToDirectory(from: url)
        }
    }
}
