//
//  LocationView.swift
//  teumsae
//
//  Created by seungyeon on 2021/12/11.
//
// ref: https://developer.apple.com/documentation/mapkit/map
// ref: https://swiftwithmajid.com/2020/07/29/using-mapkit-with-swiftui/

import SwiftUI
import MapKit

// TODO: 위치 등록한거 DB에 저장하기. 기존에 등록된 알람 삭제 기능?




struct LocationView: UIViewRepresentable {
	let locationManager = LocationManager()

	func updateUIView(_ mapView: MKMapView, context: Context) {
		print("LocationView: updateUIView")
		let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
		locationManager.locationManager.startUpdatingLocation()
		// 유저의 현재 위치 받아와서 지도 시작
		let latitude: Double = locationManager.locationManager.location?.coordinate.latitude ??  37.532600
		let longitude: Double = locationManager.locationManager.location?.coordinate.longitude ??  127.024612
		let coordinate = CLLocationCoordinate2DMake(latitude,longitude)
		let region = MKCoordinateRegion(center: coordinate, span: span)
		mapView.setRegion(region, animated: true)
	}
    
     func makeUIView(context: Context) -> MKMapView {
		print("LocationView: makeUIView")
		let entireMapViewCoordinator: EntireMapViewCoordinator = EntireMapViewCoordinator(self, locationManager: locationManager)
         
		let myMap = MKMapView(frame: .zero)
		let longPress = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(entireMapViewCoordinator.addAnnotation(gesture:)))
		longPress.minimumPressDuration = 1
		myMap.addGestureRecognizer(longPress)
		myMap.delegate = context.coordinator
		myMap.showsUserLocation = true
		print("LocationView: makeUIView: ", myMap.annotations.count)
            
		return myMap
        }

    func makeCoordinator() -> EntireMapViewCoordinator {
        return EntireMapViewCoordinator(self, locationManager: locationManager)
    }
   

    class EntireMapViewCoordinator: NSObject, MKMapViewDelegate {

        var entireMapViewController: LocationView
        let locationManager: LocationManager

        init(_ control: LocationView, locationManager: LocationManager) {
          self.entireMapViewController = control
          self.locationManager = locationManager
        }


        @objc func addAnnotation(gesture: UIGestureRecognizer) {

            if gesture.state == .ended {

                if let mapView = gesture.view as? MKMapView {
                    let point = gesture.location(in: mapView)
                    let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
                        
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    mapView.addAnnotation(annotation)
                    print("LocationView: addAnnotation ", annotation.coordinate.latitude, annotation.coordinate.longitude)

                    print("LocationView: coreLocation before update ", locationManager.location.latitude, locationManager.location.latitude)
                    
                    locationManager.setCenterLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
                    
                    print("LocationView: coreLocation after update ", locationManager.location.latitude, locationManager.location.latitude)
                    
                }
            }
        }
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
//        LocationView(locationManager: LocationManager())
		LocationView()
    }
}
