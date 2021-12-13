//
//  LaunchView.swift
//  teumsae
//
//  Created by Subeen Park on 2021/11/02.
//


import SwiftUI

struct LaunchView: View {
    
    @StateObject var viewRouter = ViewRouter()
    @StateObject private var locationManager = LocationManager()
    @ObservedObject var audioRecorder = AudioRecorder.shared
    
    @StateObject var motionManager = MotionManager()
    
    var body: some View {
        GeometryReader { geometry in

            VStack(spacing: 0) { // VSTACK 0
                 
                 // VIEWS UNDER TAB
                 Spacer()
                 switch viewRouter.currentPage {
                 case .home:
//                      Text("Home")
                     MotionTestView()
                 case .book:
                     ReviewList()
                 case .search:
                      Text("Search")
                 case .settings:
//                      Text("Settings")
                     SettingsView()
//                     LocationView(locationManager: locationManager)
                  }
                  Spacer()
                 
                 // TAB BAR
                 Divider()
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
//                 .background(Color.white.shadow(radius: 2))
                 
             
             } // END OF VSTACK 0
             .edgesIgnoringSafeArea(.bottom)
             .onAppear {
                 locationManager.validateLocationAuthorizationStatus()
                 motionManager.validateMotionAuthorizationStatus()
             }
             .sheet(isPresented: $viewRouter.openCreateReview, onDismiss: {
                 viewRouter.openCreateReview = false
             }, content: {
                 NewReviewView()
                     .environmentObject(viewRouter)
             })
            
         
        } // END OF GEOMETRY READER
        
    }
}

