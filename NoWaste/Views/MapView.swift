//
//  MapView.swift
//  NoWaste
//
//  Created by Carlos Alberto Lopez Figueroa on 30/04/23.
//

import SwiftUI

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    var locationString: String
    
    func makeUIView(context: Context) -> MKMapView {
        // Create a MapView object
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        // Create a geocoder object
        let geocoder = CLGeocoder()

        // Use the geocoder to convert the location string to a coordinate
        geocoder.geocodeAddressString(locationString) { (placemarks, error) in
            if error == nil, let placemark = placemarks?.first {
                // Add an annotation to the MapView with the coordinate obtained from the geocoder
                let annotation = MKPointAnnotation()
                annotation.coordinate = placemark.location!.coordinate
                annotation.title = locationString
                mapView.addAnnotation(annotation)

                // Set the MapView's region to the location's coordinate to center the map around the location
                let region = MKCoordinateRegion(center: annotation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                mapView.setRegion(region, animated: true)
            }
        }
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        // Update the view if necessary
    }
    
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator()
    }
    
    class MapViewCoordinator: NSObject, MKMapViewDelegate {
        // Implement delegate methods if needed
    }
    
}
