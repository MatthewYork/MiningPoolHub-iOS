//
//  WorkerCollectionTableViewCell.swift
//  MiningPoolHub
//
//  Created by Matthew York on 12/20/17.
//

import UIKit
import MiningPoolHub_Swift

class WorkerCollectionTableViewCell: UITableViewCell {

    var workers: [MphsWorkerData]?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.collectionView.register(UINib(nibName: "WorkerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "WorkerCollectionViewCell")
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 200, height: 100)
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        self.collectionView.setCollectionViewLayout(layout, animated: false)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setContent(workers: [MphsWorkerData]?) {
        self.workers = workers
        collectionView.reloadData()
    }
}

extension WorkerCollectionTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return workers?.count ?? 3
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Create the cell and return the cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WorkerCollectionViewCell", for: indexPath) as! WorkerCollectionViewCell
        cell.shouldPulse = false
        
        if let worker = workers?[indexPath.row] {
            cell.containerView.isHidden = false
            cell.setContent(worker: worker)
        }
        else {
            cell.resetPulse()
            cell.animatePulseView()
            cell.containerView.isHidden = true
        }
        
        return cell
    }
}
