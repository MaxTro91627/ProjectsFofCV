//
//  CalendarView.swift
//  PillBox
//
//  Created by Максим Троицкий
//

import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var dayPlanner: DayPlanner
    var body: some View {
        ScrollView(showsIndicators: false) {
            CustomDatePicker()
        }
        .background(Color(red: 236/255, green: 240/255, blue: 255/255))
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
