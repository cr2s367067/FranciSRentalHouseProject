//
//  NotificationManager.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/5/23.
//

import Foundation
import UIKit
import UserNotifications

class NotificationManager: ObservableObject {
    func msgPushNotification(msgID: String, userName: String, msgContent: String) {
        let content = UNMutableNotificationContent()
        content.title = userName
        content.body = msgContent
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)

        let request = UNNotificationRequest(identifier: msgID, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }
}
