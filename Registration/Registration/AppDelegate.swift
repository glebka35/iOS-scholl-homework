//
//  AppDelegate.swift
//  Registration
//
//  Created by Gleb Uvarkin on 09.07.2020.
//  Copyright © 2020 Gleb Uvarkin. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let frame = UIScreen.main.bounds
        window = UIWindow(frame: frame)
        
        let navigationController = UINavigationController(rootViewController: CheckInController())
        
        let coreDataManager = CoreDataManager.shared
        if let _ = coreDataManager.fetchUserInfo() {
            let mainController = MainViewController()
            navigationController.pushViewController(mainController, animated: false)
        }

        navigationController.navigationBar.isHidden = true
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CheckInCoreData")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                
            }
        }
        return container
    } ()
}

