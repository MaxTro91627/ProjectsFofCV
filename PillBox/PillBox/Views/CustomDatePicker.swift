//
//  CustomDatePicker.swift
//  PillBox
//
//  Created by Максим Троицкий
//

import SwiftUI

struct CustomDatePicker: View {
    @EnvironmentObject var dayPlanner: DayPlanner
    @Environment(\.presentationMode) var presentationMode
    @State var currentDate = Date()
    @State var currentMonth: Int = 0
    var body: some View {
        VStack(spacing: 35) {
            
            let days = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("\(extraDate()[0])")
                        .font(.callout)
                        .fontWeight(.semibold)
                    Text("\(extraDate()[1])")
                        .font(.title)
                }
                Spacer()
                Button {
                    withAnimation {
                        currentMonth -= 1
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(Color(red: 73/255, green: 169/255, blue: 166/255))
                    
                }
                
                Button {
                    withAnimation {
                        currentMonth += 1
                    }
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                        .foregroundColor(Color(red: 73/255, green: 169/255, blue: 166/255))
                }
            }
            .padding(.horizontal)
            HStack(spacing: 0) {
                ForEach(days, id: \.self) { day in
                    Text("\(day)")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
            }
            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(extractDate()) { value in
                    ZStack {
                        CardView(value: value)
                            .frame(maxWidth: 40)
                            .onTapGesture {
                                dayPlanner.setCurrentDate(to: Calendar.current.date(byAdding: .day, value: 1, to: value.date)!)
                                presentationMode.wrappedValue.dismiss()
                            }
                    }
                }
            }
            Spacer()
        }
        .onChange(of: currentMonth) { newValue in
            currentDate = getCurrentMonth()
        }
    }
    
    func CardView(value: DateValue) -> some View {
        ZStack {
            if value.day != -1 {
                let progress = dayPlanner.countProgress(date: Calendar.current.date(byAdding: .day, value: 1, to: value.date)!)
                if (progress == 1.0) {
                    Circle()
                        .fill(RadialGradient(
                            gradient: Gradient(colors: [Color(UIColor(red: 73/255, green: 169/255, blue: 166/255, alpha: 0.7)), Color(UIColor(red: 73/255, green: 169/255, blue: 166/255, alpha: 0.5))]),
                            center: UnitPoint(x: 0.5, y: 0.5),
                            startRadius: 15,
                            endRadius: 2
                        ))
                        .frame(width: 40)
                } else {
                    ProgressBarCalendar(progress: progress)
                        .frame(width: 40)
                }
                Text("\(value.day)")
                    .font(.title3)
                    .foregroundColor( progress == 1 ? .white : .black)
            }
        }
        
    }
    
    func extraDate() -> [String] {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "YYYY MMMM"
        let date = formatter.string(from: currentDate)
        return date.components(separatedBy: " ")
    }
    
    func getCurrentMonth() -> Date {
        let calendar = Calendar.current
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: dayPlanner.currentDate) else {
            return dayPlanner.currentDate
        }
        return currentMonth
    }
    
    func extractDate() -> [DateValue] {
        let calendar = Calendar.current
        let currentMonth = getCurrentMonth()
        var days = currentMonth.getAllDates().compactMap { date -> DateValue in
            let day = calendar.component(.day, from: date)
            return DateValue(day: day, date: date)
        }
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? dayPlanner.currentDate)
        for _ in 0..<dayPlanner.getIdxOfWeekday(for: days.first!.date) + 6 % 7{
            days.insert(DateValue(day: -1, date: dayPlanner.currentDate), at: 0)
        }
        if days[6].day == -1 {
            for _ in 0...6 {
                days.remove(at: 0)
            }
        }
        
        return days
    }
}

struct CustomDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        CustomDatePicker()
    }
}

struct ProgressBarCalendar: View {
    var progress: Float
    var color: Color = Color(UIColor(red: 73/255, green: 169/255, blue: 166/255, alpha: 0.7))
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(Color.white)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 5.5, lineCap: .round, lineJoin: .round))
                .foregroundColor(color)
                .rotationEffect(Angle(degrees: 270))
        }
    }
}
