//
//  RecordingEntity+CoreDataProperties.swift
//  
//
//  Created by Subeen Park on 2021/11/06.
//
//

import Foundation
import CoreData


extension RecordingEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecordingEntity> {
        return NSFetchRequest<RecordingEntity>(entityName: "RecordingEntity")
    }

    @NSManaged public var id: Int16
    @NSManaged public var fileURL: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var fileName: String?
    @NSManaged public var lastPlay: CMTimeValue?
    @NSManaged public var tags: [String]?
    @NSManaged public var image: Data?
    @NSManaged public var reviewCount: Int16
    @NSManaged public var transcription: String?

}
