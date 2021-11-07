//
//  Color+Extension.swift
//  teumsae
//
//  Created by Subeen Park on 2021/11/05.
//

import SwiftUI


extension Color {
    
    static var mainYellow: Color { fetchColor(#function) }
    static var unselectedGray: Color { fetchColor(#function) }
    static var waveBackgroundGray: Color { fetchColor(#function) }
        
    private static func fetchColor(_ name: String) -> Color {
        return Color(name)
    }

}


