//
//  LaunchView.swift
//  teumsae
//
//  Created by Subeen Park on 2021/11/02.
//


import SwiftUI

struct LaunchView: View {
    
    @StateObject var viewRouter = ViewRouter()
    @ObservedObject var audioRecorder = AudioRecorder.shared
    
    var body: some View {
        
        GeometryReader { geometry in
            
             VStack { // VSTACK 0
                 
                 // VIEWS UNDER TAB
                 Spacer()
                 switch viewRouter.currentPage {
                 case .home:
                      Text("Home")
                 case .book:
                     ReviewList()
                 case .search:
                      Text("Search")
                 case .settings:
                      Text("Settings")
                  }
                  Spacer()
                 
                 // TAB BAR
                 HStack { // HSTACK 0
                     TabBarItem(viewRouter: viewRouter, assignedPage: .home, width: geometry.size.width/6 , height: geometry.size.height/28, imageName: "home")
                     TabBarItem(viewRouter: viewRouter, assignedPage: .book, width: geometry.size.width/6, height: geometry.size.height/28, imageName: "book")

                     // ADD BUTTON
                     PlusButton(viewRouter: viewRouter, sideLength: geometry.size.width/7)
                         .offset(y: -6)
                     
                     TabBarItem(viewRouter: viewRouter, assignedPage: .search, width: geometry.size.width/6, height: geometry.size.height/28, imageName: "search")
                     TabBarItem(viewRouter: viewRouter, assignedPage: .settings, width: geometry.size.width/6, height: geometry.size.height/28, imageName: "settings")
                 } // END OF HSTACK 0
                 .frame(width: geometry.size.width, height: geometry.size.height/8)
                 .background(Color.white.shadow(radius: 2))
                 
             
             } // END OF VSTACK 0
             .edgesIgnoringSafeArea(.bottom)
             .sheet(isPresented: $viewRouter.openCreateReview, onDismiss: {
                 viewRouter.openCreateReview = false
             }, content: {
                 NewReviewView()
             })
            
         
        } // END OF GEOMETRY READER
        
    }
}

