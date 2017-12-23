//
//  UserDefaultsManager.swift
//  MiningPoolHub
//
//  Created by Matthew York on 12/23/17.
//

import Foundation

public class UserDefaultsManager {
    public init() { }
}

extension UserDefaultsManager {
    func defaultsKey(_ scope: String, _ key: String, _ module: String? = nil) -> String {
        return "module:\(module ?? "app") scope:\(scope) key:\(key)"
    }
}

//MARK: - Public Methods
extension UserDefaultsManager {
    public func get<T>(scope: String, key: String, module: String? = nil) -> T? {
        return UserDefaults.standard.value(forKey: defaultsKey(scope, key)) as? T
    }
    
    public func set<T:Any>(scope: String, key: String, value: T?, module: String? = nil) -> Bool {
        UserDefaults.standard.setValue(value, forKey: defaultsKey(scope, key, module))
        return UserDefaults.standard.synchronize()
    }
    
    public func exists(scope: String, key: String, module: String? = nil) -> Bool {
        return UserDefaults.standard.value(forKey: defaultsKey(scope, key, module)) != nil
    }
}

