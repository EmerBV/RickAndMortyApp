//
//  Extensions.swift
//  RickAndMortyApp
//
//  Created by Emerson Balahan Varona on 23/6/23.
//

import UIKit

extension UIView {
    /// Este método permite agregar múltiples subvistas a una vista principal
    func addSubviews(_ views: UIView...) {
        views.forEach({
            addSubview($0)
        })
    }
}

extension UIDevice {
    /// Verificar si el dispositivo actual es un iPhone
    static let isiPhone = UIDevice.current.userInterfaceIdiom == .phone
}
