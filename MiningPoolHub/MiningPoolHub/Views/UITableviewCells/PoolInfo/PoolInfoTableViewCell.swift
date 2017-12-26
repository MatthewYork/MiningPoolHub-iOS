//
//  PoolTableViewCell.swift
//  MiningPoolHub
//
//  Created by Matthew York on 12/25/17.
//

import UIKit
import MiningPoolHub_Swift

class PoolInfoTableViewCell: PulsableTableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var coinNameLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var coinTargetLabel: UILabel!
    @IBOutlet weak var coinDiffTargetLabel: UILabel!
    @IBOutlet weak var stratumPortLabel: UILabel!
    @IBOutlet weak var payoutSystemLabel: UILabel!
    @IBOutlet weak var rewardTypeLabel: UILabel!
    @IBOutlet weak var rewardLabel: UILabel!
    @IBOutlet weak var apThresholdsLabel: UILabel!
    @IBOutlet weak var txFeeLabel: UILabel!
    @IBOutlet weak var autoTxFeeLabel: UILabel!
    @IBOutlet weak var manualTxFeeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setContent(poolDetails: MphPoolDetails) {
        coinNameLabel.text = poolDetails.coinname
        currencyLabel.text = poolDetails.currency
        
        coinTargetLabel.text = poolDetails.cointarget
        coinDiffTargetLabel.text = "\(poolDetails.coinDiffChangeTarget)"
        stratumPortLabel.text = poolDetails.stratumport
        payoutSystemLabel.text = poolDetails.payout_system
        rewardTypeLabel.text = poolDetails.reward_type
        rewardLabel.text = String(format:"%.4f", poolDetails.reward)
        
        apThresholdsLabel.text = String(format:"%.5f-%.0f", poolDetails.min_ap_threshold, poolDetails.max_ap_threshold)
        txFeeLabel.text = String(format:"%.5f", poolDetails.txfee)
        autoTxFeeLabel.text = String(format:"%.5f", poolDetails.txfee_auto)
        manualTxFeeLabel.text = String(format:"%.5f", poolDetails.txfee_manual)
    }
}
