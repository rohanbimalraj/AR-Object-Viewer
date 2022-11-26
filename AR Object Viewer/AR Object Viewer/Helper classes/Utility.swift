//
//  Utility.swift
//  AR Object Viewer
//
//  Created by Rohan Bimal Raj on 26/11/22.
//

import Foundation
import UIKit

class Utility {
    
    static let shared = Utility()
    
    private init() {}
    
    func getRootViewController() {
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        let rootVC = window?.rootViewController
        print("Rohan's rootViewController:",rootVC)
    }
}
