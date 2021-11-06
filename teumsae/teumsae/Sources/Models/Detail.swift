//
//  Detail.swift
//  teumsae
//
//  Created by 오수민 on 2021/11/06.
//

import Foundation

struct Detail: Identifiable, Codable{
    let id: UUID
    let date: Date
    var transcript: String?
    
    init (id: UUID=UUID(), date: Date = Date(), transcript: String? = nil){
        self.id = id
        self.date = date
        self.transcript = transcript
    }
}
