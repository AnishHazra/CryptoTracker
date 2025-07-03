//
//  String.swift
//  CryptoTracker
//
//  Created by Anish Hazra on 03/07/25.
//

import Foundation

extension String {
    
    
    var removingHTMLOccurrences: String {
        return self.replacingOccurrences(
            of: "<[^>]+>",
            with: "",
            options: .regularExpression,
            range: nil
        )
    }
}
