//
//  PoolsTableViewController.swift
//  MiningPoolHub
//
//  Created by Matthew York on 12/23/17.
//

import UIKit
import MiningPoolHub_Swift

class PoolsTableViewController: UITableViewController {
    
    //Variables
    let provider: MphWebProvider
    let defaultsManager: UserDefaultsManager
    var poolInfoResponse: MphPoolInfoResponse?
    var poolStatusResponse: MphPoolStatusResponse?
    var transactionsResponse: MphUserTransactionsResponse?
    var domain: MphDomain = MphDomain.bitcoin
    
    init(provider: MphWebProvider, defaultsManager: UserDefaultsManager) {
        self.provider = provider
        self.defaultsManager = defaultsManager
        
        super.init(style: .plain)
        self.title = "Pools"
        tabBarItem.image = UIImage(named: "pool-30")
        tabBarItem.selectedImage = UIImage(named: "pool-30")
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
        setupTable()
        registerCells()
        initializeParameters()
        addBarButtons()
        provider.set(domain: domain)
        loadData()
    }
    
    func registerCells() {
        tableView.register(UINib(nibName: "TransactionTableViewCell", bundle: nil), forCellReuseIdentifier: "TransactionTableViewCell")
        tableView.register(UINib(nibName: "PoolInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "PoolInfoTableViewCell")
        tableView.register(UINib(nibName: "PoolStatusTableViewCell", bundle: nil), forCellReuseIdentifier: "PoolStatusTableViewCell")
    }
    
    func setupTable() {
        tableView.separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)
        //Refresh control
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(loadData), for: UIControlEvents.valueChanged)
    }
    
    func initializeParameters() {
        initializeDomain()
    }
    
    func initializeDomain() {
        guard let domainString: String = defaultsManager.get(scope: "pools", key: "domain") else { return }
        guard let domain = MphDomain(string: domainString) else { return }
        self.domain = domain
    }
    
    func addBarButtons() {
        //Add right bar button
        let leftBarButton = UIBarButtonItem(title: domain.description(), style: .plain, target: self, action: #selector(didSelectDomain))
        navigationItem.leftBarButtonItem = leftBarButton
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0,1: return 1
        case 2: return transactionsResponse?.transactions.data?.transactions.count ?? 5
        default: return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 2:
            let header = LeftImageSectionHeader.fromNib()
            header.setContent(image: UIImage(named: "exchange-pdf"), title: "Transactions")
            return header
        default: return UIView()
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 2: return UITableViewAutomaticDimension
        default: return 0.001
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: return poolInfoCell(indexPath: indexPath)
        case 1: return poolStatusCell(indexPath: indexPath)
        case 2: return transactionCell(indexPath: indexPath)
        default:
            return tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        }
    }
    
    func poolInfoCell(indexPath: IndexPath) -> PoolInfoTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PoolInfoTableViewCell", for: indexPath) as! PoolInfoTableViewCell
        
        if let poolInfo = poolInfoResponse?.info.data {
            cell.containerView.isHidden = false
            cell.setContent(poolDetails: poolInfo)
        }
        else {
            cell.resetPulse()
            cell.animatePulseView()
            cell.containerView.isHidden = true
        }
        return cell
    }
    
    func poolStatusCell(indexPath: IndexPath) -> PoolStatusTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PoolStatusTableViewCell", for: indexPath) as! PoolStatusTableViewCell
        
        if let poolStatus = poolStatusResponse?.status.data {
            cell.containerView.isHidden = false
            cell.setContent(poolDetails: poolStatus)
        }
        else {
            cell.resetPulse()
            cell.animatePulseView()
            cell.containerView.isHidden = true
        }
        return cell
    }
    
    func transactionCell(indexPath: IndexPath) -> TransactionTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath) as! TransactionTableViewCell
        
        if let transactions = transactionsResponse?.transactions.data?.transactions {
            cell.containerView.isHidden = false
            cell.setContent(transaction: transactions[indexPath.row])
        }
        else {
            cell.resetPulse()
            cell.animatePulseView()
            cell.containerView.isHidden = true
        }
        return cell
    }
 
}

extension PoolsTableViewController {
    @objc func didSelectDomain() {
        let alert = UIAlertController(title: "Change Domain", message: "Which domain would you like to see pool data for?", preferredStyle: .actionSheet)
        alert.view.tintColor = UIColor.black
        
        //Add cancel
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        //Add enum values
        var rawValue = 0
        while let domain = MphDomain(rawValue: rawValue) {
            alert.addAction(UIAlertAction(title: domain.description(), style: UIAlertActionStyle.default, handler: { action in
                
                //Gather new criteria
                guard let actionTitle = action.title else { return }
                guard let newDomain = MphDomain(string: actionTitle) else { return }
                let _ = self.defaultsManager.set(scope: "pools", key: "domain", value: newDomain.description())
                
                //Reload on new criteria
                self.domain = newDomain
                self.provider.set(domain: newDomain)
                self.navigationItem.leftBarButtonItem?.title = newDomain.description()
                self.loadData()
            }) )
            rawValue += 1
        }
        
        present(alert, animated: true, completion: nil)
    }
}

extension PoolsTableViewController {
    @objc func loadData() {
        transactionsResponse = nil
        poolInfoResponse = nil
        tableView.reloadData()
        
        //Get transactions
        let _ = provider.getUserTransactions(id: nil, completion: { (response: MphUserTransactionsResponse) in
            self.transactionsResponse = response
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
            
        }) { (error: Error) in
            //handle error
        }
        
        //Pool info
        let _ = provider.getPoolInfo(completion: { (response: MphPoolInfoResponse) in
            self.poolInfoResponse = response
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
        }) { (error: Error) in
            //handle error
        }
        
        //Pool status
        let _ = provider.getPoolStatus(completion: { (response: MphPoolStatusResponse) in
            self.poolStatusResponse = response
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
        }) { (error: Error) in
            
        }
    }
}
