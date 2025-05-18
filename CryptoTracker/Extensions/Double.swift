//
//  Double.swift
//  CryptoTracker
//
//  Created by Anish Hazra on 18/05/25.
//

import Foundation


extension Double {
    
    /// Converts a Double  into a Currency with 2-6 decimal places
    /// ```
    /// Convert 123.35345 to $1,232.67
    /// ```
    private var currencyFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
//        formatter.locale = .current
        formatter.currencyCode = "USD"
        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        return formatter
    }
    
    /// Converts a Double  into a Currency as a String 2-6 decimal places
    /// ```
    /// Convert 123.35345 to "$1,232.67"
    /// ```
    func asCurrencyWith6Decimals() -> String {
        let number = NSNumber(value: self)
        return currencyFormatter.string(from: number) ?? "$0.00"
    }
    
    /// Converts a Double  into a string representation
    /// ```
    /// Convert 123.35345 to "1.23"
    /// ```
    func asNumberString() -> String {
        return String(format: "%.2f", self)
    }
    
    /// Converts a Double  into a string representation with percent symbol
    /// ```
    /// Convert 123.35345 to "1.23%"
    /// ```
    func asPercentString() -> String {
        return asNumberString() + "%"
    }
    
}
