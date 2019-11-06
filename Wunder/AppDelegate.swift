//
//  AppDelegate.swift
//  Wunder
//
//  Created by Dima Korolev on 05/11/2019.
//  Copyright © 2019 Dima Korolev. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private var mainStory: MainStory?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let context = AppContext()
        
        updateAppearance()
        showRootUI(with: context)
        
        return true
    }
    
    private func showRootUI(with context: AppContext) {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        let rootStory = MainStory(.init(context: context))
        self.mainStory = rootStory
        let rootStoryView = MainStoryViewController()
        _ = rootStoryView.bind(rootStory)
        
        window.rootViewController = rootStoryView
        
        window.makeKeyAndVisible()
    }
    
    private func updateAppearance() {
        UIView.appearance().tintColor = .primary
    }
}

