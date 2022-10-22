//
//  CarouselCell.swift
//  AR Object Viewer
//
//  Created by Rohan Bimal Raj on 15/10/22.
//

import UIKit
import ScalingCarousel

class CarouselCell: ScalingCarouselCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    var modelName:String? {
        didSet {
             ThumbnailGenerator.shared.getThumbnailsOfModels(modelName: modelName!, completion: { image in
                 DispatchQueue.main.async {
                     self.thumbnailImageView.image = image
                 }
            })
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        thumbnailImageView.layer.borderColor = UIColor.red.cgColor
        thumbnailImageView.layer.borderWidth = 2
        thumbnailImageView.layer.cornerRadius = 20
    }
}
