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
    var model:ARModel? {
        didSet {
            guard model != nil else { return }
            playButton.isHidden = !(model?.animationAvailable ?? false)
            Utility.shared.getThumbnailsOfModels(modelName: model!.name, completion: { image in
                 DispatchQueue.main.async {
                     self.thumbnailImageView.image = image
                 }
            })
            NotificationCenter.default.addObserver(forName: Notification.Name(model!.name), object: nil, queue: nil) { _ in
                self.playButton.isHidden = !(self.model?.animationAvailable ?? false)
            }
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        playButton.isHidden = true
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
    @IBAction func playButtonAction(_ sender: UIButton) {
        if !(model?.isPlaying ?? false) {
            model?.startAnimation()
            playButton.setImage(UIImage(systemName: "stop.fill"), for: .normal)
        }else {
            model?.stopAnimation()
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }
}
