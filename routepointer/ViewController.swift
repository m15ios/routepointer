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
        
        Map.selfView = self
        Map.viewDelegate = self
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
    }

    @objc func resetBtnTapped(){
        print( #function )
    }
    
    /**/
    
}


protocol ViewControllerDelegate {
    func pointsChanged()
}

extension ViewController: ViewControllerDelegate {
    
    func pointsChanged() {
        print( "pointsChanged viewController" )
    }
    
}

