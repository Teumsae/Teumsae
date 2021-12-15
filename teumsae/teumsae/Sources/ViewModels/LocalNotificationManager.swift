//
//  LocalNotificationManager.swift
//  teumsae
//
//  Created by Subeen Park on 2021/12/15.
//

import Foundation
import UserNotifications
import Realm

class LocalNotificationManager {
    
    enum NotificationIdentifierPrefix: String {
        case tag = "TAG-"
        case time = "TIME-"
    }


    func createNotification(tag: TagNotification) {
        
        let notiContent = UNMutableNotificationContent()
        notiContent.title = "\(tag.title)이 얼마 남지 않았습니다!"
        notiContent.body = "📚 복습하러 가볼까요?"
        notiContent.userInfo = ["tag-title": "\(tag.title)",
        ] // 푸시 받을때 오는 데이터

        // 알림이 trigger되는 시간 설정
        tag.timeTables.forEach { timeTable in
            let date = DateComponents(hour: timeTable.hr, minute: timeTable.min, weekday: timeTable.day)
            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
            let request = UNNotificationRequest(
                identifier: "\(NotificationIdentifierPrefix.tag.rawValue)\(tag.title)",
                content: notiContent,
                trigger: trigger
            )
            
            print("TAG REQUEST \(request)")
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Uh oh! We had an error: \(error)")
                } else {
                    print("REQUEST \(request) created")
                }
            }
            
        }
        
    }
    
    func createNotification(time: TimeNotification) {
        
        let notiContent = UNMutableNotificationContent()
        notiContent.title = "\(time.title) 시간입니다!"
        notiContent.body = "📚 복습하러 가볼까요?"
        notiContent.userInfo = ["time-title": "\(time.title)",
        ] // 푸시 받을때 오는 데이터

        // 알림이 trigger되는 시간 설정
        time.days.forEach { day in
            let date = DateComponents(hour: time.hr, minute: time.min, weekday: day)
            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
            let request = UNNotificationRequest(
                identifier: "\(NotificationIdentifierPrefix.time.rawValue)\(time.title)",
                content: notiContent,
                trigger: trigger
            )
            print("TIME REQUEST \(request)")
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Uh oh! We had an error: \(error)")
                } else {
                    print("REQUEST \(request) created")
                }
            }
            
            
        }
    }
    
    func removeNotification(tag: TagNotification) {
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
           var identifiers: [String] = []
           for notification:UNNotificationRequest in notificationRequests {
               if notification.identifier == "\(NotificationIdentifierPrefix.tag.rawValue)\(tag.title)" {
                  identifiers.append(notification.identifier)
               }
           }
           UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
            print("REQUEST \(identifiers) deleted")
        }
        
        
    }
    
    func removeNotification(time: TimeNotification) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
           var identifiers: [String] = []
           for notification:UNNotificationRequest in notificationRequests {
               if notification.identifier == "\(NotificationIdentifierPrefix.time.rawValue)\(time.title)" {
                  identifiers.append(notification.identifier)
               }
           }
           UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
            print("REQUEST \(identifiers) deleted")
        }
        
    }
    
    
    

    
}
