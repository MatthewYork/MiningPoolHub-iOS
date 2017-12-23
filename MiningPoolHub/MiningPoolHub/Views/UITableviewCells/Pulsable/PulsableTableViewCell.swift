//
//  PulsableTableViewCell.swift
//  MiningPoolHub
//
//  Created by Matthew York on 12/20/17.
//

import UIKit
import QuartzCore

class PulsableTableViewCell: UITableViewCell {

    var pulseCount = 0
    let pulseMax = 5
    
    @IBOutlet weak var pulseView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func resetPulse() {
        pulseCount = 0
        pulseView.layer.removeAllAnimations()
    }

    func animatePulseView(){
        if pulseCount > pulseMax {return}
        pulseCount += 1
        
        UIView.animate(withDuration: 1.5, animations: {
            self.pulseView.backgroundColor = UIColor.white
        }) { (success) in
            UIView.animate(withDuration: 1.5, animations: {
                self.pulseView.backgroundColor = UIColor.lightGray
            }, completion: { (success) in
                self.animatePulseView()
            })
        }
    }
}
