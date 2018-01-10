//
//  AccountSettingsViewController.swift
//  MiningPoolHub
//
//  Created by Matthew York on 12/23/17.
//

import UIKit
import MiningPoolHub_Swift

class AccountSettingsViewController: UIViewController {
    
    //Variables
    let provider: MphWebProvider
    let defaultsManager: UserDefaultsManager
    var autoExchange: MphDomain = MphDomain.bitcoin
    
    //Outlets
    @IBOutlet weak var apiKeyTextField: UITextField!
    @IBOutlet weak var biometricIdLabel: UILabel!
    @IBOutlet weak var biometricSwitch: UISwitch!
    @IBOutlet weak var autoExchangeButton: UIButton!
    
    init(provider: MphWebProvider, defaultsManager: UserDefaultsManager) {
        self.provider = provider
        self.defaultsManager = defaultsManager
        
        super.init(nibName: "AccountSettingsViewController", bundle: nil)
        self.title = "Account Settings"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeStoredValues()
        addBarButtons()
    }
    
    func initializeStoredValues() {
        initializeApiKey()
        initializeBiometrics()
        initializeAutoExchange()
    }
    
    func initializeApiKey() {
        apiKeyTextField.text = defaultsManager.get(scope: "accountSettings", key: "apiKey")
    }
    
    func initializeBiometrics() {
        //Biometric Label
        if BioMetricAuthenticator.shared.faceIDAvailable() {
            biometricIdLabel.text = "Face ID"
        }
        else if BioMetricAuthenticator.shared.touchIDAvailable() {
            biometricIdLabel.text = "Touch ID"
        }
        else {
            biometricIdLabel.text = "Unavailable"
            biometricSwitch.isEnabled = false
        }
        
        //Biometric status
        let biometricsOn = defaultsManager.get(scope: "accountSettings", key: "accountProtection") ?? false
        biometricSwitch.setOn(biometricsOn, animated: false)
    }
    
    func initializeAutoExchange() {
        let autoExchangeString = defaultsManager.get(scope: "accountSettings", key: "autoExchange") ?? "bitcoin"
        guard let autoExchange = MphDomain(string: autoExchangeString) else { return }
        
        self.autoExchange = autoExchange
        autoExchangeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        autoExchangeButton.setTitle(autoExchange.description() == "" ? "none" : autoExchange.description(), for: UIControlState.normal)
    }

    func addBarButtons() {
        //Add right bar button
        let rightBarButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(didSelectSave))
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    //MARK: - Actions
    @IBAction func didSelectAutoExchange() {
        selectAutoExchange()
    }
}

extension AccountSettingsViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension AccountSettingsViewController {
    func selectAutoExchange() {
        let alert = UIAlertController(title: "Change Auto-Exchange Currency", message: "Which currency do you use for auto-exchange?", preferredStyle: .actionSheet)
        alert.view.tintColor = UIColor.black
        
        //Add cancel
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        //Add enum values
        var rawValue = 0
        while let domain = MphDomain(rawValue: rawValue) {
            alert.addAction(UIAlertAction(title: domain != .none ? domain.description() : "none", style: UIAlertActionStyle.default, handler: { action in
                
                //Gather new criteria
                guard let actionTitle = action.title else { return }
                guard let newDomain = MphDomain(string: actionTitle == "none" ? "" : actionTitle) else { return }
                
                //Reload on new criteria
                self.autoExchange = newDomain
                self.autoExchangeButton.setTitle(actionTitle != "" ? actionTitle : "none", for: UIControlState.normal)
            }) )
            rawValue += 1
        }
        
        present(alert, animated: true, completion: nil)
    }
}

extension AccountSettingsViewController {
    @objc func didSelectSave() {
        if saveSettings() {
            guard let _ = navigationController?.popViewController(animated: true) else {
                self.dismiss(animated: true, completion: nil)
                return
            }
        }
        else {
            //Alert of save failure
        }
    }
    
    func saveSettings() -> Bool {
        return saveApiKey() && saveBiometry() && saveAutoExchange()
    }
    
    func saveApiKey() -> Bool {
        guard let apiKey = apiKeyTextField.text else { return false }
        
        provider.set(apiKey: apiKey)
        return defaultsManager.set(scope: "accountSettings", key: "apiKey", value: apiKey)
    }
    
    func saveBiometry() -> Bool {
        return defaultsManager.set(scope: "accountSettings", key: "accountProtection", value: biometricSwitch.isOn)
    }
    
    func saveAutoExchange() -> Bool {
        return defaultsManager.set(scope: "accountSettings", key: "autoExchange", value: autoExchange.description())
    }
}
