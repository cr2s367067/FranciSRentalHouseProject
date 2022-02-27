//
//  FransiSRentalHouseProjectApp.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI
import Firebase

@main
struct FransiSRentalHouseProjectApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
//    @StateObject private var persistenceController = PersistenceController()
    
    var body: some Scene {
        WindowGroup {
            let appViewModel = AppViewModel()
            let fetchFireStore = FetchFirestore()
            let localData = LocalData()
            ContentView()
                .environmentObject(appViewModel)
                .environmentObject(fetchFireStore)
                .environmentObject(localData)
                .withErrorHandling()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        
        return true
    }
}
