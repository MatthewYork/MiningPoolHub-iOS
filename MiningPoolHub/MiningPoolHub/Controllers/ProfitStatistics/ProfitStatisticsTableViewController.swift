//
//  ProfitStatisticsTableViewController.swift
//  MiningPoolHub
//
//  Created by Matthew York on 12/19/17.
//

import Foundation
import MiningPoolHub_Swift

class ProfitStatisticsTableViewController: UIViewController {
    
    //Variables
    let provider: MphWebProvider
    var autoSwitchStatistics: MphListResponse<MphAutoSwitchingProfitStatistics>?
    var miningStatistics: MphListResponse<MphCoinProfitStatistics>?
    var contentType: ContentType = .auto
    var normalization: Normalization = .amd
    var refreshControl = UIRefreshControl()
    
    //Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contentSegmentedControl: UISegmentedControl!
    @IBOutlet weak var normalizationSegmentedControl: UISegmentedControl!
    
    
    init(provider: MphWebProvider) {
        self.provider = provider
        super.init(nibName: "ProfitStatisticsTableViewController", bundle: nil)
        self.title = "Profit Statistics"
        tabBarItem.image = UIImage(named: "performance-30")
        tabBarItem.selectedImage = UIImage(named: "performance-30")
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
        tableView.register(UINib(nibName: "ProfitStatisticsTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfitStatisticsTableViewCell")
    }
    
    func setupTable() {
        tableView.separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)
        
        //Refresh control
        refreshControl.addTarget(self, action: #selector(loadData), for: UIControlEvents.valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    // MARK: - Actions
    @IBAction func controlValueDidChange(_ sender: UISegmentedControl) {
        if sender == contentSegmentedControl { contentType = ContentType(rawValue:sender.selectedSegmentIndex)! }
        else if sender == normalizationSegmentedControl { normalization = Normalization(rawValue:sender.selectedSegmentIndex)! }
        sortEntries()
        tableView.reloadData()
    }
    
    func sortEntries() {
        //Sort auto
        if let response = autoSwitchStatistics?.response {
            autoSwitchStatistics?.response = response.sorted(by: {s1, s2 in
                switch normalization {
                    case .amd: return s1.normalized_profit_amd > s2.normalized_profit_amd
                    case .nvidia: return s1.normalized_profit_nvidia > s2.normalized_profit_nvidia
                    case .noNorm: return s1.profit > s2.profit
                }
            })
        }
        
        //Sort coin mining
        if let response = miningStatistics?.response {
            miningStatistics?.response = response.sorted(by: {s1, s2 in
                switch normalization {
                    case .amd: return s1.normalized_profit_amd > s2.normalized_profit_amd
                    case .nvidia: return s1.normalized_profit_nvidia > s2.normalized_profit_nvidia
                    case .noNorm: return s1.profit > s2.profit
                }
            })
        }
    }
}

// MARK: - Table view data source
extension ProfitStatisticsTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return contentType == .auto
            ? (autoSwitchStatistics?.response.count ?? 0)
            : (miningStatistics?.response.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfitStatisticsTableViewCell", for: indexPath) as! ProfitStatisticsTableViewCell
        
        switch contentType {
        case .auto:
            cell.setSelected(content: autoSwitchStatistics?.response[indexPath.row], normalization: normalization)
        case .coin:
            cell.setSelected(content: miningStatistics?.response[indexPath.row], normalization: normalization)
        }
        
        return cell
    }
}

extension ProfitStatisticsTableViewController {
    @objc func loadData() {
        //Get auto switching
        let _ = provider.getAutoSwitchingAndProfitsStatistics(completion: { (response: MphListResponse<MphAutoSwitchingProfitStatistics>) in
            self.autoSwitchStatistics = response
            self.sortEntries()
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        }) { (error: Error) in
            //handle error
        }
        
        //Get coin
        let _ = provider.getMiningAndProfitsStatistics(completion: { (response: MphListResponse<MphCoinProfitStatistics>) in
            self.miningStatistics = response
            self.sortEntries()
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        }) { (error: Error) in
            //handle error
        }
    }
}
