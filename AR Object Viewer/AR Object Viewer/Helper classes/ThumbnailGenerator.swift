//
//  ThumbnailGenerator.swift
//  AR Object Viewer
//
//  Created by Rohan Bimal Raj on 15/10/22.
//

import Foundation
import QuickLookThumbnailing
import UIKit

class ThumbnailGenerator {
    static let shared = ThumbnailGenerator()
    
    private init() {}
    
    
    func getThumbnailsOfModels(modelName:String,completion: @escaping(UIImage) -> ()) {
        
        if let url = Bundle.main.url(forResource: modelName, withExtension: "usdz") {
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
