//
//  UIApplication.swift
//  CryptoTracker
//
//  Created by Anish Hazra on 18/06/25.
//

import Foundation
import SwiftUI

extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
