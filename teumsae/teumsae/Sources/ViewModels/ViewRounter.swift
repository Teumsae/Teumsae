//
//  ViewRounter.swift
//  teumsae
//
//  Created by Subeen Park on 2021/11/05.
//

import SwiftUI



class ViewRouter: ObservableObject {
    
    @Published var openCreateReview: Bool = false
    
    enum Page {
         case home
         case book
         case search
         case settings
    }
    
    @Published var currentPage: Page = .home
   
}


