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
    @Persisted var lastPlay: Int?
    @Persisted var image: Data?
    @Persisted var transcription: String?
    @Persisted var reviewCount: Int = 0
    @Persisted(originProperty: "reviews") var tags: LinkingObjects<TagNotification>
    
    var fileURL: URL {
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilePath = documentPath.appendingPathComponent("\(audioFileName)")
        return audioFilePath
    }
    
    var timeStamp: String {
        return "\(createdAt.toString(dateFormat: "YYYY.MM.dd hh:mm:ss a"))"
    }
    
    convenience init(audioFileName: String, createdAt: Date, fileName: String? = nil, lastPlay: CMTime? = nil, image: UIImage? = nil, transcription: String? = nil, reviewCount: Int = 0, tags: [String] = []) {
        self.init()
        self.audioFileName = audioFileName
        self.createdAt = createdAt
        self.fileName = fileName
        
        if let lastPlaySec = lastPlay {
            let lastPlaySecs = Int(CMTimeGetSeconds(lastPlaySec))
            self.lastPlay = lastPlaySecs
        }
        
        self.image = image?.jpegData(compressionQuality: 0.9)
        self.transcription = transcription
        self.reviewCount = reviewCount
        let realm = try! Realm()
        tags.map {
            let result = realm.objects(TagNotification.self).filter("title == \($0)")
            
        }
    }

}
