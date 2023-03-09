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
    @IBOutlet weak var shadowView: UIView!
    var model:ARModel? {
        didSet {
            guard model != nil else { return }
            Utility.shared.getThumbnailsOfModels(modelName: model!.name, completion: { image in
                 DispatchQueue.main.async {
                     self.thumbnailImageView.image = image
                 }
            })
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
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
    }
}
