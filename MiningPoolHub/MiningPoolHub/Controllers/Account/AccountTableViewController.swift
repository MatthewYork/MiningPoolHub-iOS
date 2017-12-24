//
//  AccountTableViewController.swift
//  MiningPoolHub
//
//  Created by Matthew York on 12/20/17.
//

import UIKit
import MiningPoolHub_Swift

class AccountTableViewController: UITableViewController {

    //Variables
    let provider: MphWebProvider
    let defaultsManager: UserDefaultsManager
    var userResponse: MphsResponse?
    var currency: MphsCurrency = MphsCurrency.usd
    var viewHasLoaded = false //Necessary for preview shimmer
    
    init(provider: MphWebProvider, defaultsManager: UserDefaultsManager) {
        self.provider = provider
        self.defaultsManager = defaultsManager
        
        super.init(style: .plain)
        self.title = "Account"
        tabBarItem.image = UIImage(named: "user-30")
        tabBarItem.selectedImage = UIImage(named: "user-30")
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
        initializeParameters()
        addBarButtons()
        loadData()
    }
    
    func registerCells() {
        tableView.register(UINib(nibName: "EstimatesTableViewCell", bundle: nil), forCellReuseIdentifier: "EstimatesTableViewCell")
        tableView.register(UINib(nibName: "WorkerCollectionTableViewCell", bundle: nil), forCellReuseIdentifier: "WorkerCollectionTableViewCell")
        tableView.register(UINib(nibName: "MultiLineChartTableViewCell", bundle: nil), forCellReuseIdentifier: "MultiLineChartTableViewCell")
    }
    
    func setupTable() {
        tableView.separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)
        //Refresh control
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(loadData), for: UIControlEvents.valueChanged)
    }
    
    func initializeParameters() {
        initializeCurrency()
    }
    
    func initializeCurrency() {
        guard let currencyString: String = defaultsManager.get(scope: "account", key: "currency") else { return }
        guard let currency = MphsCurrency(string: currencyString) else { return }
        self.currency = currency
    }
    
    func addBarButtons() {
        //Add right bar button
        let leftBarButton = UIBarButtonItem(title: currency.description(), style: .plain, target: self, action: #selector(didSelectCurrency))
        navigationItem.leftBarButtonItem = leftBarButton
        
        //Add right bar button
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "settings-22"), style: .plain, target: self, action: #selector(didSelectSettings))
        navigationItem.rightBarButtonItem = rightBarButton
    }
}

extension AccountTableViewController {
    @objc func didSelectSettings() {
        let settingsVC = AccountSettingsViewController(provider: provider, defaultsManager: UserDefaultsManager())
        navigationController?.pushViewController(settingsVC, animated: true)
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
                let _ = self.defaultsManager.set(scope: "account", key: "currency", value: newCurrency.description())
                
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

extension AccountTableViewController {
    @objc func loadData() {
        //Start shimmer
        userResponse = nil
        tableView.reloadData()
        
        //Get stats
        let _ = provider.getMiningPoolHubStats(currency: currency, completion: { (response: MphsResponse) in
            self.userResponse = response
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
            
        }) { (error: Error) in
            //handle error
        }
    }
}

extension AccountTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: return earningsHistoryCell(indexPath: indexPath)
        case 1: return estimatesCell(indexPath: indexPath)
        case 2: return workersCell(indexPath: indexPath)
        default:
            return tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        }
    }
    
    func earningsHistoryCell(indexPath: IndexPath) -> MultiLineChartTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MultiLineChartTableViewCell", for: indexPath) as! MultiLineChartTableViewCell
        
        guard let autoExchangeString: String = defaultsManager.get(scope: "accountSettings", key: "autoExchange") else {return cell}
        guard let autoExchange = MphDomain(string: autoExchangeString) else { return cell }
        
        
        if let walletData = userResponse?.wallet_data.first(where: { (data: MphsWalletData) -> Bool in
            return data.coin == autoExchange.description()
        }) {
            cell.containerView.isHidden = false
            cell.setContent(walletData: walletData, currency: currency)
        }
        else {
            cell.resetPulse()
            cell.animatePulseView()
            cell.containerView.isHidden = true
        }
        return cell
    }
    
    func estimatesCell(indexPath: IndexPath) -> EstimatesTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EstimatesTableViewCell", for: indexPath) as! EstimatesTableViewCell
        
        if let estimates = userResponse?.estimates_data {
            cell.containerView.isHidden = false
            cell.setContent(estimates: estimates, currency: currency)
        }
        else {
            cell.resetPulse()
            cell.animatePulseView()
            cell.containerView.isHidden = true
        }
        return cell
    }
    
    func workersCell(indexPath: IndexPath) -> WorkerCollectionTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkerCollectionTableViewCell", for: indexPath) as! WorkerCollectionTableViewCell
        
        cell.setContent(workers: userResponse?.worker_data)
        return cell
    }
}
