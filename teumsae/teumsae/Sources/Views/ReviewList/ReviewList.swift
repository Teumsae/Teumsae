//
//  ReviewList.swift
//  teumsae
//
//  Created by Subeen Park on 2021/11/06.
//

import SwiftUI

struct ReviewList: View {
	
	@State var searchKey: String = ""
	
    var body: some View {
		NavigationView { // NAVIGATION VIEW
			List{
				Section(header: Text("복습하기")
							.font(.title3).foregroundColor(.black)
							.padding(.bottom, 5)
							){
					RecordingsHeaderCardView(searchKey: $searchKey).cornerRadius(10)
				}
					
					.buttonStyle(.plain)

				
				
				Section(header:Text("오늘의 복습").font(.title3).foregroundColor(.black).padding(.bottom, 5)){
					RecordingsList(searchKey: $searchKey)
				}
			}
			
        } // END OF NAVIGATION VIEW
    }
}

