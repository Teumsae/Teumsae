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
			ScrollView{
			VStack{
					RecordingsHeaderView()
					Spacer()
					RecordingsList()
			}
			.padding()
			}
        } // END OF NAVIGATION VIEW
		.navigationBarTitle("틈새 복습")
		.navigationBarItems(trailing: EditButton()) //TODO - will be deprecated
    }
}

