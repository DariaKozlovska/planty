//
//  WaterCalendar.swift
//  planty-tracker
//
//  Created by Daria Kozlovska on 21/07/2025.
//

import SwiftUI

struct WaterCalendar: View {
    @State private var wateredDates: [Date]
    let plant: Plant

    private var calendar: Calendar {
        var cal = Calendar.current
        cal.firstWeekday = 2
        return cal
    }
    
    private let daysInWeek = 7
    
    @State private var currentMonth: Date = {
        let now = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: now)
        return calendar.date(from: components)!
    }()
    
    @ObservedObject var viewModel: PlantViewModel
    @EnvironmentObject var themeManager: ThemeManager
    @State private var showDatePicker: Bool = false
    @State private var chosenDate: Date?
    @State private var alertMessage: String = ""
    
    init(plant: Plant, viewModel: PlantViewModel) {
        self.plant = plant
        self._wateredDates = State(initialValue: plant.lastWateredDates)
        self.viewModel = viewModel
    }
    
    var body: some View {
        let today = Date()
        let components = calendar.dateComponents([.year, .month], from: currentMonth)
        let firstDayOfMonth = calendar.date(from: components)!
        let range = calendar.range(of: .day, in: .month, for: firstDayOfMonth)!
        let weekday = calendar.component(.weekday, from: firstDayOfMonth)
        let firstWeekdayIndex = (weekday - calendar.firstWeekday + 7) % 7
        let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
        var nextWateringDay: Date {
            let sorted = wateredDates.sorted()
            let last = sorted.last ?? Date()
            return calendar.date(byAdding: .day , value: plant.wateringFrequency, to: last ) ?? Date()
        }

        VStack(spacing: 16) {
            HStack {
                Button(action: {
                    changeMonth(by: -1)
                }) {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .scaledToFit()
                        .padding(6)
                        .frame(width: 26, height: 26)
                        .foregroundColor(themeManager.isDarkMode ? .white : .darkTeal)
                        .background(themeManager.isDarkMode ? .white.opacity(0.3) : Color.darkTeal.opacity(0.3))
                        .cornerRadius(6)
                }
                Spacer()
                Text(calendar.shortMonthSymbols[components.month! - 1] + " \(components.year!)")
                    .font(.headline)
                    .padding(.bottom, 4)
                Spacer()
                Button(action: {
                    changeMonth(by: 1)
                }) {
                    Image(systemName: "chevron.right")
                        .resizable()
                        .scaledToFit()
                        .padding(6)
                        .frame(width: 26, height: 26)
                        .foregroundColor(themeManager.isDarkMode ? .white : .darkTeal)
                        .background(themeManager.isDarkMode ? .white.opacity(0.3) : Color.darkTeal.opacity(0.3))
                        .cornerRadius(6)
                }
            }

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: daysInWeek), spacing: 8) {
                // Dni tygodnia
                ForEach(["Pn", "Wt", "Śr", "Cz", "Pt", "Sb", "N"], id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.secondary)
                }

                // Puste pola przed pierwszym dniem miesiąca
                ForEach(0..<firstWeekdayIndex, id: \.self) { _ in
                    Text("")
                        .frame(height: 40)
                }

                // Dni miesiąca z unikalnym id z prefixem
                ForEach(range.map { "day_\($0)" }, id: \.self) { dayId in
                    let day = Int(dayId.split(separator: "_")[1])!
                    let date = calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth)!

                    VStack {
                        Button(action: {
                            chosenDate = date
                            if wateredDates.contains(where: { calendar.isDate($0, inSameDayAs: date)}){
                                alertMessage = "Czy chcesz usunąć date podlewania dla tego dnia?"
                            } else {
                                alertMessage = "Czy chcesz w tym dniu podleć roślinę?"
                            }
                            showDatePicker = true
                            
                        }){
                            Text("\(day)")
                                .font(.caption)
                                .fontWeight(calendar.isDate(date , inSameDayAs: today) ? .bold : .regular)
                                .foregroundColor(calendar.isDate(date , inSameDayAs: today) ? .blue : .primary)
                        }

                        if wateredDates.contains(where: { calendar.isDate($0, inSameDayAs: date) }) {
                            Image(systemName: "drop.fill")
                                .foregroundColor(.teal)
                        } else if calendar.isDate(date, inSameDayAs: nextWateringDay) {
                            Image(systemName: "drop.fill")
                                .foregroundColor(.teal)
                                .opacity(0.3)
                        } else {
                            Spacer().frame(height: 16)
                        }
                        

                    }
                    .frame(maxWidth: .infinity)
                    .padding(4)
                    .background(calendar.isDate(date, inSameDayAs: today) ? Color.blue.opacity(0.1) : Color.clear)
                    .cornerRadius(6)
                }
            }
        }
        .padding()
        .background(.white.opacity(0.14))
        .cornerRadius(12)
        .onReceive(timer) { _ in
            let now = Date()
            let calendar = Calendar.current
            let currentMonthComponents = calendar.dateComponents([.year, .month], from: currentMonth)
            let nowComponents = calendar.dateComponents([.year, .month], from: now)
            
            if currentMonthComponents.year != nowComponents.year || currentMonthComponents.month != nowComponents.month {
                currentMonth = calendar.date(from: nowComponents)!
            }
        }
        .alert(alertMessage, isPresented: $showDatePicker){
            Button("Nie", role: .cancel){}
            Button("Tak") {
                if let date = chosenDate {
                    let cleanDate = calendar.startOfDay(for: date)
                    
                    if let index = wateredDates.firstIndex(where: { calendar.isDate($0, inSameDayAs: cleanDate) }) {
                        wateredDates.remove(at: index)
                        viewModel.deleteWateredDate(from: plant, at: index)
                    } else {
                        wateredDates.append(cleanDate)
                        wateredDates.sort(by: >)
                        viewModel.wateredPlant(plant: plant, on: cleanDate)
                    }
                }
            }
        }
    }
    
    private func changeMonth(by value: Int) {
        if let newDate = calendar.date(byAdding: .month, value: value, to: currentMonth) {
            currentMonth = newDate
        }
    }
}
