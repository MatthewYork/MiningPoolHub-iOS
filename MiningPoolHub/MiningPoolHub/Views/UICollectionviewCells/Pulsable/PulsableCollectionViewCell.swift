//
//  PulsableCollectionViewCell.swift
//  MiningPoolHub
//
//  Created by Matthew York on 12/20/17.
//

import UIKit

class PulsableCollectionViewCell: UICollectionViewCell {

    var shouldPulse: Bool = false
    var pulseCount = 0
    let pulseMax = 5
    
    @IBOutlet weak var pulseView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func resetPulse() {
        pulseCount = 0
    }

    func animatePulseView(){
        if pulseCount > pulseMax {return}
        
        UIView.animate(withDuration: 1.5, animations: {
            self.pulseView.backgroundColor = UIColor.white
        }) { (success) in
            UIView.animate(withDuration: 1.5, animations: {
                self.pulseView.backgroundColor = UIColor.lightGray
            }, completion: { (success) in
                self.pulseCount += 1
                self.animatePulseView()
            })
        }
    }
}
