//
//  ImagePicker.swift
//  teumsae
//
//  Created by Subeen Park on 2021/11/08.
//

import SwiftUI

class ImagePicker: ObservableObject {
    
    static let shared = ImagePicker()
    
    var uiImage: UIImage? = nil
    @Published var showImagePicker = false
   
}


