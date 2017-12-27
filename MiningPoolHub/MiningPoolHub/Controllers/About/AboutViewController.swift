//
//  AboutViewController.swift
//  MiningPoolHub
//
//  Created by Matthew York on 12/27/17.
//

import UIKit

class AboutViewController: UIViewController {

    init() {
        super.init(nibName: "AboutViewController", bundle: nil)
        self.title = "About"
        tabBarItem.image = UIImage(named: "about-30")
        tabBarItem.selectedImage = UIImage(named: "about-30")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: - Actions
    @IBAction func didSelectDonateBtc() {
        copy(to: "17ZEBFw5peuoUwYaEJeGkpoJwP1htViLUY")
    }
    @IBAction func didSelectDonateLtc() {
        copy(to: " LSzwWG35KqfuR5SEiKeJrGq4L3Z36vzjdR")
    }
    @IBAction func didSelectDonateEth() {
        copy(to: " 0x339c744e0c08862c0943431079e5a406413bf4ed")
    }
}

extension AboutViewController {
    func copy(to clipboard: String) {
        UIPasteboard.general.string = clipboard
        alertOfSuccessfulCopy()
    }
    
    func alertOfSuccessfulCopy() {
        let alert = UIAlertController(title: "Copy Successful", message: "The address was succesfully copied to your clipboard. Thank you for donating!", preferredStyle: .alert)
        alert.view.tintColor = UIColor.black
        
        //Add cancel
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}
