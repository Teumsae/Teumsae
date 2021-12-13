//
//  ScreenTimeView.swift
//  teumsae
//
//  Created by woogie on 2021/12/13.
//

import SwiftUI

@available(iOS 15.0, *)
struct ScreenTimeView: View {
	
	private var screenTimeManager: ScreenTimeManager
	
	init(screenTimeManager: ScreenTimeManager){
		self.screenTimeManager = screenTimeManager
	}
	
    var body: some View {
        Text("Hello, Screen Time!")
    }
}

//@available(iOS 15.0, *)
//struct ScreenTimeView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScreenTimeView()
//    }
//}
