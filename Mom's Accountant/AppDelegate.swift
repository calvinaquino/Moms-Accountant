//
//  AppDelegate.swift
//  Mom's Accountant
//
//  Created by Calvin Gonçalves de Aquino on 7/8/17.
//  Copyright © 2017 Calvin. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        CoreDataController.saveContext()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataController.saveContext()
    }
}

