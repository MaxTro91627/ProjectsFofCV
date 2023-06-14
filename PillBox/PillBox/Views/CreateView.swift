//
//  CreateView.swift
//  PillBox
//
//  Created by Максим Троицкий
//

import SwiftUI


struct CreateView: View {
    @State private var showChooseView: Bool = true
    @EnvironmentObject var dayPlanner: DayPlanner
    @EnvironmentObject var vm: FileManagerViewModel
    var body: some View {
        VStack {
            HeaderCreateView()
                .padding()
            ChooseView(showChooseView: $showChooseView)
                .padding()
            Spacer()
        }
        .background(Color(red: 236/255, green: 240/255, blue: 255/255))
    }
}



struct HeaderCreateView: View {
    var body: some View {
        HStack {
            Text("Добавление в курс")
                .foregroundColor(.black)
        }
        .font(.title2)
        .fontWeight(.semibold)
    }
}

struct ChooseView: View {
    @EnvironmentObject var vm: FileManagerViewModel
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dayPlanner: DayPlanner
    @State private var pillName: String = ""
    @State private var pillQuantity: String = ""
    @State private var receptionTime = Date()
    @State private var receptionMode: Int?
    @State private var endByOption: Int?
    @State private var startReceptionDate = Date()
    @State private var pillMaxQuantity: String = ""
    @State private var pillMaxDay: String = ""
    @State private var choosedMedicine: Medicine?
    @State private var receptionDatesMode: Int? = 2
    
    @State private var endReceptionDate = Date()
    
    var data = Array([
        "До еды",
        "После еды",
        "Во время еды",
        "Не важно"
    ])
    
    @State private var addButtonTabbed = false
    
    
    @Binding var showChooseView: Bool
    var body: some View {
        
        GeometryReader { geo in
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    HStack {
                        TextField("Выберите лекарство", text: $pillName)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(red: 133/255, green: 133/255, blue: 133/255))
                        
                        Spacer()
                        if dayPlanner.pillName == "" && addButtonTabbed {
                            Image(systemName: "multiply.circle")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.red)
                        }
                    }
                    
                    
                    
                    .padding(.horizontal)
                    ZStack {
                        ScrollView {
                            ForEach(dayPlanner.medicines, id:\.self) { med in
                                if med.medicineName.lowercased().contains("\(pillName.lowercased())") && med.medicineName != pillName{
                                    if !med.isDeleted {
                                        MedicineViewForCreate(for: med)
                                            .onTapGesture {
                                                pillName = med.medicineName
                                                choosedMedicine = med
                                            }
                                            .padding(.horizontal)
                                    }
                                }
                            }
                        }
                        .frame(maxHeight: 220)
                    }
                    .onChange(of: pillName) { desc in
                        dayPlanner.pillName = desc
                        if choosedMedicine != nil {
                            if desc == choosedMedicine!.medicineName {
                                dayPlanner.choosedMedicine = choosedMedicine
                            }
                        } else if dayPlanner.medicines.contains(where: { $0.medicineName == desc }) {
                            dayPlanner.choosedMedicine = dayPlanner.medicines[dayPlanner.medicines.firstIndex(where: {$0.medicineName == desc})!]
                        } else {
                            dayPlanner.choosedMedicine = nil
                        }
                    }
                    
                    Divider()
                        .padding(.bottom)
                    HStack {
                        TextField("Количество", text: $pillQuantity)
                            .keyboardType(.decimalPad)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(red: 133/255, green: 133/255, blue: 133/255))
                        Spacer()
                        if (dayPlanner.pillQuantity == "" || Float(dayPlanner.pillQuantity.replacingOccurrences(of: ",", with: ".", options: .literal, range: nil))! <= 0.0) && addButtonTabbed {
                            Image(systemName: "multiply.circle")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.red)
                        }
                    }
                    .onChange(of: pillQuantity) { desc in
                        dayPlanner.pillQuantity = desc.replacingOccurrences(of: ",", with: ".", options: .literal, range: nil)
                    }
                    .padding(.horizontal)
                    Divider()
                        .padding(.bottom)
                    
                    HStack {
                        Text("Время приема")
                            .fontWeight(.semibold)
                    }
                    .padding(.horizontal)
                    HStack() {
                        DatePicker("", selection: $dayPlanner.receptionTime, displayedComponents: .hourAndMinute)
                            .datePickerStyle(.wheel)
                            .accentColor(Color(red: 73/255, green: 166/255, blue: 169/255))
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    .padding()
                    
                    HStack {
                        Text("Режим приема")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        PickerTextField(data: data, placeholder: "Выберите", lastSelectedIndex: self.$receptionMode)
                            .foregroundColor(.black)
                    }
                    .onChange(of: receptionMode) { desc in
                        dayPlanner.receptionMode = desc
                    }
                    .padding()
                    Divider()
                    Group {
                        HStack {
                            Text("Дни приема")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(Color(red: 133/255, green: 133/255, blue: 133/255))
                            PickerTextField(data: ["Каждый день", "Через день", "Дни недели"], placeholder: "Дни недели", lastSelectedIndex: self.$receptionDatesMode)
                                .foregroundColor(.black)
                        }
                        .padding()
                        .onChange(of: receptionDatesMode) { desc in
                            dayPlanner.receptionDatesMode = desc
                        }
                        if (receptionDatesMode == 2) {
                            WeekChoose()
                                .padding(.horizontal)
                        }
                        Divider()
                        HStack() {
                            DatePicker("Начало", selection: $startReceptionDate, displayedComponents: .date)
                                .accentColor(Color(red: 73/255, green: 166/255, blue: 169/255))
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                        .onChange(of: startReceptionDate) { desc in
                            dayPlanner.startReceptionDate = desc
                            if startReceptionDate > endReceptionDate {
                                endReceptionDate = startReceptionDate
                            }
                        }
                        .padding()
                        Divider()
                        HStack() {
                            Text("Окончание по")
                                .font(.title3)
                                .fontWeight(.semibold)
                            PickerTextField(data: ["Дате", "Кол-во таблеток", "Кол-во дней"], placeholder: "Выберите", lastSelectedIndex: self.$endByOption)
                            if endByOption == nil && addButtonTabbed {
                                Image(systemName: "multiply.circle")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(.red)
                            }
                        }
                        .onChange(of: endByOption) { desc in
                            dayPlanner.endByOption = desc
                        }
                        
                        .padding()
                        Divider()
                        
                        if endByOption != nil {
                            if endByOption == 0 {
                                HStack() {
                                    DatePicker("Конец ", selection: $endReceptionDate, in: PartialRangeFrom(startReceptionDate), displayedComponents: .date)
                                        .accentColor(Color(red: 73/255, green: 166/255, blue: 169/255))
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                }
                                .onChange(of: endReceptionDate) { desc in
                                    dayPlanner.endReceptionDate = desc
                                }
                                .padding()
                                
                                Spacer()
                            } else if endByOption == 1 {
                                HStack {
                                    TextField("Количество таблеток", text: $pillMaxQuantity)
                                        .keyboardType(.decimalPad)
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color(red: 133/255, green: 133/255, blue: 133/255))
                                    Spacer()
                                    if (dayPlanner.pillMaxQuantity == "" || Float(dayPlanner.pillMaxQuantity.replacingOccurrences(of: ",", with: ".", options: .literal, range: nil))! <= 0) && addButtonTabbed {
                                        Image(systemName: "multiply.circle")
                                            .resizable()
                                            .frame(width: 25, height: 25)
                                            .foregroundColor(.red)
                                    }
                                }
                                .onChange(of: pillMaxQuantity) { desc in
                                    dayPlanner.pillMaxQuantity = desc.replacingOccurrences(of: ",", with: ".", options: .literal, range: nil)
                                }
                                .padding()
                                Spacer()
                            } else if endByOption == 2 {
                                HStack {
                                    TextField("Количество дней", text: $pillMaxDay)
                                        .keyboardType(.decimalPad)
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color(red: 133/255, green: 133/255, blue: 133/255))
                                    Spacer()
                                    if (dayPlanner.pillMaxDay == "" || Float(dayPlanner.pillMaxDay.replacingOccurrences(of: ",", with: ".", options: .literal, range: nil))! <= 0) && addButtonTabbed {
                                        Image(systemName: "multiply.circle")
                                            .resizable()
                                            .frame(width: 25, height: 25)
                                            .foregroundColor(.red)
                                    }
                                }
                                .onChange(of: pillMaxDay) { desc in
                                    dayPlanner.pillMaxDay = desc
                                }
                                .padding()
                                Spacer()
                            }
                        }
                    }
                }
                Spacer()
                
                HStack {
                    Button(action: {}) {
                        Text("Отменить")
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .background(Color(red: 190/255, green: 190/255, blue: 190/255))
                            .cornerRadius(15)
                            .onTapGesture {
                                presentationMode.wrappedValue.dismiss()
                            }
                    }
                    .padding(.leading)
                    Spacer()
                    Button(action: {
                        if (dayPlanner.pillName != "" &&
                            (dayPlanner.pillMaxDay != "" && dayPlanner.endByOption == 2 && Float(dayPlanner.pillMaxDay)! > 0 ||
                             dayPlanner.pillMaxQuantity != "" && dayPlanner.endByOption == 1 && Float(dayPlanner.pillMaxQuantity)! > 0 ||
                             dayPlanner.endByOption == 0) && dayPlanner.pillQuantity != "" && Float(dayPlanner.pillQuantity)! > 0) {
                            self.addButtonTabbed = false
                            if (dayPlanner.choosedMedicine == nil) {
                                let calendar = Calendar.current
                                dayPlanner.medicineName = pillName
                                dayPlanner.expirationDate = calendar.date(byAdding: .day, value: 365, to: Date())!
                                dayPlanner.restOfMedicine = "20"
                                dayPlanner.medicineIcon = "more"
                                dayPlanner.typeOfDosage = 1
                                dayPlanner.createMedicine()
                                choosedMedicine = dayPlanner.lastAddedMedicine
                                dayPlanner.choosedMedicine = choosedMedicine
                            }
                            dayPlanner.createPill(someDate: startReceptionDate)
                            presentationMode.wrappedValue.dismiss()
                            vm.savePill(pill: dayPlanner.lastAddedPill!)
                            vm.saveMedicine(medicine: dayPlanner.lastAddedPill!.choosedMedicine)
                        } else {
                            self.addButtonTabbed = true
                        }
                    }) {
                        Text("Добавить")
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .background(Color(red: 73/255, green: 169/255, blue: 166/255))
                            .cornerRadius(15)
                        
                    }
                    .padding(.trailing)
                    
                }
            }
        }
        .onAppear {
            startReceptionDate = dayPlanner.currentDate
        }
    }
    
}

struct WeekChoose: View {
    @EnvironmentObject var dayPlanner: DayPlanner
    let week = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
    var body: some View {
        
        ZStack{
            RoundedRectangle(cornerRadius: 15)
                .fill(.white)
                .frame(width: .infinity, height: 50)
            
            HStack {
                ForEach(0..<7) { i in
                    Spacer()
                    Text(week[i])
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .background(
                            ZStack{
                                Circle()
                                    .fill(dayPlanner.isTappedWeekday[i] ? Color(red: 177/255, green: 169/255, blue: 247/255) : .white)
                                    .frame(width: 40, height: 40)
                            }
                                .onTapGesture {
                                    dayPlanner.changeWeekdayTapped(in: i)
                                }
                        )
                    Spacer()
                }
            }
        }
    }
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView()
    }
}

struct PillField: View {
    @EnvironmentObject var dayPlanner: DayPlanner
    @State private var pillName: String = ""
    
    init(_ pillName: String) {
        _pillName = State(initialValue: pillName)
    }
    
    var body: some View {
        HStack {
            TextField("Выберите лекарство", text: $pillName)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(Color(red: 133/255, green: 133/255, blue: 133/255))
        }
        .onChange(of: pillName) { desc in
            dayPlanner.pillName = desc
        }
    }
}

struct MedicineViewForCreate: View {
    private var medicine: Medicine
    @EnvironmentObject var dayPlanner: DayPlanner
    @State private var typeList = ["табл.", "шт.", "мл.", "мг.", "гр.", "лож.", "ст. лож."]
    @State private var offset: CGFloat = 0
    @State private var isSwiped = false
    init (for medicine: Medicine) {
        self.medicine = medicine
    }
    
    var body: some View {
        ZStack {
            HStack {
                VStack(alignment: .leading) {
                    HStack{
                        Image("\(medicine.medicineIcon)")
                            .resizable()
                            .frame(maxWidth: 30, maxHeight: 30)
                        Text("\(medicine.medicineName)")
                    }
                    Text("Годен до: \(medicine.expirationDate.monthYYYY())")
                        .font(.caption)
                        .foregroundColor(medicine.expirationDate < Calendar.current.date(byAdding: .day, value: 14, to: Date())! ? .red : .black)
                }
                Spacer()
                Text("\(medicine.restOfMedicine) \(typeList[0])")
                    .foregroundColor(Float(medicine.restOfMedicine)! / Float(medicine.totalMedicine)! <= 0.2 ? .red : .black)
            }
            .padding()
            .background() {
                RoundedRectangle(cornerRadius: 25)
                    .fill(.white)
                    .shadow(color: Color.black.opacity (0.08), radius: 5, x: 5, y: 5)
            }
        }
        
    }
}
