//
//  CustomProgressiveView.swift
//  teumsae
//
//  Created by woogie on 2021/11/08.
//

import SwiftUI

struct CustomProgressiveView: View {
	
	private var text: String
	
	init(msg: String){
		self.text = msg
	}
	
    var body: some View {
		VStack {
			Spacer()
			HStack {
				Spacer()
				VStack{
				Text(self.text).font(.title3)
				ProgressView()
					.frame(width: 100, height: 100, alignment: .center)
					.background(Color.white)
					.cornerRadius(10)
				}
				Spacer()
			}
			Spacer()
		}
    }
}

struct CustomProgressiveView_Previews: PreviewProvider {
    static var previews: some View {
		CustomProgressiveView(msg: "Hi")
		
    }
}
