//
//  SearchBar.swift
//  teumsae
//
//  Created by woogie on 2021/11/07.
//
import SwiftUI

struct SearchBar: View {
	@Binding var text: String

	@State private var isEditing = false

	var body: some View {
		HStack {
			Image(systemName: "magnifyingglass")
			TextField("검색", text: $text)
				.padding(7)
				.padding(.horizontal, 25)
				.background(Color.searchBarGray)
				.cornerRadius(8)
				.padding(.horizontal, 10)
				.onTapGesture {
					self.isEditing = true
				}
				.accessibilityElement(children: .ignore)
				.accessibilityLabel(Text("검색어 입력창"))
				.accessibilityValue(Text("\(text)"))

			if isEditing {
				Button(action: {
					self.isEditing = false
					self.text = ""

				}) {
					Image(systemName: "delete.left")
				}
//				.padding()
				.transition(.move(edge: .trailing))
				.animation(.spring(response: 0.25, dampingFraction:1, blendDuration: 1))
			}
		}
	}
}
