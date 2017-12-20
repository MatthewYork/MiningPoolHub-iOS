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
    @IBOutlet weak var totalCurrencyLabel: UILabel!
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
        
        //Echange
        exchangeLabel.text = String(format: "%.8f", balance.on_exchange)
        
        //Echange
        hashRateLabel.text = String(format: "%.8f", balance.hashrate)
        setCurrency(balance: balance, currency: currency)
    }
    
    func setCurrency(balance: MphsWalletData, currency: MphsCurrency) {
        let totalCurrency = String(format: "%.2f", balance.total_value)
        
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
        
        totalCurrencyLabel.text = before ? denotation+" "+totalCurrency : totalCurrency+" "+denotation
    }
}
