//
//  AuthenticateViewController.swift
//  MiningPoolHub
//
//  Created by Matthew York on 12/23/17.
//

import UIKit

class AuthenticateViewController: UIViewController {

    @IBOutlet weak var authenticationImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    
    init() {
        super.init(nibName: "AuthenticateViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initializeAuthentication()
        authenticate()
    }

    func initializeAuthentication() {
        if BioMetricAuthenticator.shared.touchIDAvailable() {
            authenticationImageView.image = UIImage(named: "touchid-pdf")
        }
        else if BioMetricAuthenticator.shared.faceIDAvailable() {
            authenticationImageView.image = UIImage(named: "faceid-pdf")
        }
    }
    
    //Actions
    @IBAction func didTapTryAgain() {
        authenticate()
    }
}

extension AuthenticateViewController {
    func authenticate() {
        statusLabel.text = "Authenticating your account..."
        
        //Authenticate
        BioMetricAuthenticator.authenticateWithBioMetrics(reason: "", success: {
            self.dismiss(animated: true, completion: nil)
            
        }) { (error) in
            self.authenticationFailed()
        }
    }
    
    func authenticationFailed() {
        statusLabel.text = "Authentication Failed"
    }
}
