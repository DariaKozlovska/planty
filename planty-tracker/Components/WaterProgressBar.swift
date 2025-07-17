//
//  WaterProgressBas.swift
//  planty-tracker
//
//  Created by Daria Kozlovska on 17/07/2025.
//

import SwiftUI

struct WaterProgressBar: View{
    let lastWatered: Date
    let frequency: Int
    
    var body: some View{
        let totalDays = frequency
        let daysSince = Calendar.current.dateComponents([.day], from: lastWatered, to: Date()).day ?? 0
        let progress = min(Double(daysSince) / Double(totalDays), 1.0)
        let daysRemaining = max(totalDays - daysSince, 0)
        
        VStack(alignment: .leading, spacing: 8){
            HStack {
                Text("Ostatnio: \(formattedDate(lastWatered))")
                    .font(.caption)
                    .foregroundColor(.darkTeal)
                Spacer()
                Text(daysRemaining > 0 ?
                     "Za \(daysRemaining) dni" :
                     "Czas podlać!")
                .font(.caption)
                .foregroundColor(daysRemaining > 0 ? .gray : .red)
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 6)

                    Capsule()
                        .fill(daysRemaining > 0 ? Color.green : Color.red)
                        .frame(width: geometry.size.width * CGFloat(progress), height: 6)
                        .animation(.easeInOut(duration: 0.5), value: progress)
                }
            }
            .frame(height: 6)
        }
        .padding(.vertical, 8)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}
