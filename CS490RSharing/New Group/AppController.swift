//
//  AppController.swift
//  CS490RSharing
//
//  Created by Jonathan G. Dzialo on 3/13/19.
//  Copyright © 2019 Group6. All rights reserved.
//

import UIKit
import Firebase

final class AppController {
    
    static let shared = AppController()
    
    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(userStateDidChange),
            name: Notification.Name.AuthStateDidChange,
            object: nil
        )
    }
    
    private var window: UIWindow!
    private var rootViewController: UIViewController? {
        didSet {
            if let vc = rootViewController {
                window.rootViewController = vc
            }
        }
    }
    
    // MARK: - Helpers
    
    func show(in window: UIWindow?) {
        guard let window = window else {
            fatalError("Cannot layout app with a nil window.")
        }
        
        FirebaseApp.configure()
        
        self.window = window
        window.tintColor = .primary
        window.backgroundColor = .white
        
        handleAppState()
        
        window.makeKeyAndVisible()
    }
    
    private func handleAppState() {
       rootViewController = LoginViewController()
    }
    
    // MARK: - Notifications
    
    @objc internal func userStateDidChange() {
        DispatchQueue.main.async {
            self.handleAppState()
        }
    }
    
}
