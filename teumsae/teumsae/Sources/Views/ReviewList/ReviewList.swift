//
//  ReviewList.swift
//  teumsae
//
//  Created by Subeen Park on 2021/11/06.
//

import SwiftUI

struct ReviewList: View {
    var body: some View {
        NavigationView { // NAVIGATION VIEW
            VStack {
				RecordingsHeaderView()
                RecordingsList()
            }
        } // END OF NAVIGATION VIEW
    }
}

