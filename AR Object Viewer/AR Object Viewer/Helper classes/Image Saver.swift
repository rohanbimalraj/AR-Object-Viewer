//
//  Image Saver.swift
//  AR Object Viewer
//
//  Created by Rohan Bimal Raj on 11/03/23.
//

import Foundation
import UIKit

class ImageSaver: NSObject {
    
    public var didSaveImage: (() -> Void)?
    func writeToPhotoAlbum(image: UIImage) {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
        }

        @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
            if let error = error {
                print("error: \(error.localizedDescription)")
            } else {
                didSaveImage?()
            }
        }
    
}
