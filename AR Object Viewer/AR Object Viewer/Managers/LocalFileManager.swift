//
//  LocalFileManager.swift
//  AR Object Viewer
//
//  Created by Rohan Bimal Raj on 06/11/22.
//

import Foundation
import UIKit

enum UserDefaultKeys: String {
    case FIRST_STARTUP = "firstStartup"
}

protocol SupportedUserDefaultTypes {}
extension Bool: SupportedUserDefaultTypes {}
extension String: SupportedUserDefaultTypes {}

class LocalFileManager {
    
    private var modelFolderUrl: URL? {
        get {
            guard let baseUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return nil}
            let folderUrl = baseUrl.appendingPathComponent("Models")
            return folderUrl
        }
    }
    
    static let shared = LocalFileManager()
    
    private init() {}
    
    func createFolderForModels() {
        guard let folderUrl = modelFolderUrl else {return}
        do {
            try FileManager.default.createDirectory(at: folderUrl, withIntermediateDirectories: true, attributes: nil)
            copyItemsFromBundleToDirectory(fileExtension: ".usdz")
            deleteItem(from: "AirForce.usdz")

        }catch(let error) {
            print("Rohan's error",error)
        }
    }
    
    private func copyItemsFromBundleToDirectory(fileExtension: String) {
        if let resPath = Bundle.main.resourcePath {
            guard let filteredFiles = getItemNamesInDirectory(from: resPath) else {return}
            for fileName in filteredFiles {
                let sourceURL = Bundle.main.bundleURL.appendingPathComponent(fileName)
                copyItemToDirectory(from: sourceURL)
            }
        }
    }
    
    func deleteItem(from url:String) {
        do {
            if let itemPath = modelFolderUrl?.appendingPathComponent(url) {
                try FileManager.default.removeItem(at: itemPath)
            }
        }catch(let error) {
            print("Rohan's error:",error)
        }
    }
    
    func copyItemToDirectory(from url:URL) {
        print("Rohan's test one:",url)
        if let destinationUrl = modelFolderUrl?.appendingPathComponent(url.lastPathComponent) {
            print("Rohan's test one:",destinationUrl)
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                print("File already exist")
            }else {
                do {
                    try FileManager.default.copyItem(at: url, to: destinationUrl)
                }catch {
                    print("Rohan's error:",error.localizedDescription)
                }
            }
        }else {
            print("Rohan's error:","BAD URL!!!")
        }
    }
    
    func getItemNamesInDirectory(from path:String? = nil) ->[String]? {
        if let path = (path ?? modelFolderUrl?.path) {
            do {
                let dirContents = try FileManager.default.contentsOfDirectory(atPath: path)
                let filteredFiles = dirContents.filter{ $0.contains(".usdz")}
                return filteredFiles
            }catch(let error) {
                print("Rohan's error:",error)
            }
        }
        return nil
    }
    
    func registerKeys() {
        UserDefaults.standard.register(defaults: [
            UserDefaultKeys.FIRST_STARTUP.rawValue : false
        ])
    }
    
    func getValue<T: SupportedUserDefaultTypes>(for key:String) -> T? {
        UserDefaults.standard.object(forKey: key) as? T
    }
    
    func setValue<T: SupportedUserDefaultTypes>(set value:T, for key:String) {
        UserDefaults.standard.set(value, forKey: key)
    }
}
