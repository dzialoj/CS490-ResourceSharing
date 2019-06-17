//
//  AppSettings.swift
//  CS490RSharing
//
//  Created by Jonathan G. Dzialo on 3/13/19.
//  Copyright © 2019 Group6. All rights reserved.
//

import Foundation

final class AppSettings {
    
    private enum SettingKey: String {
        case displayName
    }
    
    static var displayName: String! {
        get {
            return UserDefaults.standard.string(forKey: SettingKey.displayName.rawValue)
        }
        set {
            let defaults = UserDefaults.standard
            let key = SettingKey.displayName.rawValue
            
            if let name = newValue {
                defaults.set(name, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
    
}

