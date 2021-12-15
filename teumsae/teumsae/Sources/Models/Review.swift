//
//  Review.swift
//  teumsae
//
//  Created by Subeen Park on 2021/12/14.
//


import Foundation
import CoreMedia
import RealmSwift
import SwiftUI

class Review: Object, ObjectKeyIdentifiable {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var audioFileName: String
    @Persisted var createdAt: Date

    
    // POST PROCESSING
    @Persisted var fileName: String?
    @Persisted var percent: Double = 0
    @Persisted var totalLength: Int = 1
    @Persisted var image: Data?
    @Persisted var transcription: String?
    @Persisted var reviewCount: Int = 0
    @Persisted var reviewGoal: Int = 3
    @Persisted(originProperty: "reviews") var tag: LinkingObjects<TagNotification>
    
    var fileURL: URL {
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilePath = documentPath.appendingPathComponent("\(audioFileName)")
        return audioFilePath
    }
    
    var timeStamp: String {
        return "\(createdAt.toString(dateFormat: "YYYY.MM.dd hh:mm:ss a"))"
    }
    
    convenience init(audioFileName: String, createdAt: Date, fileName: String? = nil, image: UIImage? = nil, transcription: String? = nil, reviewCount: Int = 0) {
        self.init()
        self.audioFileName = audioFileName
        self.createdAt = createdAt
        self.fileName = fileName
        
        self.image = image?.jpegData(compressionQuality: 0.9)
        self.transcription = transcription
        self.reviewCount = reviewCount

    }

}
