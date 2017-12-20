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
    var userResponse: MphsResponse?
    var currency: MphsCurrency = MphsCurrency.usd
    
    init(provider: MphWebProvider) {
        self.provider = provider
        
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
        loadData()
    }
    
    func registerCells() {
        tableView.register(UINib(nibName: "EstimatesTableViewCell", bundle: nil), forCellReuseIdentifier: "EstimatesTableViewCell")
    }
    
    func setupTable() {
        tableView.separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)
        
        //Refresh control
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(loadData), for: UIControlEvents.valueChanged)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userResponse != nil ? 1 : 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EstimatesTableViewCell", for: indexPath) as! EstimatesTableViewCell

        if let estimates = userResponse?.estimates_data {
            cell.setContent(estimates: estimates, currency: currency)
        }

        return cell
    }
}

extension AccountTableViewController {
    @objc func loadData() {
        let _ = provider.getMiningPoolHubStats(currency: currency, completion: { (response: MphsResponse) in
            self.userResponse = response
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
            
        }) { (error: Error) in
            //handle error
        }
    }
}
