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
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet var arView: ARView!
    @IBOutlet weak var menuView: MenuUIView!
    @IBOutlet weak var messageView: UIView!
    var cancellable:AnyCancellable? = nil
    let anchor = AnchorEntity(world: [0,0,-0.5])
    var focusEntity: FocusEntity? = nil
    private var model: ARModel? = nil
    private var tapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
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
        focusEntity?.isEnabled = false
        enableTapGesture()
        messageView.isHidden = true
        messageView.layer.cornerRadius = 5
   }
    private func configure() {
        arView.automaticallyConfigureSession = false
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.vertical, .horizontal]
        arView.session.run(config)
    }
    
    private func enableTapGesture() {
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        self.arView.addGestureRecognizer(tapGesture)
        self.arView.isUserInteractionEnabled = false
    }
    
    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        let tapLocation = recognizer.location(in: self.arView)
        let results = self.arView.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .any)
        if let firstResult = results.first {
            let position = simd_make_float3(firstResult.worldTransform.columns.3)
            addTransition()
            messageLabel.text = "Please stand by till the model is placed"
            loadModel(at: position)
        }else {
            addTransition()
            messageLabel.text = "Oops please try again!"
        }
    }
    
    private func loadModel(at position: SIMD3<Float>) {
        guard let url = LocalFileManager.shared.getModelUrl(name: model!.name) else {return}
        cancellable = Entity.loadAsync(contentsOf: url)
            .sink { error in
                print("Error:",error)
            } receiveValue: { entity in
                let parentEntity = ModelEntity()
                parentEntity.addChild(entity)
                let anchor = AnchorEntity(world: position)
                self.model?.anchor = anchor
                self.model?.model = entity
                self.arView.scene.addAnchor(anchor)
                anchor.addChild(parentEntity)
                let entityBounds = entity.visualBounds(relativeTo: parentEntity)
                parentEntity.collision = CollisionComponent(shapes: [ShapeResource.generateBox(size: entityBounds.extents).offsetBy(translation: entityBounds.center)])
                self.arView.installGestures(for: parentEntity)
                anchor.name = self.model!.name
                self.focusEntity?.isEnabled = false
                self.cancellable?.cancel()
                self.model = nil
                self.tapGesture.isEnabled = false
                UIView.transition(with: self.messageView, duration: 0.4,
                                  options: .transitionCrossDissolve,
                                  animations: {
                    self.messageView.isHidden = true
                })
            }
    }
    
    private func addTransition() {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = .push
        animation.subtype = .fromTop
        animation.duration = TimeInterval(0.5)
        self.messageLabel.layer.add(animation, forKey: CATransitionType.push.rawValue)
    }
}
extension ViewController: MenuUIViewDelegate {
    func addOrRemoveButtonClicked(model: ARModel) {
        if !model.inScene {
            self.model = model
            self.focusEntity?.isEnabled = true
            self.arView.isUserInteractionEnabled = true
            self.tapGesture.isEnabled = true
            self.messageLabel.text = "Once plane is detected tap the position where you wanna place the model."
            UIView.transition(with: self.messageView, duration: 0.4,
                              options: .transitionCrossDissolve,
                              animations: {
                self.messageView.isHidden = false
            })
        }else {
            model.removeFromParent()
            self.messageLabel.text = "\(model.name) is removed from scene"
            UIView.transition(with: self.messageView, duration: 0.4,
                              options: .transitionCrossDissolve,
                              animations: {
                self.messageView.isHidden = false
            }) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0 ) {
                    self.messageView.isHidden = true
                }
            }
        }
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
            print("Rohan's test:", url.lastPathComponent)
            menuView.addNewModel(name: url.lastPathComponent)
            LocalFileManager.shared.copyItemToDirectory(from: url)

        }
    }
}
