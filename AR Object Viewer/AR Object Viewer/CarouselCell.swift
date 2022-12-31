//
//  CarouselCell.swift
//  AR Object Viewer
//
//  Created by Rohan Bimal Raj on 15/10/22.
//

import UIKit
import ScalingCarousel

class CarouselCell: ScalingCarouselCell {

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var shadowView: UIView!
    var modelName:String? {
        didSet {
             Utility.shared.getThumbnailsOfModels(modelName: modelName!, completion: { image in
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
        thumbnailImageView.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
        thumbnailImageView.layer.borderWidth = 0.5
        thumbnailImageView.layer.cornerRadius = 20
        
        shadowView.layer.cornerRadius = 20
        shadowView.layer.shadowRadius = 5
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.4
        shadowView.layer.shadowOffset = CGSize(width: -2, height: 5)
        
        playButton.layer.cornerRadius = 29/2
        deleteButton.layer.cornerRadius = 29/2
    }
}
