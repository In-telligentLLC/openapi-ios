//
//  SceneDelegate.swift
//  iosOpenAPIDemo
//
//  Created by Likhitha  Narayana on 01/12/22.
//

import UIKit
import OpenAPI

/// this class is responsible for handling life-cycle events occuring in a scene
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    //MARK: Variables declaration
    /// window: an instance of UIWindow
    var window: UIWindow?
    
    //MARK: Delegate methods
    ///  dismisses splash screen within given time interval and sets style to navigation bar
    /// - Parameters:
    ///   - scene: The scene object being connected to the app.
    ///   - session: The session object containing details about the scene's configuration.
    ///   - connectionOptions:  Additional options for configuring the scene
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        setNavigationBarStyle()
        self.splashScreen()
    }
    
    /// called as the scene is being released by the system
    /// - Parameter scene: The scene object being connected to the app.
    func sceneDidDisconnect(_ scene: UIScene) {
        
    }
    
    /// called when the scene has moved from an inactive state to an active state.
    /// - Parameter scene: The scene object being connected to the app.
    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }
    
    ///  called when the scene will move from an active state to an inactive state.
    /// - Parameter scene: The scene object being connected to the app.
    func sceneWillResignActive(_ scene: UIScene) {
        
    }
    
    /// called as the scene transitions from the background to the foreground.
    /// - Parameter scene: The scene object being connected to the app.
    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }
    
    /// called as the scene transitions from the foreground to the background.
    /// - Parameter scene: The scene object being connected to the app.
    func sceneDidEnterBackground(_ scene: UIScene) {
        
    }
    
    //MARK: Static methods
    /// setting the appearance features and style of navigation bar
    func setNavigationBarStyle() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(red: 55.0/255.0, green: 0/255.0, blue: 179.0/255.0, alpha: 1.0)
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().isTranslucent = false
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
    }
    
    /// creating a dummy splash screen for 1sec time interval, which launches when a app is launched for the first time.
    private func splashScreen() {
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(dissmissSplashController), userInfo: nil, repeats: false)
    }
    
    /// launching dash board after the dismiss of splash screen.
    @objc func dissmissSplashController() {
        if OpenAPI.checkToken() {
            var rootVCStoryboardId = "SWRevealViewController"
            self.window?.rootViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: rootVCStoryboardId)
        } else {
            var rootVCStoryboardId = "LoginViewController"
            self.window?.rootViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: rootVCStoryboardId)
        }
    }
}
