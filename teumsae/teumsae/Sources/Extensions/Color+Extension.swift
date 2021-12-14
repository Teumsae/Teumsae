//
//  Color+Extension.swift
//  teumsae
//
//  Created by Subeen Park on 2021/11/05.
//

import SwiftUI


extension Color {
    
    static var mainYellow: Color { fetchColor(#function) }
    static var subYellow: Color { fetchColor(#function) }
    static var subOrange: Color { fetchColor(#function) }
    
    static var subBlack: Color { fetchColor(#function) }
    static var unselectedGray: Color { fetchColor(#function) }
	static var cardViewBackground: Color{ fetchColor(#function)}
	static var searchBarGray: Color{fetchColor(#function) }
    
    
    static var sectionHeaderBlack: Color{fetchColor(#function) }
    static var badgeTextGray: Color{fetchColor(#function) }
    static var badgeBackgroundGray: Color{fetchColor(#function) }
		
    static var backgroundGray: Color { fetchColor(#function) }
    static var placeHolderGray: Color { fetchColor(#function) }
        
    private static func fetchColor(_ name: String) -> Color {
        return Color(name)
    }

}


