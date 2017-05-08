//
//  AppDelegate.swift
//  TokBoxVideoBot
//
//  Created by Deblina Das on 18/04/17.
//  Copyright © 2017 Deblina Das. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if window == nil { window = UIWindow(frame: UIScreen.main.bounds) }
        window?.rootViewController = ContactListTableViewController.controller()
        return true
    }
}

