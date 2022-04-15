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
//    @StateObject var firebaseStorageInGeneral = FirebaseStorageInGeneral()
    @StateObject var storageForUserProfile = StorageForUserProfile()
    @StateObject var storageForRoomsImage = StorageForRoomsImage()
    @StateObject var firestoreToFetchUserinfo = FirestoreToFetchUserinfo()
    @StateObject var firestoreToFetchMaintainTasks = FirestoreToFetchMaintainTasks()
    @StateObject var firestoreToFetchRoomsData = FirestoreToFetchRoomsData()
    @StateObject var firebaseAuth = FirebaseAuth()
    @StateObject var localData = LocalData()
    @StateObject var appViewModel = AppViewModel()
    @StateObject var firestoreForContactInfo = FirestoreForContactInfo()
    @StateObject var roomsLocationDataModel = RoomsLocationDataModel()
    @StateObject var firestoreForTextingMessage = FirestoreForTextingMessage()
    @StateObject var textingViewModel = TextingViewModel()
    @StateObject var firestoreFetchingAnnouncement = FirestoreFetchingAnnouncement()
    @StateObject var firestoreForProducts = FirestoreForProducts()
    @StateObject var productsProviderSummitViewModel = ProductsProviderSummitViewModel()
    @StateObject var storageForProductImage = StorageForProductImage()
    @StateObject var productDetailViewModel = ProductDetailViewModel()
    @StateObject var paymentSummaryVM = PaymentSummaryViewModel()
    @StateObject var userOrderedListViewModel = UserOrderedListUnitViewModel()
    @StateObject var renterContractEditViewModel = RenterContractEditViewModel()
    @StateObject var renterContractViewModel = RenterContractViewModel()
    @StateObject var userDetailInfoViewModel = UserDetailInfoViewModel()
    @StateObject var roomsDetailViewModel = RoomsDetailViewModel()
    @StateObject var providerRoomSummitViewModel = ProviderRoomSummitViewModel()
    @StateObject var purchaseViewModel = PurchaseViewModel()
    @StateObject var renterProfileViewModel = RenterProfileViewModel()
    @StateObject var paymentMethodManager = PaymentMethodManager()
    @StateObject var autoPaymentSettingViewModel = AutoPaymentSettingViewModel()
    @StateObject var storageForMaintainImage = StorageForMaintainImage()
    @StateObject var paymentReceiveManager = PaymentReceiveManager()
    @StateObject var providerProfileViewModel = ProviderProfileViewModel()
    @StateObject var providerBarChartViewModel = ProviderBarChartViewModel()
    @StateObject var storageForMessageImage = StorageForMessageImage()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
//                .environmentObject(firebaseStorageInGeneral)
                .environmentObject(storageForUserProfile)
                .environmentObject(storageForRoomsImage)
                .environmentObject(firestoreToFetchUserinfo)
                .environmentObject(firestoreToFetchMaintainTasks)
                .environmentObject(firestoreToFetchRoomsData)
                .environmentObject(firebaseAuth)
                .environmentObject(localData)
                .environmentObject(appViewModel)
                .environmentObject(firestoreForContactInfo)
                .environmentObject(roomsLocationDataModel)
                .environmentObject(firestoreForTextingMessage)
                .environmentObject(textingViewModel)
                .environmentObject(firestoreFetchingAnnouncement)
                .environmentObject(firestoreForProducts)
                .environmentObject(productsProviderSummitViewModel)
                .environmentObject(storageForProductImage)
                .environmentObject(productDetailViewModel)
                .environmentObject(paymentSummaryVM)
                .environmentObject(userOrderedListViewModel)
                .environmentObject(renterContractEditViewModel)
                .environmentObject(renterContractViewModel)
                .environmentObject(userDetailInfoViewModel)
                .environmentObject(roomsDetailViewModel)
                .environmentObject(providerRoomSummitViewModel)
                .environmentObject(purchaseViewModel)
                .environmentObject(renterProfileViewModel)
                .environmentObject(paymentMethodManager)
                .environmentObject(autoPaymentSettingViewModel)
                .environmentObject(storageForMaintainImage)
                .environmentObject(paymentReceiveManager)
                .environmentObject(providerProfileViewModel)
                .environmentObject(providerBarChartViewModel)
                .environmentObject(storageForMessageImage)
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
