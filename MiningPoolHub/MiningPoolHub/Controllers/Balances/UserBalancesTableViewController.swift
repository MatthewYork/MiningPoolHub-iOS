//
//  UserBalancesTableViewController.swift
//  MiningPoolHub
//
//  Created by Matthew York on 12/19/17.
//

import UIKit
import MiningPoolHub_Swift

class UserBalancesTableViewController: UITableViewController {

    //Variables
    let provider: MphWebProvider
    var userBalances: MphUserBalancesResponse?
    
    init(provider: MphWebProvider) {
        self.provider = provider
        super.init(style: .plain)
        self.title = "User Balances"
        tabBarItem.image = UIImage(named: "balance-30")
        tabBarItem.selectedImage = UIImage(named: "balance-30")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        setupTable()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userBalances?.balances.data.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BalanceTableViewCell", for: indexPath) as! BalanceTableViewCell
        if let balance = userBalances?.balances.data[indexPath.row] {cell.setSelected(balance: balance)}
        
        return cell
    }
    
    func sortBalances() {
        if let balances = userBalances?.balances.data {
            userBalances?.balances.data = balances.sorted(by: {b1, b2 in
                return b1.coin < b2.coin
            })
        }
    }
}

extension UserBalancesTableViewController {
    @objc func loadData() {
        let _ = provider.getUserAllBalances(completion: { (response: MphUserBalancesResponse) in
            self.userBalances = response
            self.sortBalances()
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
            
        }) { (error: Error) in
            //handle error
        }
    }
}
