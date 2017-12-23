//
//  WorkerCollectionViewCell.swift
//  MiningPoolHub
//
//  Created by Matthew York on 12/20/17.
//

import UIKit
import MiningPoolHub_Swift

class WorkerCollectionViewCell: PulsableCollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var hashRateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func setContent(worker: MphsWorkerData) {
        usernameLabel.text = worker.username
        coinLabel.text = worker.coin
        
        if let hashrate = worker.hashrate {
            let rateString = String(format: "%.2f KH/s", hashrate)
            hashRateLabel.text = rateString
        }
    }
}
