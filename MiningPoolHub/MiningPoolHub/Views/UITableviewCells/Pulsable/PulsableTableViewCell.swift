//
//  PulsableTableViewCell.swift
//  MiningPoolHub
//
//  Created by Matthew York on 12/20/17.
//

import UIKit

class PulsableTableViewCell: UITableViewCell {

    var shouldPulse: Bool = false
    @IBOutlet weak var pulseView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func animatePulseView(){
        if !shouldPulse {return}
        
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
