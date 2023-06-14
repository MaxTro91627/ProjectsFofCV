//
//  UserView.swift
//  PillBox
//
//  Created by Максим Троицкий
//

import SwiftUI
import iPhoneNumberField

struct UserView: View {
    @EnvironmentObject var dayPlanner: DayPlanner
    @State var userName: String = UserDefaults.standard.string(forKey: "UserName") ?? ""
    @State var userSurname: String = UserDefaults.standard.string(forKey: "UserSurname") ?? ""
    @State var userPhoneNumber: String = UserDefaults.standard.string(forKey: "UserPhoneNumber") ?? ""
    @State var userBirthday: String = UserDefaults.standard.string(forKey: "UserBirthday") ?? ""
    @State var userNameTextField = ""
    @State var userSurnameTextField = ""
    @State var userPhoneNumberTextField = ""
    @State var userBirthdayPicker = Date()
    @State private var isPresentedAdmissionCourse = false
    @State private var isPresentedStatistic = false
    private let dateFormatter = DateFormatter()
    
    init() {
        dateFormatter.dateFormat = "yyyyMMdd"
    }
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView(showsIndicators: false) {
                VStack {
                    Group {
                        HStack {
                            Text("Профиль")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding()
                            Spacer()
                        }
                        HStack {
                            Text("Мои данные")
                                .fontWeight(.bold)
                                .foregroundColor(Color(red: 133/255, green: 133/255, blue: 133/255))
                            Spacer()
                        }
                        .padding()
                        ZStack {
                            TextField("Имя", text: userName == "" ? $userNameTextField : $userName)
                                .foregroundColor(Color(.black))
                            Spacer()
                        }
                        .padding(.horizontal)
                        .onChange(of: userNameTextField) { desc in
                            UserDefaults.standard.set(desc, forKey: "UserName")
                        }
                        Divider()
                            .padding(.horizontal)
                            .padding(.bottom)
                        HStack {
                            TextField("Фамилия", text: userSurname == "" ? $userSurnameTextField : $userSurname)
                                .foregroundColor(Color(.black))
                            Spacer()
                        }
                        .padding(.horizontal)
                        .onChange(of: userSurnameTextField) { desc in
                            UserDefaults.standard.set(desc, forKey: "UserSurname")
                        }
                        Divider()
                            .padding(.horizontal)
                            .padding(.bottom)
                        HStack {
                            DatePicker("Дата рождения", selection: $userBirthdayPicker, in: ...Date(), displayedComponents: .date)
                                .accentColor(Color(red: 73/255, green: 166/255, blue: 169/255))
                                .fontWeight(.semibold)
                                .fontWeight(.semibold)
                                .foregroundColor(Color(red: 133/255, green: 133/255, blue: 133/255))
                        }
                        .padding()
                        .onChange(of: userBirthdayPicker) { desc in
                            let date = dateFormatter.string(from: desc)
                            UserDefaults.standard.set(date, forKey: "UserBirthday")
                        }
                        HStack {
                            iPhoneNumberField("Телефон", text: userPhoneNumber == "" ? $userPhoneNumberTextField : $userPhoneNumber)
                                .prefixHidden(false)
                                .flagSelectable(true)
                                .maximumDigits(10)
                                .clearButtonMode(.whileEditing)
                                .formatted(true)
                        }
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        .onChange(of: userPhoneNumberTextField) { desc in
                            UserDefaults.standard.set(desc, forKey: "UserPhoneNumber")
                        }
                        .onChange(of: userPhoneNumber) { desc in
                            UserDefaults.standard.set(desc, forKey: "UserPhoneNumber")
                        }
                        Divider()
                            .padding(.horizontal)
                            .padding(.bottom)
                    }
                    HStack {
                        Button(action: {
                            isPresentedAdmissionCourse.toggle()
                        }, label: {
                            Text("Курс приема")
                                .foregroundColor(.black)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.black)
                        })
                        .sheet(isPresented: $isPresentedAdmissionCourse) {
                            AdmissionCourse()
                        }
                        .padding()
                    }
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.white)
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        Button(action: {
                            isPresentedStatistic.toggle()
                        }, label: {
                            Text("Статистика")
                                .foregroundColor(.black)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.black)
                        })
                        .sheet(isPresented: $isPresentedStatistic) {
                            StatisticView()
                        }
                        .padding()
                    }
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.white)
                    }
                    .padding(.horizontal)
                    Spacer()
                    Spacer()
                }
                .frame(maxHeight: .infinity)
                
                
                .ignoresSafeArea(.keyboard)
                .ignoresSafeArea(edges: [.top])
                
                .onAppear() {
                    if userBirthday != "" {
                        userBirthdayPicker = dateFormatter.date(from: userBirthday)!
                    } else {
                        userBirthdayPicker = Date()
                    }
                }
            }
            .background(Color(red: 236/255, green: 240/255, blue: 255/255))
            .ignoresSafeArea(.keyboard)
        }
        .background(Color(red: 236/255, green: 240/255, blue: 255/255))
    }
}

struct UserView_Previews: PreviewProvider {
    @EnvironmentObject var dayPlanner: DayPlanner
    static var previews: some View {
        UserView()
    }
}

struct AdmissionCourse: View {
    @EnvironmentObject var dayPlanner: DayPlanner
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                HStack {
                    Spacer()
                    Text("Курс приема")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Spacer()
                }
                .padding()
                Divider()
                if !dayPlanner.pills.isEmpty && !dayPlanner.medicines.isEmpty {
                    ForEach (dayPlanner.medicines, id:\.self) { medicine in
                        if !dayPlanner.pills.filter({ $0.choosedMedicine.medicineName == medicine.medicineName && dayPlanner.setStartOfDay(for: $0.endReceptionDate) >= dayPlanner.getToday()}).isEmpty {
                            HStack {
                                Text("\(medicine.medicineName)")
                                    .foregroundColor(.black)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            .padding(.horizontal)
                            ForEach (dayPlanner.pills, id:\.self) { pill in
                                if pill.choosedMedicine.medicineName == medicine.medicineName {
                                    AdmissionCoursePillView(for: pill)
                                }
                            }
                        }
                    }
                } else if dayPlanner.pills.filter({dayPlanner.setStartOfDay(for: $0.endReceptionDate) >= dayPlanner.getToday()}).isEmpty {
                    VStack(alignment: .center) {
                        Text("У Вас нет текущего курса приема! ")
                        Text("Добавьте его и он отобразится здесь")
                    }
                } else {
                    VStack(alignment: .center) {
                        Text("Создайте новый курс приема и он отобразится здесь")
                    }
                }
            }
        }
        .background(Color(red: 236/255, green: 240/255, blue: 255/255))
    }
}

struct AdmissionCoursePillView: View {
    @EnvironmentObject var dayPlanner: DayPlanner
    @State private var typeList = ["табл.", "шт.", "мл.", "мг.", "гр.", "лож.", "ст. лож."]
    @State private var receptionDatesModeList = ["Каждый день", "Через день", "Дни недели"]
    @State private var week = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
    @State private var receprionModeList = ["До еды", "После еды", "Во время еды"]
    let pill: Pill
    init (for pill: Pill) {
        self.pill = pill
    }
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("\(pill.receptionTime.formatted(.dateTime .hour() .minute()))")
                        .font(.title3)
                        .fontWeight(.bold)
                    Spacer()
                    Text("\(pill.pillQuantity) \(typeList[pill.choosedMedicine.typeOfDosage])")
                }
                .padding(.bottom)
                HStack {
                    if pill.receptionDatesMode != 2 {
                        Text("\(receptionDatesModeList[pill.receptionDatesMode!])")
                    } else if pill.receptionDatesMode == 1 && pill.isTappedWeekday.filter({$0 == true}).count == 7 {
                        Text("\(receptionDatesModeList[0])")
                    } else {
                        Text("По: ")
                            .fontWeight(.bold)
                        ForEach(pill.isTappedWeekday.indices, id:\.self) { weekdayTapped in
                            if pill.isTappedWeekday[weekdayTapped] {
                                Text("\(week[weekdayTapped]) ")
                            }
                        }
                    }
                    Spacer()
                    if pill.receptionMode != 3 && pill.receptionMode != nil {
                        Text("\(receprionModeList[pill.receptionMode!])")
                    }
                }
                .padding(.bottom)
                HStack {
                    Text("C \(pill.startReceptionDate.ddmmyyyy())")
                    Spacer()
                    Text("по \(pill.endReceptionDate.ddmmyyyy())")
                }
            }
            .padding()
            .background() {
                RoundedRectangle(cornerRadius: 25)
                    .fill(.white)
                    .shadow(color: Color.black.opacity (0.08), radius: 5, x: 5, y: 5)
            }
        }
        .padding(.horizontal)
    }
}

struct StatisticView: View {
    @EnvironmentObject var dayPlanner: DayPlanner
    @State var endDate: Date = Date()
    @State var startDate: Date = Date()
    var statisticModes = ["Недели", "Месяца", "Года", "Промежутка"]
    @State private var selectedStatisticMode: Int? = 0
    var body: some View {
        ScrollView(showsIndicators: false) {
            let medicineNames: [String] = getAllNames()
            HStack {
                switch selectedStatisticMode {
                case 0:
                    Text("За последнюю: ")
                        .fontWeight(.bold)
                case 1:
                    Text("За последний: ")
                        .fontWeight(.bold)
                case 2:
                    Text("За последний: ")
                        .fontWeight(.bold)
                case 3:
                    Text("За последний: ")
                        .fontWeight(.bold)
                default:
                    Text("default")
                }
                
                Spacer()
                Picker ("", selection: $selectedStatisticMode) {
                    ForEach (statisticModes, id:\.self) { mode in
                        Text ("\(mode)").tag(statisticModes.firstIndex(of: mode))
                    }
                }
                .tint(Color(red: 73/255, green: 169/255, blue: 166/255))
            }
            .padding()
            
            switch selectedStatisticMode {
            case 0:
                withAnimation(.easeInOut(duration: 0.3)) {
                    ChoosedDatesStatisticView(startDate: dayPlanner.setStartOfDay(for: Calendar.current.date(byAdding: .day, value: -7, to: dayPlanner.getToday())!), endDate: dayPlanner.getToday())
                }
            case 1:
                withAnimation(.easeInOut(duration: 0.3)) {
                    ChoosedDatesStatisticView(startDate: dayPlanner.setStartOfDay(for: Calendar.current.date(byAdding: .month, value: -1, to: dayPlanner.getToday())!), endDate: dayPlanner.getToday())
                }
            case 2:
                withAnimation(.easeInOut(duration: 0.3)) {
                    ChoosedDatesStatisticView(startDate: dayPlanner.setStartOfDay(for: Calendar.current.date(byAdding: .year, value: -1, to: dayPlanner.getToday())!), endDate: dayPlanner.getToday())
                }
            case 3:
                VStack {
                    DatePicker("Начало", selection: $startDate, displayedComponents: .date)
                        .accentColor(Color(red: 73/255, green: 166/255, blue: 169/255))
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 133/255, green: 133/255, blue: 133/255))
                        .onChange(of: startDate) { desc in
                            if startDate > endDate {
                                endDate = startDate
                            }
                        }
                    DatePicker("Конец", selection: $endDate, in: PartialRangeFrom(startDate), displayedComponents: .date)
                        .accentColor(Color(red: 73/255, green: 166/255, blue: 169/255))
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 133/255, green: 133/255, blue: 133/255))
                }
                .padding()
                withAnimation(.easeInOut(duration: 0.3)) {
                    ChoosedDatesStatisticView(startDate: dayPlanner.setStartOfDay(for: startDate), endDate: dayPlanner.setStartOfDay(for: endDate))
                }
            default:
                Text("Default")
            }
            HStack {
                Text("Статистика по таблетке")
                    .font(.title3)
                    .fontWeight(.semibold)
                Spacer()
            }
            .padding(.horizontal)
            ForEach (medicineNames, id:\.self) { name in
                
//                ForEach(dayPlanner.pills, id:\.self) { pill in
//                    if pill.pillName.lowercased() == name.lowercased() {
//                        HStack {
//                            Text("\(pill.pillName)")
//                            Text(name)
//                                .font(.title3)
//                                .padding(.horizontal)
//                            Spacer()
//                            VStack(alignment: .trailing) {
                                switch selectedStatisticMode {
                                case 0:
                                    let pillCount = dayPlanner.countStatisticInRange(from: dayPlanner.setStartOfDay(for: Calendar.current.date(byAdding: .day, value: -7, to: dayPlanner.getToday())!), to: dayPlanner.getToday(), for: name)
                                    if pillCount[1] > 0 {
                                        HStack {
                                            Text(name)
                                                .padding()
                                            Spacer()
                                            VStack(alignment: .trailing) {
                                                HStack {
                                                    Text("Назначено: ")
                                                    Text("\(Int(pillCount[1]))")
                                                        .fontWeight(.bold)
                                                }
                                                HStack {
                                                    Text("Выпито: ")
                                                    Text("\(Int(pillCount[0]))")
                                                        .fontWeight(.bold)
                                                }
                                            }
                                            .padding()
                                        }
                                        .padding(.horizontal)
                                        .background() {
                                            RoundedRectangle(cornerRadius: 25)
                                                .fill(.white)
                                                .padding(.horizontal)
                                                .shadow(color: Color.black.opacity (0.08), radius: 5, x: 5, y: 5)
                                                .frame(maxHeight: 100)
                                        }
                                    }
                                    
                                case 1:
                                    let pillCount = dayPlanner.countStatisticInRange(from: dayPlanner.setStartOfDay(for: Calendar.current.date(byAdding: .month, value: -1, to: dayPlanner.getToday())!), to: dayPlanner.getToday(), for: name)
                                    if pillCount[1] > 0 {
                                        HStack {
                                            Text(name)
                                                .padding()
                                            Spacer()
                                            VStack(alignment: .trailing) {
                                                HStack {
                                                    Text("Назначено: ")
                                                    Text("\(Int(pillCount[1]))")
                                                        .fontWeight(.bold)
                                                }
                                                HStack {
                                                    Text("Выпито: ")
                                                    Text("\(Int(pillCount[0]))")
                                                        .fontWeight(.bold)
                                                }
                                            }
                                            .padding()
                                        }
                                        .padding(.horizontal)
                                        .background() {
                                            RoundedRectangle(cornerRadius: 25)
                                                .fill(.white)
                                                .padding(.horizontal)
                                                .shadow(color: Color.black.opacity (0.08), radius: 5, x: 5, y: 5)
                                                .frame(maxHeight: 100)
                                        }
                                    }
                                case 2:
                                    let pillCount = dayPlanner.countStatisticInRange(from: dayPlanner.setStartOfDay(for: Calendar.current.date(byAdding: .year, value: -1, to: dayPlanner.getToday())!), to: dayPlanner.getToday(), for: name)
                                    if pillCount[1] > 0 {
                                        HStack {
                                            Text(name)
                                                .padding()
                                            Spacer()
                                            VStack(alignment: .trailing) {
                                                HStack {
                                                    Text("Назначено: ")
                                                    Text("\(Int(pillCount[1]))")
                                                        .fontWeight(.bold)
                                                }
                                                HStack {
                                                    Text("Выпито: ")
                                                    Text("\(Int(pillCount[0]))")
                                                        .fontWeight(.bold)
                                                }
                                            }
                                            .padding()
                                        }
                                        .padding(.horizontal)
                                        .background() {
                                            RoundedRectangle(cornerRadius: 25)
                                                .fill(.white)
                                                .padding(.horizontal)
                                                .shadow(color: Color.black.opacity (0.08), radius: 5, x: 5, y: 5)
                                                .frame(maxHeight: 100)
                                        }
                                    }
                                case 3:
                                    let pillCount = dayPlanner.countStatisticInRange(from: dayPlanner.setStartOfDay(for: startDate), to: dayPlanner.setStartOfDay( for: endDate), for: name)
                                    if pillCount[1] > 0 {
                                        HStack {
                                            Text(name)
                                                .padding()
                                            Spacer()
                                            VStack(alignment: .trailing) {
                                                HStack {
                                                    Text("Назначено: ")
                                                    Text("\(Int(pillCount[1]))")
                                                        .fontWeight(.bold)
                                                }
                                                HStack {
                                                    Text("Выпито: ")
                                                    Text("\(Int(pillCount[0]))")
                                                        .fontWeight(.bold)
                                                }
                                            }
                                            .padding()
                                        }
                                        .padding(.horizontal)
                                        .background() {
                                            RoundedRectangle(cornerRadius: 25)
                                                .fill(.white)
                                                .padding(.horizontal)
                                                .shadow(color: Color.black.opacity (0.08), radius: 5, x: 5, y: 5)
                                                .frame(maxHeight: 100)
                                        }
                                    }
                                default:
                                    Text("default")
                                }
                                
//                            }
//                            .padding()
//                        }
//                        .padding(.horizontal)
//                        .background() {
//                            RoundedRectangle(cornerRadius: 25)
//                                .fill(.white)
//                                .padding(.horizontal)
//                                .shadow(color: Color.black.opacity (0.08), radius: 5, x: 5, y: 5)
//                                .frame(maxHeight: 100)
//                        }
//                    }
//                }
            }
        }
        .navigationTitle("Статистика")
        .background(Color(red: 236/255, green: 240/255, blue: 255/255))
    }
    func getAllNames() -> [String] {
        var Names: [String] = []
        for medicine in dayPlanner.medicines {
            if !Names.filter({$0.lowercased() == medicine.medicineName.lowercased()}).isEmpty {
                continue
            }
            Names.append(medicine.medicineName)
        }
        return Names
    }
}

struct ChoosedDatesStatisticView: View {
    @EnvironmentObject var dayPlanner: DayPlanner
    var startDate: Date
    var endDate: Date
    init (startDate: Date, endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
    }
    var body: some View {
        VStack {
            HStack {
                Text("с \(startDate.ddmmyyyy()) по \(endDate.ddmmyyyy())")
                    .padding(.top)
                    .foregroundColor(Color(red: 133/255, green: 133/255, blue: 133/255))
            }
            HStack {
                let progress = dayPlanner.countFullStaticInRange(from: startDate, to: endDate)
                ZStack {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        ProgressBar(progress: progress[0] / progress[1] == 0.0 ? 0.01 : progress[0] / progress[1])
                            .frame(maxWidth: 100, maxHeight: 100)
                            .shadow(color: Color.black.opacity (0.08), radius: 5, x: 0, y: 0)
                    }
                    Text("\(Int(progress[0] / progress[1] * 100))%")
                }
                Spacer()
                VStack(alignment: .trailing) {
                    HStack {
                        Text("Назначено: ")
                        Text("\(Int(progress[1]))")
                            .fontWeight(.bold)
                    }
                    .padding(.bottom)
                    
                    HStack {
                        Text("Выпито: ")
                        Text("\(Int(progress[0]))")
                            .fontWeight(.bold)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .padding()
        .background() {
            RoundedRectangle(cornerRadius: 25)
                .fill(.white)
                .padding()
                .shadow(color: Color.black.opacity (0.08), radius: 5, x: 5, y: 5)
        }
    }
}
