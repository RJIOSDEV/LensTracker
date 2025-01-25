//
//  SceneDelegate.swift
//  FirebaseLogin
//
//  Created by Mavis II on 8/30/19.
//  Copyright © 2019 Bala. All rights reserved.
//

import UIKit
import SwiftUI
import Firebase


@available(iOS 14.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    @StateObject var appState = AppState() // Create an instance of AppState

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
           // Configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        FirebaseApp.configure()
        if let windowScene = scene as? UIWindowScene {
                 let window = UIWindow(windowScene: windowScene)
                 self.window = window
                 
                 // Create the SwiftUI view that provides the window content.
                 let contentView = ContentView() // Replace ContentView with your root view

                 // Create a UIHostingController with the content view and AppState
                 let hostingController = UIHostingController(rootView: contentView.environmentObject(appState))
                 window.rootViewController = hostingController
                 

                 
                 window.makeKeyAndVisible()
             }

       }
       
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

