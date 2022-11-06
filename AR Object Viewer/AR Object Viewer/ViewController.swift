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

class ViewController: UIViewController {
    
    @IBOutlet var arView: ARView!
    var cancellable:AnyCancellable? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        let anchor = AnchorEntity(world: [0,0,-0.5])
//        cancellable = Entity.loadAsync(named: "AirForce")
//            .sink { error in
//                print("Error:",error)
//            } receiveValue: { entity in
//                anchor.addChild(entity)
//                self.arView.scene.addAnchor(anchor)
//                self.cancellable?.cancel()
//            }
        
//        let fileManager = FileManager.default
//        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
//        print("Rohan's url:",url)
//        
//        let newFolder = url.appendingPathExtension("rohan's - folder")
//        do {
//            try  fileManager.createDirectory(at: newFolder, withIntermediateDirectories: true)
//
//        }catch {
//            print("Error occured")
//        }
        createFileInDocumentsDirectory()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.usdz])
//            documentPicker.delegate = self
//            documentPicker.allowsMultipleSelection = true
//            present(documentPicker, animated: true, completion: nil)
//    }
    
    func createFileInDocumentsDirectory() {
        let file = "test.txt"
        let text = "Hello world"

        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = dir.appendingPathComponent(file)
        try! text.write(to: fileURL, atomically: false, encoding: .utf8)
    }

}
