//
// Created by S7epz on 04/08/24.
// Copyright © 2024 ACME.
// All Rights Reserved.


import SwiftUI

struct buttonView: View {
    var labelName: String
    var backgroundColor: Color
    
    var body: some View {
        Text(labelName)
            .frame(width: 280, height: 50)
            .background(backgroundColor)
            .font(.system(size: 20, weight: .medium, design: .default))
            .cornerRadius(10)
    }
}
