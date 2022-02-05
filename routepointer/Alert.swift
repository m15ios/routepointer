//
//  Alert.swift
//  routepointer
//
//  Created by Mikhail Petrenko on 05.02.2022.
//

import UIKit

extension UIViewController {
    
    func alertAddAddress(_ title: String, placeholder: String, completion: @escaping (String) -> Void ){
        
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let alertOk = UIAlertAction(title: "OK", style: .default) { (action) in
            print( "ok" )
            let textField = alertController.textFields?.first
            guard let text = textField?.text else { return }
            completion( text )
        }
        let alertCancel = UIAlertAction(title: "Cancel", style: .default) { (action) in
            print( "cancel" )
        }
        alertController.addTextField { textField in
            textField.placeholder = placeholder
        }
        alertController.addAction(alertOk)
        alertController.addAction(alertCancel)
        present(alertController, animated: true, completion: nil)
    }
    
    func alertError(_ title: String, message: String ){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertOk = UIAlertAction(title: "OK", style: .default) { (action) in
            print( "error ok" )
        }
        alertController.addAction(alertOk)
        present(alertController, animated: true, completion: nil)
    }
    
}
