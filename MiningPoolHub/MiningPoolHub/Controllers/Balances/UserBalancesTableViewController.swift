//
//  UserBalancesTableViewController.swift
//  MiningPoolHub
//
//  Created by Matthew York on 12/19/17.
//

import UIKit
import MiningPoolHub_Swift

class UserBalancesTableViewController: UITableViewController {
    //Internal enums
    enum SortingCriteria: Int {
        case coinName, confirmed, hashRate, twentyFourHours, total
        
        func description() -> String {
            switch self {
            case .coinName:
                return "Coin Name"
            case .confirmed:
                return "Confirmed"
            case .hashRate:
                return "Hash Rate"
            case .twentyFourHours:
                return "Last 24 Hours"
            case .total:
                return "Total"
            }
        }
        
        init?(string: String) {
            switch string {
            case "Coin Name":
                self = .coinName
            case "Confirmed" :
                self = .confirmed
            case "Hash Rate":
                self = .hashRate
            case "Last 24 Hours":
                self = .twentyFourHours
            case "Total":
                self = .total
            default: return nil
            }
        }
    }
    
    
    //Variables
    let provider: MphWebProvider
    var userBalances: MphsResponse?
    var sortingCriteria: SortingCriteria = SortingCriteria.confirmed
    var currency: MphsCurrency = MphsCurrency.usd
    
    init(provider: MphWebProvider) {
        self.provider = provider
        super.init(style: .plain)
        self.title = "Balances"
        tabBarItem.image = UIImage(named: "balance-30")
        tabBarItem.selectedImage = UIImage(named: "balance-30")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            extendedLayoutIncludesOpaqueBars = true
        }
        registerCells()
        setupTable()
        addBarButtons()
        loadData()
    }
    
    func registerCells() {
        tableView.register(UINib(nibName: "BalanceTableViewCell", bundle: nil), forCellReuseIdentifier: "BalanceTableViewCell")
    }
    
    func setupTable() {
        tableView.separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)
        
        //Refresh control
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(loadData), for: UIControlEvents.valueChanged)
    }
    
    func addBarButtons() {
        //Add right bar button
        let leftBarButton = UIBarButtonItem(title: currency.description(), style: .plain, target: self, action: #selector(didSelectCurrency))
        navigationItem.leftBarButtonItem = leftBarButton
        
        //Add right bar button
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "sort-22"), style: .plain, target: self, action: #selector(didSelectSort))
        navigationItem.rightBarButtonItem = rightBarButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userBalances?.wallet_data.count ?? 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BalanceTableViewCell", for: indexPath) as! BalanceTableViewCell
        if let balance = userBalances?.wallet_data[indexPath.row] {
            cell.containerView.isHidden = false
            cell.setSelected(balance: balance, currency: currency)
        }
        else {
            cell.resetPulse()
            cell.animatePulseView()
            cell.containerView.isHidden = true
        }
        
        return cell
    }
}

extension UserBalancesTableViewController {
    @objc func didSelectSort() {
        let alert = UIAlertController(title: "Sort Balances", message: "What criteria would you like to use to sort your balances?", preferredStyle: .actionSheet)
        alert.view.tintColor = UIColor.black
        
        //Add cancel
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        //Add enum values
        var rawValue = 0
        while let criteria = SortingCriteria(rawValue: rawValue) {
            alert.addAction(UIAlertAction(title: criteria.description(), style: UIAlertActionStyle.default, handler: { action in
                
                //Gather new criteria
                guard let actionTitle = action.title else { return }
                guard let newCriteria = SortingCriteria(string: actionTitle) else { return }
                
                //Sort on new criteria
                self.sortBalances(sortingCriteria: newCriteria)
                self.tableView.reloadData()
            }) )
            rawValue += 1
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    func sortBalances(sortingCriteria: SortingCriteria) {
        self.sortingCriteria = sortingCriteria
        
        if let balances = userBalances?.wallet_data {
            userBalances?.wallet_data = balances.sorted(by: {b1, b2 in
                switch self.sortingCriteria {
                case .coinName:
                    return b1.coin < b2.coin
                case .confirmed:
                    return b1.confirmed_value > b2.confirmed_value
                case .hashRate:
                    return b1.hashrate > b2.hashrate
                case .twentyFourHours:
                    return b1.payout_last_24 > b2.payout_last_24
                case .total:
                    return b1.total_value > b2.total_value
                }
            })
        }
    }
    
    @objc func didSelectCurrency() {
        let alert = UIAlertController(title: "Change Currency", message: "Which currency would you like to describe payouts?", preferredStyle: .actionSheet)
        alert.view.tintColor = UIColor.black
        
        //Add cancel
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        //Add enum values
        var rawValue = 0
        while let criteria = MphsCurrency(rawValue: rawValue) {
            alert.addAction(UIAlertAction(title: criteria.description(), style: UIAlertActionStyle.default, handler: { action in
                
                //Gather new criteria
                guard let actionTitle = action.title else { return }
                guard let newCurrency = MphsCurrency(string: actionTitle) else { return }
                
                //Sort on new criteria
                self.currency = newCurrency
                self.navigationItem.leftBarButtonItem?.title = newCurrency.description()
                self.loadData()
            }) )
            rawValue += 1
        }
        
        present(alert, animated: true, completion: nil)
    }
}

extension UserBalancesTableViewController {
    @objc func loadData() {
        userBalances = nil
        tableView.reloadData()
        
        let _ = provider.getMiningPoolHubStats(currency: currency, completion: { (response: MphsResponse) in
            self.userBalances = response
            self.sortBalances(sortingCriteria: self.sortingCriteria)
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
            
        }) { (error: Error) in
            //handle error
        }
    }
}
