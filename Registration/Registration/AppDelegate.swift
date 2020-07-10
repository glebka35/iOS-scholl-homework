//
//  AppDelegate.swift
//  Registration
//
//  Created by Gleb Uvarkin on 09.07.2020.
//  Copyright © 2020 Gleb Uvarkin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let frame = UIScreen.main.bounds
        window = UIWindow(frame: frame)
        

        let navigationController = UINavigationController(rootViewController: CheckInController())
        
        if let userInfo = Defaults.getLoginAndPassword() {
            let mainController = MainViewController(login: userInfo.login, password: userInfo.password)
            navigationController.pushViewController(mainController, animated: false)
        }
        navigationController.navigationBar.isHidden = true
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}

