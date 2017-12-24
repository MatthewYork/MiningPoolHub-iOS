//
//  TransactionTableViewCell.swift
//  MiningPoolHub
//
//  Created by Matthew York on 12/23/17.
//

import UIKit
import MiningPoolHub_Swift

class TransactionTableViewCell: PulsableTableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var txTypeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var confirmedView: UIView!
    @IBOutlet weak var confirmedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setContent(transaction: MphUserTransaction) {
        idLabel.text = "\(transaction.id)"
        amountLabel.text = String(format: "%.9f", transaction.amount)
        txTypeLabel.text = transaction.type
        dateLabel.text = transaction.timestamp
        
        setConfirmationStatus(for: transaction)
        setConfirmationType(for: transaction)
    }
    
    func setConfirmationStatus(for transaction: MphUserTransaction) {
        guard let confirmations = transaction.confirmations else {
            if transaction.type == "Debit_AE" {
                confirmedLabel.text = "Confirmed"
                confirmedView.backgroundColor = UIColor(red: 230.0/255.0, green: 239.0/255.0, blue: 194.0/255.0, alpha: 1)
            }
            else {
                confirmedLabel.text = "Unconfirmed"
                confirmedView.backgroundColor = UIColor(red: 255.0/255.0, green: 206.0/255.0, blue: 156.0/255.0, alpha: 1)
            }
            
            return
        }
        
        confirmedLabel.text = confirmations > 0 ? "\(confirmations) Confirmations" : "Unconfirmed"
        confirmedView.backgroundColor = confirmations > 0 ? UIColor(red: 230.0/255.0, green: 239.0/255.0, blue: 194.0/255.0, alpha: 1) : UIColor(red: 255.0/255.0, green: 206.0/255.0, blue: 156.0/255.0, alpha: 1)
    }
    
    func setConfirmationType(for transaction: MphUserTransaction) {
        txTypeLabel.textColor = transaction.type.lowercased().contains("credit") ? UIColor(red: 82.0/255.0, green: 197.0/255.0, blue: 86.0/255.0, alpha: 1) : UIColor(red: 255.0/255.0, green: 87.0/255.0, blue: 20.0/255.0, alpha: 1)
    }
}
