//
//  TimeNotification.swift
//  teumsae
//
//  Created by Subeen Park on 2021/12/14.
//

import Foundation
import RealmSwift


class TimeNotificationGroup: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var notifications = RealmSwift.List<TimeNotification>()
}


class TimeNotification: Object, ObjectKeyIdentifiable {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var title: String
    @Persisted var days: List<Int>
    @Persisted var hr: Int
    @Persisted var min: Int
    @Persisted var isTurnedOn = false
    @Persisted(originProperty: "notifications") var group: LinkingObjects<TimeNotificationGroup>
    
    convenience init(title: String, hr: Int, min: Int, days: [Int]) {
        self.init()
        self.title = title
        self.hr = hr
        self.min = min
        self.days = List<Int>()
        days.map({
            self.days.append($0)
        })
    }
}
