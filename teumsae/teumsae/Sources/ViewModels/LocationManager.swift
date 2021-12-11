//
//  LocationManager.swift
//  teumsae
//
//  Created by Subeen Park on 2021/11/13.
//
// REF: https://www.raywenderlich.com/20690666-location-notifications-with-unlocationnotificationtrigger

import CoreLocation
import UserNotifications

class LocationManager: NSObject, ObservableObject {
  var location = CLLocationCoordinate2D(latitude: 37.532600, longitude: 127.024612)
  let notificationCenter = UNUserNotificationCenter.current()
  lazy var storeRegion = makeStoreRegion()
  @Published var didArriveAtTakeout = false
  // 1
  lazy var locationManager = makeLocationManager()
  // 2
  private func makeLocationManager() -> CLLocationManager {
    // 3
    let manager = CLLocationManager()
    manager.allowsBackgroundLocationUpdates = true
    // 4
    return manager
  }

    // 1
    public func setCenterLocation(latitude: Double, longitude: Double) {
      // 2
        self.location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude) //default
        print("LocationManager: setCenterLocation ", location.latitude, location.longitude)
        storeRegion = makeStoreRegion()
        validateLocationAuthorizationStatus()
//      return location
    }
   
  // 1
  private func makeStoreRegion() -> CLCircularRegion {
    // 2
    let region = CLCircularRegion(
      center: location,
      radius: 2,
      identifier: UUID().uuidString)
    // 3
    region.notifyOnEntry = true
    // 4
    return region
  }

  // 1
  func validateLocationAuthorizationStatus() {
    // 2
      
    print("LocationManager: validateLocationAuthorizationStatus()")
    switch locationManager.authorizationStatus {
    // 3
    case .notDetermined, .denied, .restricted:
      // 4
      print("Location Services Not Authorized")
      locationManager.requestWhenInUseAuthorization()
      requestNotificationAuthorization()

    // 5
    case .authorizedWhenInUse, .authorizedAlways:
      // 6
      print("Location Services Authorized")
      requestNotificationAuthorization()

    default:
      break
    }
  }

  // 1
  private func requestNotificationAuthorization() {
    // 2
    print("LocationManager: requestNotificationAuthorization()")
    let options: UNAuthorizationOptions = [.sound, .alert]
    // 3
    notificationCenter
      .requestAuthorization(options: options) { [weak self] result, _ in
        // 4
        print("Auth Request result: \(result)")
        if result {
          self?.registerNotification()
        }
      }
  }

  // 1
  private func registerNotification() {
    // 2
    print("LocationManager: registerNotification() ")
    let notificationContent = UNMutableNotificationContent()
    notificationContent.title = "집에 도착하셨나요?"
    notificationContent.body = "복습을 시작해봅시다"
    notificationContent.sound = .default

    // 3
    let trigger = UNLocationNotificationTrigger(region: storeRegion, repeats: false)

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

  // 1
  override init() {
    super.init()
    // 2
    notificationCenter.delegate = self
  }
}

extension LocationManager: UNUserNotificationCenterDelegate {
  // 1
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    // 2
    print("Received Notification")
    didArriveAtTakeout = true
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
    print("Received Notification in Foreground")
    didArriveAtTakeout = true
    // 6
    completionHandler([.alert, .sound])
  }
}
