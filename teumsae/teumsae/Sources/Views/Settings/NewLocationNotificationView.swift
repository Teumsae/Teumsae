//
//  NewLocationNotificationView.swift
//  teumsae
//
//  Created by Subeen Park on 2021/12/14.
//

import SwiftUI
import RealmSwift

struct LocationData {
	var name: String = "Name"
    var loc: Double = 0.0
	var lat: Double = 0.0
}

struct NewLocationNotificationView: View {
	
	@Environment(\.presentationMode) var presentationMode
	@ObservedResults(LocationNotificationGroup.self) var locationGroups
	@StateObject private var locationManager = LocationManager()

	@State private var isLocationError = false;
	@State private var title: String = ""
	@State private var currentDate = Date()
	@State private var lat: Double = 1
	@State private var lon: Double = 1

    var body: some View {
		VStack{
			GroupBox(
				label: Label("위치를 설정해주세요.", systemImage: "tag.fill").foregroundColor(.mainYellow)
			){
				LocationView(locationManager: locationManager, lat: $lat, lon: $lon)
			}
			
			GroupBox(
				label: Label("복습 하고 싶은 장소들의 이름을 정해주세요.", systemImage: "location.magnifyingglass").foregroundColor(.mainYellow)
			){
				TextField(
	 "위치 이름 \(locationGroups.first!.notifications.count + 1)",
					text: $title
				).textInputAutocapitalization(.never)
				 .disableAutocorrection(true)
			}
		}
		
		.navigationBarItems(trailing: Button(action: {
			let realm = try! Realm()
			
			let title = title.isEmpty ? "위치 알림 \(locationGroups.first!.notifications.count + 1)" : title
		
			print("TITLE \(title)")
			print("IS TITLE EMPTY \(title.isEmpty)")
			
			if(!(lat == 1.0 && lon == 1.0)){
				self.locationManager.setCenterLocation(title: title, latitude: lat, longitude: lon)
				try! realm.write {
					guard let locationGroups = locationGroups.thaw() else { return }
					if let locationGroup = locationGroups.first {
						locationGroup.notifications.append(LocationNotification(title: title.isEmpty ? "위치 알림 \(locationGroups.first!.notifications.count + 1)" : title, lat: lat, lon: lon))
						print(locationGroup.notifications.last)
					}
				}
				presentationMode.wrappedValue.dismiss()
			}else{
				isLocationError = true
			}
			
			
			}, label: {
				Text("Done")
			}).alert("지도를 꾹 눌러서 위치를 설정해주세요.",isPresented: $isLocationError){
				Button("닫기", role: .cancel) {}
			} message: {
				Text("1초 동안 지도를 눌러보세요!")
			}
		)
		
	}
	
	
}

struct NewLocationNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NewLocationNotificationView()
    }
}
