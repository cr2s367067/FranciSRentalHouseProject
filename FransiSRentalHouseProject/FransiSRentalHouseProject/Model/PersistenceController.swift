//
//  PersistenceController.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import Foundation
import CoreData

class PersistenceController: ObservableObject {
    
    let container: NSPersistentContainer
    let appViewModel = AppViewModel()
    
    init() {
        container = NSPersistentContainer(name: "UserCoreDataModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
    
    func saveUserType(userType: String) {
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
            tempStringHolder = try container.viewContext.fetch(fetchRequest).map({$0.userType ?? ""}).first ?? ""
//            appViewModel.tempUserType = tempStringHolder
        } catch {
            print("Fail to fetch data from core data")
        }
        return tempStringHolder
    }
    
}
