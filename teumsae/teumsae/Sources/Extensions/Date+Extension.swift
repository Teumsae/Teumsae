//
//  Date+Extension.swift
//  teumsae
//
//  Created by Subeen Park on 2021/11/03.
//

import Foundation


public extension Date {
    func toString( dateFormat format  : String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
