//
//  Backgrounds.swift
//  planty-tracker
//
//  Created by Daria Kozlovska on 16/07/2025.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        Image("Background")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
            .frame(minWidth: 0, maxWidth: .infinity)
    }
}

#Preview {
    BackgroundView()
}
