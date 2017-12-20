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
    @IBOutlet weak var autoExchangeLabel: UILabel!
    @IBOutlet weak var exchangeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setSelected(balance: MphBalance) {
        coinLabel.text = balance.coin
        
        //Credited
        var credited = String(format: "%.8f", balance.confirmed)
        if balance.unconfirmed != 0 { credited += " ("+String(format: "%.8f", balance.unconfirmed)+")" }
        creditedLabel.text = credited
        
        //Auto Exchange
        var autoExchange = String(format: "%.8f", balance.ae_confirmed)
        if balance.ae_unconfirmed != 0 { autoExchange += " ("+String(format: "%.8f", balance.ae_unconfirmed)+")" }
        autoExchangeLabel.text = autoExchange
        
        //Echange
        exchangeLabel.text = String(format: "%.8f", balance.exchange)
    }
}
