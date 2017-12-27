//
//  PoolStatusTableViewCell.swift
//  MiningPoolHub
//
//  Created by Matthew York on 12/26/17.
//

import UIKit
import MiningPoolHub_Swift
import DateToolsSwift

class PoolStatusTableViewCell: PulsableTableViewCell {

    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var workerCountLabel: UILabel!
    
    @IBOutlet weak var currentBlockLabel: UILabel!
    @IBOutlet weak var nextBlockLabel: UILabel!
    @IBOutlet weak var lastBlockLabel: UILabel!
    @IBOutlet weak var timeSinceLastBlockLabel: UILabel!
    @IBOutlet weak var networkDiffLabel: UILabel!
    
    @IBOutlet weak var estimatedSharesLabel: UILabel!
    @IBOutlet weak var hashRateLabel: UILabel!
    @IBOutlet weak var efficiencyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setContent(poolDetails: MphPoolStatus) {
        workerCountLabel.text = "\(poolDetails.workers) Workers"
        nameLabel.text = poolDetails.pool_name
        
        currentBlockLabel.text = "\(poolDetails.currentnetworkblock)"
        nextBlockLabel.text = "\(poolDetails.nextnetworkblock)"
        lastBlockLabel.text = "\(poolDetails.lastblock)"
        networkDiffLabel.text = "\(poolDetails.networkdiff)"
        
        estimatedSharesLabel.text = "\(poolDetails.estshares)"
        hashRateLabel.text = String(format: "%.2f KH/s", poolDetails.hashrate)
        efficiencyLabel.text = String(format: "%.2f", poolDetails.efficiency)
        
        //set time since
        let timeChunk = Int(poolDetails.timesincelast).seconds
        let date = Date().subtract(timeChunk)
        timeSinceLastBlockLabel.text = date.shortTimeAgoSinceNow
    }
}
