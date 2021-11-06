//
//  URL+Extension.swift
//  teumsae
//
//  Created by Subeen Park on 2021/11/06.
//

import Foundation


extension URL {
    
    func getCreationDate() -> Date {
        if let attributes = try? FileManager.default.attributesOfItem(atPath: self.path) as [FileAttributeKey: Any],
            let creationDate = attributes[FileAttributeKey.creationDate] as? Date {
            return creationDate
        } else {
            return Date()
        }
    }
}
