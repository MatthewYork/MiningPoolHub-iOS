//
//  ProfitStatisticsTableViewCell.swift
//  MiningPoolHub
//
//  Created by Matthew York on 12/19/17.
//

import UIKit
import MiningPoolHub_Swift

class ProfitStatisticsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    //Columns
    @IBOutlet weak var portNumberLabel: UILabel!
    @IBOutlet weak var profitLabel: UILabel!
    @IBOutlet weak var hashRateImageView: UIImageView!
    @IBOutlet weak var hashRateLabel: UILabel!
    @IBOutlet weak var lastBlockHeaderLabel: UILabel!
    @IBOutlet weak var lastBlockLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    func setSelected<T>(content: T, normalization: Normalization) {
        if let stat = content as? MphAutoSwitchingProfitStatistics {set(stat: stat, normalization: normalization)}
        else if let stat = content as? MphCoinProfitStatistics {set(stat: stat, normalization: normalization)}
    }
    
    private func set(stat: MphAutoSwitchingProfitStatistics, normalization: Normalization) {
        titleLabel.text = stat.algo
        subtitleLabel.text = stat.current_mining_coin
        portNumberLabel.text = "\(stat.algo_switch_port)"
        
        switch normalization {
            case .amd: profitLabel.text = String(format: "%.5f", stat.normalized_profit_amd)
            case .nvidia: profitLabel.text = String(format: "%.5f", stat.normalized_profit_nvidia)
            case .noNorm: profitLabel.text = String(format: "%.5f", stat.profit)
        }
        
        //Hash rate
        hashRateLabel.isHidden = true
        hashRateImageView.isHidden = true
        
        //last block
        lastBlockHeaderLabel.isHidden = true
        lastBlockLabel.isHidden = true
    }
    
    private func set(stat: MphCoinProfitStatistics, normalization: Normalization) {
        titleLabel.text = stat.coin_name
        subtitleLabel.text = stat.algo
        portNumberLabel.text = "\(stat.port)"
        
        switch normalization {
            case .amd: profitLabel.text = String(format: "%.5f", stat.normalized_profit_amd)
            case .nvidia: profitLabel.text = String(format: "%.5f", stat.normalized_profit_nvidia)
            case .noNorm: profitLabel.text = String(format: "%.5f", stat.profit)
        }
        
        //Hash rate
        hashRateLabel.isHidden = false
        hashRateImageView.isHidden = false
        hashRateLabel.text = stat.pool_hash
        
        //last block
        lastBlockHeaderLabel.isHidden = false
        lastBlockLabel.isHidden = false
        lastBlockLabel.text = stat.time_since_last_block_in_words
    }
}
