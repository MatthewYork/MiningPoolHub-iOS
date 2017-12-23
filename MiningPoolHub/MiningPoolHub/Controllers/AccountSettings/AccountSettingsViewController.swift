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
    
    //Outlets
    @IBOutlet weak var apiKeyTextField: UITextField!
    @IBOutlet weak var biometricIdLabel: UILabel!
    @IBOutlet weak var biometricSwitch: UISwitch!
    
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

    func addBarButtons() {
        //Add right bar button
        let rightBarButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(didSelectSave))
        navigationItem.rightBarButtonItem = rightBarButton
    }
}

extension AccountSettingsViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
        return saveApiKey() && saveBiometry()
    }
    
    func saveApiKey() -> Bool {
        guard let apiKey = apiKeyTextField.text else { return false }
        
        provider.set(apiKey: apiKey)
        return defaultsManager.set(scope: "accountSettings", key: "apiKey", value: apiKey)
    }
    
    func saveBiometry() -> Bool {
        return defaultsManager.set(scope: "accountSettings", key: "accountProtection", value: biometricSwitch.isOn)
    }
}
