//
//  EstimatesTableViewCell.swift
//  MiningPoolHub
//
//  Created by Matthew York on 12/20/17.
//

import UIKit
import MiningPoolHub_Swift

class EstimatesTableViewCell: UITableViewCell {

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

        // Configure the view for the selected state
    }
    
    func setContent(estimates: MphsEstimatesData, currency: MphsCurrency) {
        //Detect crypto format
        var format = ""
        switch currency {
        case .btc, .ltc, .eth, .xmr : format = "%.7f"
        default: format = "%.2f"
        }
        
        last24HoursLabel.text = String(format: format, estimates.last_24_hours)+" "+currency.description()
        hourlyLabel.text = String(format: format, estimates.hourly)+" "+currency.description()
        dailyLabel.text = String(format: format, estimates.daily)+" "+currency.description()
        weeklyLabel.text = String(format: format, estimates.weekly)+" "+currency.description()
        monthlyLabel.text = String(format: format, estimates.monthly)+" "+currency.description()
        yearlyLabel.text = String(format: format, estimates.yearly)+" "+currency.description()
    }
}
