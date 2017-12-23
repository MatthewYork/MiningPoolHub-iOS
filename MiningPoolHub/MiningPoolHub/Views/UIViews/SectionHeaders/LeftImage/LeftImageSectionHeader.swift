//
//  LeftImageSectionHeader.swift
//  MiningPoolHub
//
//  Created by Matthew York on 12/23/17.
//

import UIKit

class LeftImageSectionHeader: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setContent(image:UIImage?, title: String?) {
        imageView.image = image
        titleLabel.text = title
    }
}
