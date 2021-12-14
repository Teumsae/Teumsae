//
//  LocationNotiDetail.swift
//  teumsae
//
//  Created by woogie on 2021/12/15.
//

import SwiftUI
import RealmSwift
import MapKit

struct annotationPoint: Identifiable {
	let id = UUID()
	let coordinate: CLLocationCoordinate2D
}

struct LocationNotiDetailView: View {
	
	@State private var region : MKCoordinateRegion
	let title : String
	let lat, lon :Double
	
	init(title: String, lat: Double, lon:Double){
		self.title = title
		self.lat = lat
		self.lon = lon
		region = MKCoordinateRegion(
			center: CLLocationCoordinate2D(
				latitude: lat,
				longitude: lon
			),
			span: MKCoordinateSpan(
				latitudeDelta: 0.01,
				longitudeDelta: 0.01
			)
		)
	}
    var body: some View {
		Map(
			coordinateRegion: $region,
			annotationItems: [annotationPoint(coordinate: .init(latitude: self.lat, longitude: self.lon))]
		){ point in
//			MapMarker(coordinate: point.coordinate, tint: .green)
			MapAnnotation(
							coordinate: point.coordinate,
							anchorPoint: CGPoint(x: 0.5, y: 0.5)
						) {
							Text(self.title)
							Circle()
								.stroke(Color.red)
								.frame(width: 44, height: 44)
			}
		}
    }
}

//struct LocationNotiDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        LocationNotiDetail()
//    }
//}
