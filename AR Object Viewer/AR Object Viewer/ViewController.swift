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

class ViewController: UIViewController {
    
    @IBOutlet var arView: ARView!
    @IBOutlet weak var menuView: MenuUIView!
    var cancellable:AnyCancellable? = nil
    let anchor = AnchorEntity(world: [0,0,-0.5])
    override func viewDidLoad() {
        super.viewDidLoad()
        menuView.delegate = self
        arView.scene.addAnchor(anchor)

        if !(LocalFileManager.shared.getValue(for: UserDefaultKeys.FIRST_STARTUP.rawValue) ?? false) {
            LocalFileManager.shared.createFolderForModels()
            LocalFileManager.shared.setValue(set: true, for: UserDefaultKeys.FIRST_STARTUP.rawValue)
        }
   }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
}
extension ViewController: MenuUIViewDelegate {
    func addOrRemoveButtonClicked(modelName: String) {
        guard let url = LocalFileManager.shared.getModelUrl(name: modelName) else {return}
        cancellable = Entity.loadAsync(contentsOf: url)
            .sink { error in
                print("Error:",error)
            } receiveValue: { entity in
                
                self.anchor.addChild(entity)
                self.cancellable?.cancel()
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
            LocalFileManager.shared.copyItemToDirectory(from: url)
        }
    }
}
