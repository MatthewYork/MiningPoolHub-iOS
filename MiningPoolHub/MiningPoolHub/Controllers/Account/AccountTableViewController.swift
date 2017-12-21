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
    var viewHasLoaded = false //Necessary for preview shimmer
    
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
        addBarButtons()
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

extension AccountTableViewController {
    @objc func loadData() {
        //Start shimmer
        userResponse = nil
        tableView.reloadData()
        
        //Get data
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
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EstimatesTableViewCell", for: indexPath) as! EstimatesTableViewCell
        
        if let estimates = userResponse?.estimates_data {
            cell.containerView.isHidden = false
            cell.shouldPulse = false
            cell.setContent(estimates: estimates, currency: currency)
        }
        else {
            cell.shouldPulse = true
            cell.animatePulseView()
            cell.containerView.isHidden = true
        }
        return cell
    }
}
