//
//  NotificationService.swift
//  RichNotification
//
//  Created by seungyeon on 2021/11/17.
//
// ref: https://www.avanderlee.com/swift/rich-notifications/

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

      private var contentHandler: ((UNNotificationContent) -> Void)?
      private var bestAttemptContent: UNMutableNotificationContent?

      override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
          self.contentHandler = contentHandler
          bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)

          defer {
              contentHandler(bestAttemptContent ?? request.content)
          }
          
//          bestAttemptContent?.categoryIdentifier = "content_added_notification" //you can change categoryIdentifier in payload
          guard let attachment = request.attachment else { return }

          bestAttemptContent?.attachments = [attachment]
      }
      
      override func serviceExtensionTimeWillExpire() {
          // Called just before the extension will be terminated by the system.
          // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
          if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent {
              contentHandler(bestAttemptContent)
          }
      }
    
    
    
}


extension UNNotificationRequest {
    var attachment: UNNotificationAttachment? {
        guard let attachmentURL = content.userInfo["image_url"] as? String, let imageData = try? Data(contentsOf: URL(string: attachmentURL)!) else {
            return nil
        }
        return try? UNNotificationAttachment(data: imageData, options: nil)
    }
}

extension UNNotificationAttachment {

    convenience init(data: Data, options: [NSObject: AnyObject]?) throws {
        let fileManager = FileManager.default
        let temporaryFolderName = ProcessInfo.processInfo.globallyUniqueString
        let temporaryFolderURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(temporaryFolderName, isDirectory: true)

        try fileManager.createDirectory(at: temporaryFolderURL, withIntermediateDirectories: true, attributes: nil)
        let imageFileIdentifier = UUID().uuidString + ".jpg"
        let fileURL = temporaryFolderURL.appendingPathComponent(imageFileIdentifier)
        try data.write(to: fileURL)
        try self.init(identifier: imageFileIdentifier, url: fileURL, options: options)
    }
}

