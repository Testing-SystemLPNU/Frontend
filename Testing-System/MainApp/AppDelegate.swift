//
//  AppDelegate.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/18/25.
//

import UIKit
import MijickCamera

class AppDelegate: NSObject, MApplicationDelegate {
    static var orientationLock = UIInterfaceOrientationMask.portrait
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask { AppDelegate.orientationLock }
}
