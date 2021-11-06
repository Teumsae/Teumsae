//
//  PlusButton.swift
//  teumsae
//
//  Created by Subeen Park on 2021/11/05.
//

import SwiftUI

struct PlusButton: View {
    
    @StateObject var viewRouter: ViewRouter
    let assignedPage: ViewRouter.Page
    
    var sideLength: CGFloat
    
    var body: some View {
        ZStack { // ZSTACK 0
            Circle()
               .foregroundColor(.white)
               .frame(width: sideLength+4, height: sideLength+4)
             Circle()
                .foregroundColor(.mainYellow)
                .frame(width: sideLength, height: sideLength)
                .shadow(radius: 4)
            Image("TabBar/plus")
                .renderingMode(.template)
                .foregroundColor(.white)
                .aspectRatio(contentMode: .fit)
                .frame(width: sideLength, height: sideLength)
         } // END OF ZSTACK 0
        .foregroundColor(
           viewRouter.currentPage == assignedPage ? .mainYellow : .unselectedGray
        )
        .onTapGesture {
            viewRouter.currentPage = assignedPage
        }
    }
}
