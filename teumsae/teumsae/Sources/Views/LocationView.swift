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

/*
struct City: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct LocationView: View {
    @State private var cities: [City] = [
            City(coordinate: .init(latitude: 40.7128, longitude: 74.0060)),
            City(coordinate: .init(latitude: 37.7749, longitude: 122.4194)),
            City(coordinate: .init(latitude: 47.6062, longitude: 122.3321))
    ]

    @State private var userTrackingMode: MapUserTrackingMode = .follow
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.532600,
                                       longitude:     127.024612), // default: Seoul
//        latitudinalMeters: 750,
//        longitudinalMeters: 750
        span: MKCoordinateSpan(
                    latitudeDelta: 10,
                    longitudeDelta: 10
                )
    )
    
    
    func makeUIView(context: Self) -> MKMapView{
        MKMapView(frame: .zero)

    }
    

    func updateUIView(_ view: MKMapView, context: Self) {
        let coordinate = CLLocationCoordinate2D(latitude: 37.532600,
                                               longitude:     127.024612) // default: Seoul
        let span = MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        view.setRegion(region, animated: true)

    }

    var body: some View {
        Map(
            coordinateRegion: $region,
            interactionModes: MapInteractionModes.all,
            showsUserLocation: true,
            userTrackingMode: $userTrackingMode
        )
        Button("zoom") {
            withAnimation {
                region.span = MKCoordinateSpan(
                    latitudeDelta: 100,
                    longitudeDelta: 100
                )
            }
        }
//        Map(coordinateRegion: $region, annotationItems: cities) { city in
//                    MapAnnotation(
//                        coordinate: city.coordinate,
//                        anchorPoint: CGPoint(x: 0.5, y: 0.5)
//                    ) {
//                        Circle()
//                            .stroke(Color.green)
//                            .frame(width: 44, height: 44)
//                    }
//                }
    } //END OF BODY

}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView()
    }
}
 */





struct LocationView: UIViewRepresentable {
    let locationManager: LocationManager
//    let entireMapViewCoordinator: EntireMapViewCoordinator
    
    init(locationManager: LocationManager){
        self.locationManager = locationManager
//        self.entireMapViewCoordinator = EntireMapViewCoordinator(self)
    }
        func updateUIView(_ mapView: MKMapView, context: Context) {
            print("LocationView: updateUIView")
            let span = MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)
            var coordinate = CLLocationCoordinate2D()
            coordinate.latitude = 37.532600
            coordinate.longitude = 127.024612  // default: Seoul
            let region = MKCoordinateRegion(center: coordinate, span: span)
            mapView.setRegion(region, animated: true)
            
            
//            if (mapView.annotations.count > 0){
//                print("LocationView: updateUIView: call updateCoreLocation")
//                self.updateCoreLocation(mapView, context: context)
//            }

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
            print("LocationeView: makeUIView: ", myMap.annotations.count)
            
            return myMap
        }

    func makeCoordinator() -> EntireMapViewCoordinator {
        return EntireMapViewCoordinator(self, locationManager: locationManager)
    }
    
//    func updateCoreLocation(_ mapView: MKMapView, context: Context) {
//        let annotations = mapView.annotations
//
////        if (annotations.endIndex != 0){
//            print("LocationView: coreLocation before update ", locationManager.location.latitude, locationManager.location.latitude)
//
//            let coreLocation = annotations[annotations.endIndex]
//            locationManager.setCenterLocation(latitude: coreLocation.coordinate.latitude, longitude: coreLocation.coordinate.longitude)
//            print("LocationView: coreLocation after update ", locationManager.location.latitude, locationManager.location.latitude)
////        }
////        else{
////            print("LocationView: coreLocation no update ")
////        }
//    }
    

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
        LocationView(locationManager: LocationManager())
    }
}
