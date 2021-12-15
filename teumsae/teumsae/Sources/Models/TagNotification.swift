//
//  TagNotification.swift
//  teumsae
//
//  Created by Subeen Park on 2021/12/14.
//

import Foundation
import RealmSwift


class TagNotificationGroup: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var notifications = RealmSwift.List<TagNotification>()
    
}


class TagNotification: Object, ObjectKeyIdentifiable {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var title: String
    @Persisted var timeTables: List<TimeTable>
    @Persisted var isTurnedOn = false
    @Persisted(originProperty: "notifications") var group: LinkingObjects<TagNotificationGroup>
    @Persisted var reviews = RealmSwift.List<Review>()
    
    convenience init(title: String, timeStamps: [DateComponents]) {
        self.init()
        self.title = title
        self.timeTables = List<TimeTable>()
        timeStamps.map({
            self.timeTables.append(TimeTable(date: $0))
        })
    }
}

class TimeTable: Object, ObjectKeyIdentifiable {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var day: Int
    @Persisted var hr: Int
    @Persisted var min: Int
    
    convenience init(date: DateComponents) {
        self.init()
        self.day = date.weekday!
        self.hr = date.hour!
        self.min = date.minute!
        
    }
}
