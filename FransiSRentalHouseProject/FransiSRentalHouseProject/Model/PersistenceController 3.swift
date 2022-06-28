//
//  PersistenceController.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

/*
 import Foundation
 import CoreData

 class PersistenceController: ObservableObject {

     let container: NSPersistentContainer
     let appViewModel = AppViewModel()
     let fetchFirestore = FetchFirestore()

     init() {
         container = NSPersistentContainer(name: "UserCoreDataModel")
         container.loadPersistentStores { description, error in
             if let error = error {
                 fatalError("Core Data failed to load: \(error.localizedDescription)")
             }
         }
     }

     func saveUserType(userType: String, userUID: String) {
         let userStatus = UserStatusProperty(context: container.viewContext)

         userStatus.userType = userType
         userStatus.userUID = userUID

         do {
             try container.viewContext.save()
             print("save success")
         } catch {
             print("Fail to save user type: \(error)")
         }
     }

     func updateUserType(userType: String) {
         let userStatus = UserStatusProperty(context: container.viewContext)

         userStatus.userType = userType

         do {
             try container.viewContext.save()
             print("save success")
         } catch {
             print("Fail to save user type: \(error)")
         }
     }

     func getUsertype() -> String {
         var tempStringHolder = ""
         let fetchRequest: NSFetchRequest<UserStatusProperty> = UserStatusProperty.fetchRequest()
         do {
             tempStringHolder = try container.viewContext.fetch(fetchRequest).map({$0.userType ?? ""}).first!
 //            appViewModel.tempUserType = tempStringHolder
         } catch {
             print("Fail to fetch data from core data")
         }
         return tempStringHolder
     }

     func getUserUID() -> String {
         var tempUIDHolder = ""
         let fetchRequest: NSFetchRequest<UserStatusProperty> = UserStatusProperty.fetchRequest()
         do {
             tempUIDHolder = try container.viewContext.fetch(fetchRequest).map({
                 $0.userUID ?? ""
             }).first!
         } catch {
             print("Fail to fetch data from core data")
         }
         return tempUIDHolder
     }

 //    func persistenceRenter() {
 //        let fetchRequest: NSFetchRequest<UserStatusProperty> = UserStatusProperty.fetchRequest()
 //        var tempUIDHolder = ""
 //        var tempUserType = ""
 //        do {
 //            let fetchCoreData = try container.viewContext.fetch(fetchRequest)
 //            for userEmail in fetchCoreData {
 //                tempUIDHolder = userEmail.userEmail ?? ""
 //            }
 //            for userType in fetchCoreData {
 //
 //            }
 //        } catch {
 //            print("fail to fetch data")
 //        }
 //
 //    }

 }
 */
