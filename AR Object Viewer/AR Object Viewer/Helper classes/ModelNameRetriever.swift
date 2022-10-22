//
//  ModelNameRetriever.swift
//  AR Object Viewer
//
//  Created by Rohan Bimal Raj on 22/10/22.
//

import Foundation

class ModelNameRetriever {
    
    private init() {}
    
    static let shared = ModelNameRetriever()
    
    func getModelNames() -> [String] {
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
}
