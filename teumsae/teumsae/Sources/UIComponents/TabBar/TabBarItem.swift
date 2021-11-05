//
//  TabBarItem.swift
//  teumsae
//
//  Created by Subeen Park on 2021/11/05.`
//

import SwiftUI

struct TabBarItem: View {
    
    @StateObject var viewRouter: ViewRouter
    let assignedPage: ViewRouter.Page
    
    let width, height: CGFloat
    let imageName: String
    
     var body: some View {
         VStack {
             Image("TabBar/\(imageName)")
                 .renderingMode(.template)
                 .resizable()
                 .aspectRatio(contentMode: .fit)
                 .frame(width: width, height: height)
                 .padding(.top, 24)
             Spacer()
         }
         .foregroundColor(
            viewRouter.currentPage == assignedPage ? .mainYellow : .unselectedGray
         )
         .onTapGesture {
             viewRouter.currentPage = assignedPage
         }
     }
    
    
    
}

