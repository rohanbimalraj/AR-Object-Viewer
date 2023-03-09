//
//  ARModel.swift
//  AR Object Viewer
//
//  Created by Rohan Bimal Raj on 19/02/23.
//

import Foundation
import RealityKit


class ARModel {
    
    var name: String = ""
    var animationAvailable: Bool {
        get {
            return  !(model?.availableAnimations.isEmpty ?? true)
        }
    }
    var inScene: Bool {
        get {
            return model != nil
        }
    }
    var isPlaying: Bool = false
    var model: Entity? = nil
    var anchor: AnchorEntity? = nil
    
    init(name: String, isPlaying: Bool = false, model: ModelEntity? = nil, anchor: AnchorEntity? = nil) {
        self.name = name
        self.isPlaying = isPlaying
        self.model = model
        self.anchor = anchor
    }
    
    func removeFromParent() {
        model?.removeFromParent()
        anchor?.removeFromParent()
        model = nil
        anchor = nil
    }
    
    func startAnimation() {
        guard model != nil else { return }
        for animation in (model?.availableAnimations ?? [] ) {
            model?.playAnimation(animation.repeat())
        }
        isPlaying = true
    }
    
    func stopAnimation() {
        guard model != nil else { return }
        model?.stopAllAnimations(recursive: true)
        isPlaying = false
    }
}
