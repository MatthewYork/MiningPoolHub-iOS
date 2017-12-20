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
        
    }
    
    func setupTable() {
        tableView.separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)
        
        //Refresh control
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
        // #warning Incomplete implementation, return the number of rows
        return userBalances?.balances.data.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = userBalances?.balances.data[indexPath.row].coin ?? "N/A"
        
        return cell
    }
}

extension UserBalancesTableViewController {
    @objc func loadData() {
        let _ = provider.getUserAllBalances(completion: { (response: MphUserBalancesResponse) in
            self.userBalances = response
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
            
        }) { (error: Error) in
            //handle error
        }
    }
}
