//
//  ScreenTimeManager.swift
//  teumsae
//
//  Created by woogie on 2021/12/13.
//

import Foundation
import FamilyControls

@available(iOS 15.0, *)
class ScreenTimeManager: NSObject, ObservableObject {
	
	private let authCenter = AuthorizationCenter.shared
	
	
	override init(){
		super.init()
		self.requestFamilyControlAuth()
	}

	private func requestFamilyControlAuth() {
		print("Family Control: request Authorization")
	
		authCenter.requestAuthorization { result in
			switch result {
			case .success():
				print("success!!")
				
			case .failure(let error):
				print("failed!!", error)
				
				
			}

			
		}
		
	}
	

}
