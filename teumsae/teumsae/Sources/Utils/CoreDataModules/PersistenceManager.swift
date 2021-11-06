//
//  PersistenceManager.swift
//  teumsae
//
//  Created by Subeen Park on 2021/11/06.
//

import Foundation
import CoreData
import UIKit
import CoreMedia

class PersistenceManager {
    
    let ENTITY_NAME = "RecordingEntity"
    
    static var shared: PersistenceManager = PersistenceManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "teumsae")
        container.loadPersistentStores(completionHandler: {
            (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    
    func create(_ recording: Recording) -> Void {
        
        let entity = NSEntityDescription.entity(forEntityName: ENTITY_NAME, in: context)
        
        if let entity = entity {
            let recordingEntity = NSManagedObject(entity: entity, insertInto: context)
            recordingEntity.setValuesForKeys(recording.toDBinstance())

        }
        do {
            try self.context.save()
        }
        catch {
            print(error.localizedDescription)
        }
    }
        
    func read() -> [Recording] {
        
        let readRequest = NSFetchRequest<NSManagedObject>(entityName: ENTITY_NAME)
        let recordingData = try! context.fetch(readRequest)
    
        var dataToRecordings = [Recording]()
        
        for data in recordingData{
            
            let fileURL = data.value(forKey: "fileURL") as! URL
            let createdAt = data.value(forKey: "createdAt") as! Date
            
            let fileName =  data.value(forKey: "fileName") as? String
            let lastPlay = data.value(forKey: "lastPlay") as? CMTimeValue
            let imageData = data.value(forKey: "image") as? Data
            var image: UIImage? = nil
            if let imageData = imageData {
                image = UIImage(data: imageData)
            }
            let transcription = data.value(forKey: "transcription") as? String
            var reviewCount = data.value(forKey: "reviewCount") as? Int ?? 0
            var tags: [String] = data.value(forKey: "tags") as? [String] ?? []
            
            dataToRecordings.append(Recording(fileURL: fileURL,
                                              createdAt: createdAt,
                                              fileName: fileName,
                                              lastPlay: lastPlay,
                                              image: image,
                                              transcription: transcription,
                                              reviewCount: reviewCount,
                                              tags: tags))
        }
        
        return dataToRecordings
        
    }
    
}
