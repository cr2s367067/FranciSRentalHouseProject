//
//  FransiSRentalHouseProjectApp.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI
import Firebase
import ECPayPaymentGatewayKit
import FirebaseCore
import UserNotifications
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseStorage
import FirebaseFunctions

//@available(iOS 16, *)
@main
struct FransiSRentalHouseProjectApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
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
    @StateObject var bioAuthViewModel = BioAuthViewModel()
    @StateObject var searchVM = SearchViewModel()
    @StateObject var storeProfileVM = StoreProfileViewModel()
    @StateObject var userOrderedListVM = UserOrderedListViewModel()
    @StateObject var roomCARVM = RoomCommentAndRattingViewModel()
    @StateObject var soldProCollectionM = SoldProductCollectionManager()
    @StateObject var pwdM = PwdManager()
    @StateObject var imgPresentM = ImagePresentingManager()
//    @StateObject var rentalPC = RentalPaymentChartViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
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
                .environmentObject(bioAuthViewModel)
                .environmentObject(searchVM)
                .environmentObject(storeProfileVM)
                .environmentObject(userOrderedListVM)
                .environmentObject(roomCARVM)
                .environmentObject(soldProCollectionM)
                .environmentObject(pwdM)
                .environmentObject(imgPresentM)
//                .environmentObject(rentalPC)
                .withErrorHandling()
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {

    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {


        FirebaseApp.configure()

#if EMULATORS
        print(
        """
        *********************************
        Testing on Emulators
        *********************************
        """
        )
        Auth.auth().useEmulator(withHost:"localhost", port:9099)
        let settings = Firestore.firestore().settings
        settings.host = "localhost:8081"
        settings.isPersistenceEnabled = false
        settings.isSSLEnabled = false
        Firestore.firestore().settings = settings
        Storage.storage().useEmulator(withHost:"localhost", port:9199)
        Functions.functions().useEmulator(withHost: "localhost", port: 5003)
        Performance.sharedInstance().isInstrumentationEnabled = false
        Performance.sharedInstance().isDataCollectionEnabled = false
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(false)
        
        ECPayPaymentGatewayManager.sharedInstance().initialize(env: .Stage)
        
#elseif DEBUG
        print(
        """
        *********************************

        Testing on Live Server

        *********************************
        """
        )
        ECPayPaymentGatewayManager.sharedInstance().initialize(env: .Stage)
#endif

        //MARK: It will cause the keyboard that has gap upon
//        ECPayPaymentGatewayManager.sharedInstance().initialize(env: .Stage)
        
        Messaging.messaging().delegate = self

        if #available(iOS 10.0, *) {
                 // For iOS 10 display notification (sent via APNS)
                 UNUserNotificationCenter.current().delegate = self

                 let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                 UNUserNotificationCenter.current().requestAuthorization(
                   options: authOptions,
                   completionHandler: {_, _ in })
               } else {
                 let settings: UIUserNotificationSettings =
                 UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                 application.registerUserNotificationSettings(settings)
               }

               application.registerForRemoteNotifications()

        return true
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }

        print(userInfo)

        completionHandler(UIBackgroundFetchResult.newData)
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {

        let deviceToken:[String: String] = ["token": fcmToken ?? ""]
        print("Device token: ", deviceToken) // This token can be used for testing notifications on FCM
    }
}


@available(iOS 10, *)
extension AppDelegate {

  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo

    if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
    }

    print(userInfo)

    // Change this to your preferred presentation option
    completionHandler([[.banner, .badge, .sound]])
  }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {

    }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo

    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID from userNotificationCenter didReceive: \(messageID)")
    }

    print(userInfo)

    completionHandler()
  }
}
