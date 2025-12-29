//
//  AppDelegate.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 11.12.2025.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func presentRootVC() {
        let window: UIWindow?
        if #available(iOS 13.0, *) {
            guard let windowScene = self.window?.windowScene as? UIWindowScene else { return }
            window = UIWindow(windowScene: windowScene)

        } else {
            window = UIApplication.shared.windows.first(where: {
                $0.isKeyWindow
            }) ?? self.window
        }

        guard let window else {
            return
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let initialVC = storyboard.instantiateInitialViewController()!

        window.rootViewController = initialVC
        window.makeKeyAndVisible()

        self.window = window
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }


}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let window = UIWindow(windowScene: scene as! UIWindowScene)

        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let initialVC = GameViewController.initiate(.test)
        //storyboard.instantiateInitialViewController()!
        //GameViewController.initiate(.test)

        window.rootViewController = initialVC
        window.makeKeyAndVisible()

        self.window = window
    }
}
