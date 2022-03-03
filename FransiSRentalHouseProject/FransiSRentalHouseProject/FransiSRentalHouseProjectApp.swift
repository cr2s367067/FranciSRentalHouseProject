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
    @StateObject var firebaseStorageInGeneral = FirebaseStorageInGeneral()
    @StateObject var storageForUserProfile = StorageForUserProfile()
    @StateObject var storageForRoomsImage = StorageForRoomsImage()
    @StateObject var firestoreToFetchUserinfo = FirestoreToFetchUserinfo()
    @StateObject var firestoreToFetchMaintainTasks = FirestoreToFetchMaintainTasks()
    @StateObject var firestoreToFetchRoomsData = FirestoreToFetchRoomsData()
    @StateObject var firebaseAuth = FirebaseAuth()
    @StateObject var localData = LocalData()
    @StateObject var appViewModel = AppViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(firebaseStorageInGeneral)
                .environmentObject(storageForUserProfile)
                .environmentObject(storageForRoomsImage)
                .environmentObject(firestoreToFetchUserinfo)
                .environmentObject(firestoreToFetchMaintainTasks)
                .environmentObject(firestoreToFetchRoomsData)
                .environmentObject(firebaseAuth)
                .environmentObject(localData)
                .environmentObject(appViewModel)
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
