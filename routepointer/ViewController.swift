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

    
    var addAddressBtn: UIButton = UIButton()
    var routeBtn: UIButton = UIButton()
    var resetBtn: UIButton = UIButton()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray
        setMapViewConstraints()
        
        setButtons()
        
        // need for Map
        Map.selfView = self
        Map.viewDelegate = self
        
        // draw polyline route
        mapView.delegate = self
        
        //Map.hole.addPlacemark( "Москва Полярная 2" )
        //Map.hole.addPlacemark( "Москва Лескова 5" )
        //Map.hole.addPlacemark( "Москва Менжинского 7" )

    }

}

extension ViewController {
    
    func setMapViewConstraints(){
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

    /**/
    
    func setButtons(){
        addAddressBtn = makeButton("add adress")
        addAddressBtn.addTarget(self, action: #selector(addAdressBtnTapped), for: .touchUpInside)
        view.addSubview(addAddressBtn)
        setBtnConstraints(addAddressBtn, coord: ["t":50,"r":-10,"h":40,"w":170])
        
        routeBtn = makeButton("route")
        routeBtn.addTarget(self, action: #selector(routeBtnTapped), for: .touchUpInside)
        routeBtn.isHidden = true
        view.addSubview(routeBtn)
        setBtnConstraints(routeBtn, coord: ["b":-40,"r":-10,"h":40,"w":120])

        resetBtn = makeButton("reset")
        resetBtn.addTarget(self, action: #selector(resetBtnTapped), for: .touchUpInside)
        resetBtn.isHidden = true
        view.addSubview(resetBtn)
        setBtnConstraints(resetBtn, coord: ["b":-40,"l":10,"h":40,"w":120])
    }
    
    func setBtnConstraints(_ btn:UIButton,coord:[String:Float]){
        var constr = Array<NSLayoutConstraint>()
        if let _top = coord["t"] {
            constr.append( btn.topAnchor.constraint(equalTo: view.topAnchor, constant: CGFloat(_top)) )
        }
        if let _bottom = coord["b"] {
            constr.append( btn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: CGFloat(_bottom)) )
        }
        if let _right = coord["r"] {
            constr.append( btn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: CGFloat(_right)) )
        }
        if let _left = coord["l"] {
            constr.append( btn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CGFloat(_left)) )
        }
        if let _witdh = coord["w"], let _height = coord["h"] {
            constr.append( btn.heightAnchor.constraint(equalToConstant: CGFloat(_height)) )
            constr.append( btn.widthAnchor.constraint(equalToConstant: CGFloat(_witdh)) )
            // and change a little style :)
            btn.layer.cornerRadius = CGFloat(_height / 3)
        } else {
            return
        }
        NSLayoutConstraint.activate( constr )
    }

    func makeButton(_ title: String) -> UIButton {
        let btn = UIButton()
        btn.setTitle(title, for: .normal)
        btn.backgroundColor = .gray
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }
    
    @objc func addAdressBtnTapped(){
        print( #function )
        alertAddAddress("Add point", placeholder: "Enter address") { pointText in
            //print(pointText)
            Map.hole.addPlacemark( pointText )
        }
    }

    @objc func routeBtnTapped(){
        print( #function )
        route()
    }

    @objc func resetBtnTapped(){
        print( #function )
        Map.hole.clearPoints()
    }
    
    
    private func showPointsOnMap(){
        let points = Map.hole.getPoints()
        //if points.count > 1 {
        mapView.showAnnotations(points, animated: true)
        //}
    }
    
    private func route(){
        let points = Map.hole.getPoints()
        if points.count < 2 {
            alertError("route error", message: "not enough points")
            return
        }
        for index in 0...points.count-2 {
            route2points(points[index].coordinate, points[index+1].coordinate)
        }
    }
    
    private func route2points(_ startPointCoord:CLLocationCoordinate2D,_ finishPointCoord:CLLocationCoordinate2D ){
        
        let startPlacemark = MKPlacemark(coordinate: startPointCoord )
        let startMapItem = MKMapItem(placemark: startPlacemark)
        let finishPlacemark = MKPlacemark(coordinate: finishPointCoord )
        let finishMapItem = MKMapItem(placemark: finishPlacemark)

        let request = MKDirections.Request()
        request.source = startMapItem
        request.destination = finishMapItem
        request.transportType = .walking
        request.requestsAlternateRoutes = true
        
        let directions = MKDirections(request: request)
        directions.calculate { [self](res, err) in
            
            if let error = err {
                self.alertError("route calculate error", message: "see error in console")
                print(error)
                return
            }
            
            guard let responce = res else {
                self.alertError("route calculate error", message: "responce is wrong")
                return
            }
            
            var resRoute = responce.routes[0]
            for route in responce.routes {
                resRoute = (route.distance < resRoute.distance) ? route : resRoute
            }
            
            self.mapView.addOverlay(resRoute.polyline)
            
        }
    }
    
    /**/
    
}

// for draw polyline overlay
extension ViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .red
        return renderer
    }
    
}





protocol ViewControllerDelegate {
    func pointsChanged()
}

extension ViewController: ViewControllerDelegate {
    
    func pointsChanged() {
        print( "pointsChanged viewController" )
        let points = Map.hole.getPoints()
        if points.count > 1 {
            resetBtn.isHidden = false
            routeBtn.isHidden = false
            showPointsOnMap()
        } else {
            resetBtn.isHidden = true
            routeBtn.isHidden = true
        }
    }
    
}

