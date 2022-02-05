//
//  ViewController.swift
//  routepointer
//
//  Created by Mikhail Petrenko on 05.02.2022.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {

    let mapView: MKMapView = {
        let mapView = MKMapView()
        // set TAMIC
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray
        setConstraints()
    }


}

extension ViewController {
    
    func setConstraints(){
        // place our mapView
        view.addSubview(mapView)
        // set constraints to full-screen
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
    }
    
}
