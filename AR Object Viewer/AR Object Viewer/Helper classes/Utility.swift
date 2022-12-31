//
//  Utility.swift
//  AR Object Viewer
//
//  Created by Rohan Bimal Raj on 26/11/22.
//

import Foundation
import UIKit
import QuickLookThumbnailing

class Utility {
    
    static let shared = Utility()
    
    private init() {}
    
    private func getRootViewController() -> UIViewController? {
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        let rootVC = window?.rootViewController
        return rootVC
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "An error occurred", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default,handler: { _ in
            alert.dismiss(animated: true)
        }))
        getRootViewController()?.present(alert, animated: true)
    }
    
    func getThumbnailsOfModels(modelName:String,completion: @escaping(UIImage) -> ()) {
        
        if let url = LocalFileManager.shared.getModelUrl(name: modelName) {
            let scale = UIScreen.main.scale
            let request = QLThumbnailGenerator.Request(fileAt: url, size: CGSize(width: 400, height: 400), scale: scale, representationTypes: .all)
            let generator = QLThumbnailGenerator.shared
            generator.generateRepresentations(for: request) { (thumnail, type, error) in
                if thumnail == nil || error != nil {
                    print("Error in generating thumbnail:\(error?.localizedDescription ?? "UNKNOW")")
                }else {
                    completion(thumnail!.uiImage)
                }
            }
        }
    }
}
