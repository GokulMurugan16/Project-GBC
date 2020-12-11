//
//  AppDelegate.swift
//  gbc-Project
//
//  Created by Gokul Murugan on 2020-10-02.
//

import UIKit
import Firebase
import GoogleSignIn
@main
class AppDelegate: UIResponder, UIApplicationDelegate,GIDSignInDelegate {

    var window:UIWindow?
    
  
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "navID") as! UINavigationController
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        FirebaseApp.configure()
        GIDSignIn.sharedInstance()?.clientID = "14369103638-8vq4t1peahk1586cdrb2ffhgjl33pnj1.apps.googleusercontent.com"

        GIDSignIn.sharedInstance()?.delegate = self
       
        return true
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        print("User Email: \(user.profile.email ?? " No Email")")
        
       let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "tabBarCont") as! UITabBarController
//        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "navID") as! UINavigationController
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
        
    }
    // MARK: UISceneSession Lifecycle
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
   
  

}

