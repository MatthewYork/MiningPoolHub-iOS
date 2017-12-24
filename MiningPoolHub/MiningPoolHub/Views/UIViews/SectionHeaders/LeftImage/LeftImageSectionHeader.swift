//
//  LeftImageSectionHeader.swift
//  MiningPoolHub
//
//  Created by Matthew York on 12/23/17.
//

import UIKit

class LeftImageSectionHeader: UIView {

    //Variables
    var auxillarySelector: (()->())?
    
    //Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var auxillaryButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setContent(image:UIImage?, title: String?, auxillaryButtonTitle: String? = nil, auxillarySelector: (()->())? = nil ) {
        imageView.image = image
        titleLabel.text = title
        
        //Set auxillary selector
        auxillaryButton.setTitle(auxillaryButtonTitle, for: UIControlState.normal)
        self.auxillarySelector = auxillarySelector
    }
    
    //MARK: - Actions
    @IBAction func didTapAuxillaryButton() {
        auxillarySelector?()
    }
}
