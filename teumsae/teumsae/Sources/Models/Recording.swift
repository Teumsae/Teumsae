//
//  Recording.swift
//  teumsae
//
//  Created by Subeen Park on 2021/11/03.
//

import Foundation
import CoreMedia
import SwiftUI

struct Recording {
 
    var fileURL: URL {
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilePath = documentPath.appendingPathComponent("\(audioFileName)")
        return audioFilePath
    }
    var audioFileName: String
    let createdAt: Date

    // POST PROCESSING
    var fileName: String?
    var lastPlay: CMTimeValue?
    var image: UIImage?
    var transcription: String?
    var reviewCount: Int = 0
    var tags: [String] = []
    
    
    var timeStamp: String {
        return "\(createdAt.toString(dateFormat: "YYYY.MM.dd hh:mm:ss a"))"
    }
    
    init(audioFileName: String, createdAt: Date, fileName: String? = nil, lastPlay: CMTimeValue? = nil, image: UIImage? = nil, transcription: String? = nil, reviewCount: Int = 0, tags: [String] = []) {
        self.audioFileName = audioFileName
        self.createdAt = createdAt
        self.fileName = fileName
        self.lastPlay = lastPlay
        self.image = image
        self.transcription = transcription
        self.reviewCount = reviewCount
        self.tags = tags
    }
    
    
    func toDBinstance() -> [String: Any?] {
        return [
            "audioFileName" : audioFileName,
            "createdAt" : createdAt,
            "fileName" : fileName,
            "lastPlay" : lastPlay,
            "image" : image?.jpegData(compressionQuality:1.0),
            "transcription" : transcription,
            "reviewCount" : reviewCount,
            "tags" : tags
        ]
    }


}
