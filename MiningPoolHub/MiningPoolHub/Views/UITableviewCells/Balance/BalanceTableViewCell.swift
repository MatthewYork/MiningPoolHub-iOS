//
//  BalanceTableViewCell.swift
//  MiningPoolHub
//
//  Created by Matthew York on 12/20/17.
//

import UIKit
import MiningPoolHub_Swift

class BalanceTableViewCell: UITableViewCell {

    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var creditedLabel: UILabel!
    @IBOutlet weak var exchangeLabel: UILabel!
    @IBOutlet weak var hashRateLabel: UILabel!
    @IBOutlet weak var confirmedLabel: UILabel!
    @IBOutlet weak var feePercentageLabel: UILabel!
    @IBOutlet weak var last24hrsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setSelected(balance: MphsWalletData, currency: MphsCurrency) {
        coinLabel.text = balance.coin
        
        //Credited
        var credited = String(format: "%.8f", balance.confirmed)
        if balance.unconfirmed != 0 { credited += " ("+String(format: "%.8f", balance.unconfirmed)+")" }
        creditedLabel.text = credited
        
        //Echange, Hashrate
        exchangeLabel.text = String(format: "%.8f", balance.on_exchange)
        hashRateLabel.text = String(format: "%.4f", balance.hashrate)
        feePercentageLabel.text = String(format: "%.0f", balance.payout_fee_percent)+" %"
        
        
        //Computed values
        setCurrencyLabels(balance: balance, currency: currency)
    }
    
    func setCurrencyLabels(balance: MphsWalletData, currency: MphsCurrency) {
        //Detect crypto format
        var format = ""
        switch currency {
        case .btc, .ltc, .eth, .xmr : format = "%.7f"
        default: format = "%.2f"
        }
        
        //Create number strings
        let confirmed = String(format: format, balance.confirmed_value)
        let last24Hours = String(format: format, balance.payout_last_24_value)
        
        var denotation = ""; var before = true;
        switch currency {
        case .usd: denotation = "$";
        case .eur: denotation = "€"
        case .gbp: denotation = "£"
        case .btc: denotation = "BTC"; before = false
        case .ltc: denotation = "LTC"; before = false
        case .eth: denotation = "ETH"; before = false
        case .xmr: denotation = "XMR"; before = false
        }
        
        //Set currency labels
        confirmedLabel.text = before ? denotation+" "+confirmed : confirmed+" "+denotation
        last24hrsLabel.text = before ? denotation+" "+last24Hours : last24Hours+" "+denotation
    }
}
