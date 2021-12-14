//
//  TimeManager.swift
//  teumsae
//
//  Created by seungyeon on 2021/12/13.
//
import Foundation
import SwiftUI
import CoreMotion
import UserNotifications


//사용자 지정 시간대에 원하는 횟수를 일정 interval로 리마인더 보냄
//사용자한테 받을 인풋:
//알림 원하는 고정 시간대
//알림 원하지 않는 고정 시간대 – 제일 우선순위 높은 규칙
//(optional) 원하는 횟수: default = 1
//(optional) 원하는 interval: default = 60 min / 원하는 횟수





class TimeManager: NSObject, ObservableObject{

    let queue = OperationQueue()
    let notificationCenter = UNUserNotificationCenter.current()
    
    
    override init(){
        super.init()
        notificationCenter.delegate = self
    }
    
    
    // 1
    func validateTimeAuthorizationStatus() {
        // 2
        print("TimeManager: validateMotionAuthorizationStatus()")
        requestNotificationAuthorization()
    }
    
    
    // 1
    private func requestNotificationAuthorization() {
      // 2
      print("TimeManager: requestNotificationAuthorization()")
      let options: UNAuthorizationOptions = [.sound, .alert]
      // 3
      notificationCenter
        .requestAuthorization(options: options) { [weak self] result, _ in
          // 4
          print("Notification Auth Request result: \(result)")
//          if result {
//                  self?.registerNotification(title_: "복습할 시간입니다 :)")
//              }
//          }
			if(!result){
				print("not accept authorization")
			}else{
				print("accept authorization")
				self?.notificationCenter.delegate = self
			}
		}
    }
    
    // 1

   func registerNotification(title_: String, hr: Int, min: Int, daysSelected: [Int]) { //TODO: 여기 인풋을 사용자로부터(마이페이지에서) 받게끔 수정해주시면 좋을 것 같습니다 :) 고맙습니다.
        
        for day in daysSelected{
            print ("day", day)
            // 2
            print("TimeManager: registerNotification() ")
            let notificationContent = UNMutableNotificationContent()
            notificationContent.title = title_
            notificationContent.body = title_
            notificationContent.sound = .default
            notificationContent.categoryIdentifier = "rich_notification"
            
            
//            //Receive with date
//            var dateInfo = DateComponents()
//            dateInfo.day = 14 //Put your day
//            dateInfo.month = 12 //Put your month
//            dateInfo.year = 2021 // Put your year
//            dateInfo.hour = 0 //Put your hour
//            dateInfo.minute = 10 //Put your minutes 
            
            var date = DateComponents()
            date.weekday = day+1
            date.hour = hr
            date.minute = min
            
            //specify if repeats or no
            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
            
        
            
          // 4
            let request = UNNotificationRequest(
                identifier: UUID().uuidString,
                content: notificationContent,
                trigger: trigger
            )

          // 5
            notificationCenter
                .add(request) { error in
                  if error != nil {
                    print("Error: \(String(describing: error))")
                  }
                }
        } // END OF REGISTERNOTIFICATION
        }
        

}


extension TimeManager: UNUserNotificationCenterDelegate {
  // 1
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    // 2
    print("TimeManager: Received Notification")

    // 3
    completionHandler()
  }

  // 4
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler:
      @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    // 5
    print("TimeManager: Received Notification in Foreground")

    // 6
    completionHandler([.alert, .sound])
      
  }
}








