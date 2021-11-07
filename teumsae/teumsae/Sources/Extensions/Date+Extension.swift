//
//  Date+Extension.swift
//  teumsae
//
//  Created by Subeen Park on 2021/11/03.
//

import Foundation


extension Date: CustomStringConvertible {
    
    func toString( dateFormat format  : String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        return dateFormatter.string(from: self)
    }
    
    var description: String {
        return "\(self.toString(dateFormat: "YYYY.MM.dd hh:mm:ss a"))"
    }
}
