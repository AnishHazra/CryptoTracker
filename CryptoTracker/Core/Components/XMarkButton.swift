//
//  XMarkButton.swift
//  CryptoTracker
//
//  Created by Anish Hazra on 23/06/25.
//

import SwiftUI

struct XMarkButton: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Button(
            action: {
                presentationMode.wrappedValue.dismiss()
            },
            label: {
                Image(systemName: "xmark")
                    .font(.headline)
            }
        )
    }
}

#Preview {
    XMarkButton()
}
