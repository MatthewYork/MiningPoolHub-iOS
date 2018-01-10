//
//  EstimatesTableViewCell.swift
//  MiningPoolHub
//
//  Created by Matthew York on 12/20/17.
//

import UIKit
import MiningPoolHub_Swift

class EstimatesTableViewCell: PulsableTableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var last24HoursLabel: UILabel!
    @IBOutlet weak var hourlyLabel: UILabel!
    @IBOutlet weak var dailyLabel: UILabel!
    @IBOutlet weak var weeklyLabel: UILabel!
    @IBOutlet weak var monthlyLabel: UILabel!
    @IBOutlet weak var yearlyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setContent(estimates: MphsEstimatesData, currency: MphsCurrency, autoExchange: MphDomain) {
        let divisor = autoExchange == .none ? 1.0 : 2.0 
        last24HoursLabel.text = CurrencyFormattedNumber(for: estimates.last_24_hours/divisor, in: currency).formattedNumber
        hourlyLabel.text = CurrencyFormattedNumber(for: estimates.hourly/divisor, in: currency).formattedNumber
        dailyLabel.text = CurrencyFormattedNumber(for: estimates.daily/divisor, in: currency).formattedNumber
        weeklyLabel.text = CurrencyFormattedNumber(for: estimates.weekly/divisor, in: currency).formattedNumber
        monthlyLabel.text = CurrencyFormattedNumber(for: estimates.monthly/divisor, in: currency).formattedNumber
        yearlyLabel.text = CurrencyFormattedNumber(for: estimates.yearly/divisor, in: currency).formattedNumber
    }
}
