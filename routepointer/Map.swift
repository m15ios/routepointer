//
//  Map.swift
//  routepointer
//
//  Created by Mikhail Petrenko on 06.02.2022.
//

//import Foundation
//import MapKit
import CoreLocation
import UIKit
import MapKit

class Map {
    
    static let hole = Map()
    init(){}
    
    static var selfView: UIViewController?
    
    // array of annotations
    static var points = Array<MKPointAnnotation>()

    static var viewDelegate: ViewControllerDelegate?
    
    func alert(_ title: String, message: String ){
        if Map.selfView != nil {
            Map.selfView?.alertError(title, message: message )
        } else {
            print(title)
            print(message)
        }
    }
    
    func pointsChanged(){
        if Map.viewDelegate != nil {
            Map.viewDelegate?.pointsChanged()
        } else {
            print("pointsChanged")
        }
    }
    
    func addPlacemark(_ addressPlace: String ){
        //addressPlace: String = "Москва Полярная ул. 2"
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(addressPlace) { [self](result, err) in
            if err == nil {
                if let placemarks = result {
                    // TO DO find how get all placemarks!
                    //print( "we get \(placemarks.count) points" )
                    if let placemark = placemarks.first {
                        //self.alert("FOUND", message: placemark.description )
                        guard let placeLocation = placemark.location else {
                            self.alert("Error", message: "Place Location not found" )
                            return
                        }
                        let annotation = MKPointAnnotation()
                        annotation.title = "\(addressPlace)"
                        annotation.coordinate = placeLocation.coordinate
                        self.alert("Point: \(addressPlace)", message: placeLocation.description )
                        Map.points.append(annotation)
                        self.pointsChanged()
                    }
                }
            } else {
                //print("something did wrong in setPlacemark")
                self.alert("Error in Point: \(addressPlace)", message: "something did wrong" )
                print(err)
            }
        }
    }
    
}
