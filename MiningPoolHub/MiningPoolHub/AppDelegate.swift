//
//  AppDelegate.swift
//  MiningPoolHub
//
//  Created by Matthew York on 12/18/17.
//

import UIKit
import MiningPoolHub_Swift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let tabBarController = UITabBarController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //Setup UI
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        //Create provider and defaults manager
        let provider = MphWebProvider(configuration: MphDefaultConfiguration(apiKey: ""))
        let defaultsManager = UserDefaultsManager()
        
        //Setup UI
        setupTabBar(provider: provider)
        showAccountSettings(provider: provider, defaultsManager: defaultsManager)
        authenticateIfNecessary(defaultsManager: defaultsManager)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

extension AppDelegate {
    func setupTabBar(provider: MphWebProvider) {
        
        
        //Set tabs
        tabBarController.viewControllers = [
            MphNavigationController(rootViewController: ProfitStatisticsViewController(provider: provider)),
            MphNavigationController(rootViewController: UserBalancesTableViewController(provider: provider)),
            MphNavigationController(rootViewController: AccountTableViewController(provider: provider))
        ]
        
        //Set style
        tabBarController.tabBar.tintColor = UIColor.black
        
        //Remove tab names
        for tabBarItem in tabBarController.tabBar.items! {
            tabBarItem.title = "";
            tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
        }
    }
    
    func showAccountSettings(provider: MphWebProvider, defaultsManager: UserDefaultsManager) {
        guard let _ : Bool = defaultsManager.get(scope: "accountSettings", key: "initialLoad") else {
            //Remember load
            let _ = defaultsManager.set(scope: "accountSettings", key: "initialLoad", value: true)
            
            //Show settings
            let settingsVC = AccountSettingsViewController(provider: provider, defaultsManager: UserDefaultsManager())
            let settingsNC = MphNavigationController(rootViewController: settingsVC)
            self.tabBarController.present(settingsNC, animated: true, completion: nil)
            return
        }
    }
    
    func authenticateIfNecessary(defaultsManager: UserDefaultsManager) {
        if !BioMetricAuthenticator.canAuthenticate() { return }
        if !(defaultsManager.get(scope: "accountSettings", key: "accountProtection") ?? false) { return }
        
        //Present authentication
        let authenticateVC = AuthenticateViewController()
        tabBarController.present(authenticateVC, animated: false, completion: nil)
    }
}
