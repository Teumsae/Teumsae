//
//  RecordingsHeaderView.swift
//  teumsae
//
//  Created by woogie on 2021/11/06.
//

import SwiftUI

struct RecordingsHeaderView: View {
	
	var body: some View{
		VStack{
			Text("복습하기")
			Spacer()
			VStack{
				Text("검색 아이콘")
				Text("search placeholder")
				Text("microphone Icon")
			}
			RecordingsHeaderStatView()
		}
	}
}

struct RecordingsHeaderStatView: View {
	@State private var progress:Double = 0.8 * 100.0
	
	var body: some View{
		HStack{
			Button(action: {
				print("This is Header Icon")
			}, label: {
				Image(systemName: "repeat.circle")
			})
			Spacer()
			HStack{
				VStack{
					Text("이번 주 복습 성취도 \(Int(progress))%")
					ProgressView(value: progress, total: 100.0)
					Text("총 복습 시간: 2시간")
				}
				
				Spacer()
				
				Image(systemName: "chevron.forward")
			}
			
		}.padding()
	}
}

