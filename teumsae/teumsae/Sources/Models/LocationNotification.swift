//
//  LocationNotification.swift
//  teumsae
//
//  Created by Subeen Park on 2021/12/14.
//

import SwiftUI
import RealmSwift


class LocationNotificationGroup: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var notifications = RealmSwift.List<LocationNotification>()
}


class LocationNotification: Object, ObjectKeyIdentifiable {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var title: String
    @Persisted var lat: Double
    @Persisted var lon: Double
    @Persisted var isTurnedOn = false
    @Persisted(originProperty: "notifications") var group: LinkingObjects<LocationNotificationGroup>
    
    convenience init(title: String, lat: Double, lon: Double) {
        self.init()
        self.title = title
        self.lat = lat
        self.lon = lon
    }
}
