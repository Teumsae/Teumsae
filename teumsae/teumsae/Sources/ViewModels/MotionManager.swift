//
//  MotionManager.swift
//  teumsae
//
//  Created by seungyeon on 2021/11/28.
//
//ref: https://developer.apple.com/forums/thread/685018
// ref https://medium.com/the-lenfest-local-lab/building-context-aware-notifications-c3a7ec9d6bc4



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
    @Published var consecutiveWalking = 0
    @Published var triggerNotification = true
    var time: Double = 2.2

    
    override init(){
        super.init()
        notificationCenter.delegate = self
//        self.motionManager = CMMotionActivityManager()
        self.motionManager.startActivityUpdates(to: OperationQueue.current!, withHandler: {
            (deviceActivity: CMMotionActivity!) -> Void in
            
            if deviceActivity.walking {
                print("Motion: walking")
                if (self.isWalking){
                    print("Motion: Still walking")
                    self.isWalkingStill = true
                    // TODO: 지금은 walking 하고 있으면 계속 알림 보냄 -> location, motion, 시간대 맞춰 로직 수정할 것
                    self.consecutiveWalking += 1
                    print("Motion: triggerNotification ", self.consecutiveWalking)
                    if ((self.consecutiveWalking == 3) && (self.triggerNotification == true)){
                        //only when three consecutive walking sensed
                        //&& there was no noficiation within 1 hour, we send a new notification
                        self.registerNotification(title_: "복습을 시작해볼까요? (trigger)")
                        self.manageTriggerNotification()
                    }
                    
                }
                else{ //newly sensed walking
                    self.isWalking = true
                }
            }
            else { // NOT WALKING
                if deviceActivity.stationary {
                    print("Motion: stationary")
                }
                else if deviceActivity.running{
                    print("Motion: running")
                }
                else if deviceActivity.automotive{
                    print("Motion: automotive")
                }
                else {
                    print("Motion: unknown")
                }
                self.isWalking = false
                self.isWalkingStill = false
                self.consecutiveWalking = 0
                
            } // END OF NOT WALKING
        })
    }
    
    private func manageTriggerNotification(){
        self.triggerNotification = false
        self.consecutiveWalking = 0
        
        print("MotionManager: manageTriggerNotification starts ", DispatchTime.now())
        let when = DispatchTime.now() + 60*60 // do not send notification after 60*60 seconds (1 hour) even though walking
        print("MotionManager: manageTriggerNotification starts ", when)
        DispatchQueue.main.asyncAfter(deadline: when){
            self.triggerNotification = true
            print("MotionManager: manageTriggerNotification set triggerNotification ", self.triggerNotification, " ", DispatchTime.now())
        }
        
    }
    
    // 1
    func validateMotionAuthorizationStatus() {
        // 2
        print("validateMotionAuthorizationStatus()")
        requestNotificationAuthorization()
        print("MotionManager: requestNotificationAuthorization finished")
        
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
                  //no notification when app starts.
//                  self?.registerNotification(title_: "복습을 시작해봅시다 (1st)")
                  
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
    self.consecutiveWalking = 0
//      isWalking = true
    // 6
    completionHandler([.alert, .sound])
      
  }
}








