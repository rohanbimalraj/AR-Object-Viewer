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
    
    private func getModelNames() -> [String] {
        let fileManager = FileManager.default
        let path = Bundle.main.resourcePath!
        var modelNames:[String] = []
        do {
            let items = try fileManager.contentsOfDirectory(atPath: path)
            let filterItems = items.filter{$0.contains(".usdz")}
            modelNames = filterItems.compactMap{
                let components = $0.components(separatedBy: ".")
                return components.first
            }
        }catch {
            print("Failed to get directory!!!")
        }
        return modelNames
    }
    
    func getThumbnailsOfModels(modelName:String,completion: @escaping(UIImage) -> ()) {
        
        if let url = Bundle.main.url(forResource: modelName, withExtension: "usdz") {
            let scale = UIScreen.main.scale
            let request = QLThumbnailGenerator.Request(fileAt: url, size: CGSize(width: 400, height: 400), scale: scale, representationTypes: .all)
            let generator = QLThumbnailGenerator.shared
            generator.generateRepresentations(for: request) { (thumnail, type, error) in
                if thumnail == nil || error != nil {
                   print("Error in generating thumbnail")
                }else {
                    completion(thumnail!.uiImage)
                }
            }
        }
    }
}
