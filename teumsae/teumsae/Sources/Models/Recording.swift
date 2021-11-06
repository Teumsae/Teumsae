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
 
    
    let fileURL: URL
    let createdAt: Date

    // POST PROCESSING
    let fileName: String?
    let lastPlay: CMTimeValue?
    let image: UIImage?
    let transcription: String?
    var reviewCount: Int = 0
    var tags: [String] = []
    
    init(fileURL: URL, createdAt: Date, fileName: String? = nil, lastPlay: CMTimeValue? = nil, image: UIImage? = nil, transcription: String? = nil, reviewCount: Int = 0, tags: [String] = []) {
        self.fileURL = fileURL
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
            "fileURL" : fileURL,
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
