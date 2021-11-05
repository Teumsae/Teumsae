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
         case review 
    }
    
    @Published var currentPage: Page = .home
   
}


