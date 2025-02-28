//
//  Extensions.swift
//  NimbusCache
//
//  Created by Vijaysubramani on 26/02/25.
//

import Foundation

public extension Double {
    /// Rounds the double to decimal places value
    func roundedValues(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
