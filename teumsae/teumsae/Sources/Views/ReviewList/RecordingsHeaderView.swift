//
//  RecordingsHeaderView.swift
//  teumsae
//
//  Created by woogie on 2021/11/06.
//

import SwiftUI

struct ClearButton: ViewModifier {
	@Binding var text: String
   
	public func body(content: Content) -> some View {
		HStack {
			content
			Button(action: {
				self.text = ""
			}) {
				Image(systemName: "multiply.circle")
					.foregroundColor(Color.black)
			}
		}
	}}

struct RecordingsHeaderCardView: View {
	@State private var searchKey: String = ""
	var body: some View{
		VStack(alignment: .leading){
			Spacer()
			Text("복습하기")
				.font(.title)
				
			Spacer(minLength: 30.0)
			HStack{
				Image(systemName: "magnifyingglass").padding(5)
				TextField("검색", text: $searchKey)
					.modifier(ClearButton(text: $searchKey))
					.accessibilityElement(children: .ignore)
					.accessibilityLabel(Text("검색어 입력창"))
					.accessibilityValue(Text("\(searchKey)"))

				
			}.background(Color.searchBarGray).cornerRadius(10)
			Spacer(minLength :30.0)
			RecordingsHeaderStatView()
			
			Spacer()
		}
		.padding(16)
		.background(Color.cardViewBackground)
		.cornerRadius(10)
		.navigationTitle("틈새 복습")
		.navigationBarItems(trailing: Button(action: {}) {
					Image(systemName: "plus")
				})
	}
}

struct RecordingsHeaderStatView: View {
	@State private var progress:Double = 0.8 * 100.0
	
	var body: some View{
		HStack(alignment: .top){
			Button(action: {
				print("This is Header Icon")
			}, label: {
				Image(systemName: "repeat.circle").foregroundColor(.black)
			})
			Spacer()
			HStack{
				VStack(alignment: .leading){
					Text("이번 주 복습 성취도 \(Int(progress))%").font(.headline)
					Text("총 복습 시간: 2시간").font(.footnote).fontWeight(.light)
					ProgressView(value: progress, total: 100.0)
				}
				
				Spacer()
				
				Image(systemName: "chevron.forward")
			}
			
		}
		.padding()
		.background(Color.white)
		.cornerRadius(10)

	}
}

