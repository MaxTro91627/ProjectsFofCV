//
//  PillBoxApp.swift
//  PillBox
//
//  Created by Максим Троицкий
//

import SwiftUI

@main
struct PillBoxApp: App {
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            if UserDefaults.standard.string(forKey: "UserPhoneNumber") != "" &&
                UserDefaults.standard.string(forKey: "UserBirthday") != "" &&
                UserDefaults.standard.string(forKey: "UserSurname") != "" &&
                UserDefaults.standard.string(forKey: "UserName") != "" &&
                UserDefaults.standard.string(forKey: "UserPhoneNumber") != nil &&
                UserDefaults.standard.string(forKey: "UserBirthday") != nil &&
                UserDefaults.standard.string(forKey: "UserSurname") != nil &&
                UserDefaults.standard.string(forKey: "UserName") != nil {
                ContentView()
            } else {
                startView()
            }
            
        }
    }
}

//@UIApplicationMain
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

//class AppDelegate: UIResponder, UIApplicationDelegate {
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        FirebaseApp.configure()
//        return true
//    }
//
//    // MARK: UISceneSession Lifecycle
//
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }
//
//}
