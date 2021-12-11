//
//  MotionManager.swift
//  teumsae
//
//  Created by seungyeon on 2021/11/28.
//



import Foundation
import SwiftUI
import CoreMotion
import UserNotifications




class MotionManager: NSObject, ObservableObject{
//    private var motionManager: CMMotionActivityManager
    lazy var motionManager = CMMotionActivityManager()
    let queue = OperationQueue()
    let notificationCenter = UNUserNotificationCenter.current()
    
    @Published var isWalking = true
    @Published var isWalkingStill = false
    @Published var triggerNotification = 0

    
    override init(){
        super.init()
        notificationCenter.delegate = self
//        self.motionManager = CMMotionActivityManager()
        self.motionManager.startActivityUpdates(to: OperationQueue.current!, withHandler: {
            (deviceActivity: CMMotionActivity!) -> Void in
            if deviceActivity.stationary {
                print("Motion: stationary")
                self.isWalking = false
                self.isWalkingStill = false
            }
            else if deviceActivity.walking {
                print("Motion: walking")
                if (self.isWalking){
                    print("Motion: Still walking")
                    self.isWalkingStill = true
                    // TODO: 지금은 walking 하고 있으면 계속 알림 보냄 -> location, motion, 시간대 맞춰 로직 수정할 것
                    if (self.triggerNotification  == 0){ //if there is no notification in queue, request notification
                        self.triggerNotification += 1
                        print("Motion: triggerNotification ", self.triggerNotification)
                        self.registerNotification(title_: "복습을 시작해볼까요? (trigger)")
                    }
                }
                else{ //newly sensed walking
                    self.isWalking = true
                }
            }
            else if deviceActivity.running{
                print("Motion: running")
                self.isWalking = false
                self.isWalkingStill = false
            }
            else if deviceActivity.automotive{
                print("Motion: automotive")
                self.isWalking = false
                self.isWalkingStill = false
            }
            else {
                print("Motion: unknown")
                self.isWalking = false
                self.isWalkingStill = false
            }
        })
    }
    
    // 1
    func validateMotionAuthorizationStatus() {
        // 2
        print("validateMotionAuthorizationStatus()")
        requestNotificationAuthorization()
        print("MotionManager: requestNotificationAuthorization finished")
        
//        while(true){
//            if (triggerNotification > 0){
//                print("MotionManager: triggerNotification > 0")
//                registerNotification(title_: "복습을 시작해봅시다 (trigger)")
//                triggerNotification -= 1
//            }
//        }
        
        
        
//        switch CMMotionActivityManager.authorizationStatus() {
//      // 3
//      case .notDetermined, .denied, .restricted:
//        // 4
//        print("Motion Services Not Authorized")
//        motionManager.requestWhenInUseAuthorization()
//        requestNotificationAuthorization()
//
//      // 5
//      case .authorizedWhenInUse, .authorizedAlways:
//        // 6
//        print("Location Services Authorized")
//        requestNotificationAuthorization()
//
//      default:
//        break
//      }
    }
    
    
    // 1
    private func requestNotificationAuthorization() {
      // 2
      print("MotionManager: requestNotificationAuthorization()")
      let options: UNAuthorizationOptions = [.sound, .alert]
      // 3
      notificationCenter
        .requestAuthorization(options: options) { [weak self] result, _ in
          // 4
          print("Auth Request result: \(result)")
          if result {
              if ((self?.isWalking) != nil){
                  self?.registerNotification(title_: "복습을 시작해봅시다 (1st)")
              }
          }
        }
    }


    // 1
    private func registerNotification(title_: String) {
      // 2
      print("MotionManager: registerNotification() ")
      let notificationContent = UNMutableNotificationContent()
      notificationContent.title = "이동 중이신가요?"
      notificationContent.body = title_
      notificationContent.sound = .default

      // 3
//        let trigger = UNPushNotificationTrigger()
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: (1*15), repeats: false) // notification after 1 * 15 sec

      // 4
      let request = UNNotificationRequest(
        identifier: UUID().uuidString,
        content: notificationContent,
        trigger: trigger)

      // 5
      notificationCenter
        .add(request) { error in
          if error != nil {
            print("Error: \(String(describing: error))")
          }
        }
      
        
    }

    


//    func startTrackingMotionActivity(){
//        motionManager.startActivityUpdates(to: OperationQueue.current!, withHandler: {
//            (deviceActivity: CMMotionActivity!) -> Void in
//            if deviceActivity.stationary {
////                motionManager.setValue(Any?, forKey: String)
//                print("Motion: stationary")
//
//            }
//            else if deviceActivity.walking {
//                print("Motion: walking")
//
//            }
//            else if deviceActivity.running{
//                print("Motion: running")
//            }
//            else if deviceActivity.automotive{
//                print("Motion: automotive")
//            }
//            else {
//                print("Motion: unknown")
//            }
//        })
//    }

    func stopTrackingMotionActivity(){
        motionManager.stopActivityUpdates()
    }
}


extension MotionManager: UNUserNotificationCenterDelegate {
  // 1
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    // 2
    print("MotionManager: Received Notification")
//    isWalking = true
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
    print("MotionManager: Received Notification in Foreground")
    self.triggerNotification = 0
//      isWalking = true
    // 6
    completionHandler([.alert, .sound])
      
  }
}


// ref https://medium.com/the-lenfest-local-lab/building-context-aware-notifications-c3a7ec9d6bc4

/*
 //ref: https://developer.apple.com/forums/thread/685018
 */



