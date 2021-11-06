//
//  ViewRounter.swift
//  teumsae
//
//  Created by Subeen Park on 2021/11/05.
//

import SwiftUI



class ViewRouter: ObservableObject {
    
    enum Page {
         case home
         case book
         case search
         case settings
    }
    
    @Published var currentPage: Page = .home
    @Published var openCreateReview = false
   
}


