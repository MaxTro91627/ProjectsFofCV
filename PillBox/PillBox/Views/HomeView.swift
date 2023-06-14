//
//  HomeView.swift
//  PillBox
//
//  Created by Максим Троицкий
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var dayPlanner: DayPlanner
    @EnvironmentObject var vm: FileManagerViewModel
    var tapped = false
    @State var isSwipedWeek = 0
    @State var isPresentedCalendar = false
    @State var isPresentedSettings = false
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    NavigationLink(destination: SettingsView()
                        .environmentObject(dayPlanner)) {
                        Image(systemName: "gear")
                            .font(.title)
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color(red: 73/255, green: 169/255, blue: 166/255))
                    }
                    .environmentObject(dayPlanner)
                    
                    Spacer()
                    Text(dayPlanner.currentDate.monthYYYY())
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    Spacer()
                    HStack {
                        Button(action: {
                            self.isPresentedCalendar.toggle()
                        }) {
                            Image(systemName: "calendar")
                                .foregroundColor(Color(red: 73/255, green: 169/255, blue: 166/255))
                                .font(.title)
                        }
                        .sheet(isPresented: $isPresentedCalendar) {
                            GeometryReader { geo in
                                CalendarView()
                                    .presentationDetents([.medium])
                                    .padding()
                                    .background(Color(red: 236/255, green: 240/255, blue: 255/255))
                            }
                        }
                    }
                }
                .padding()
                
                GeometryReader() { geo in
                    HStack {
                        WeekView(of: dayPlanner.startDateOfWeek(from: Calendar.current.date(byAdding: .day, value: 7 * isSwipedWeek, to: dayPlanner.currentDate)!), viewPosition: .centerView)
                            .gesture(DragGesture()
                                .onEnded() { value in
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        if value.translation.width < 0 {
                                            if -value.translation.width > UIScreen.main.bounds.width / 2 {
                                                isSwipedWeek = 1
                                            }
                                        } else {
                                            if value.translation.width > UIScreen.main.bounds.width / 2 {
                                                isSwipedWeek = -1
                                            }
                                        }
                                    }
                                }
                            )
                            .onChange(of: isSwipedWeek) { desc in
                                isSwipedWeek = 0
                            }
                    }
                }
                .frame(maxHeight: 70)
                .padding(.bottom)
                HStack() {
                    Text("Список лекарств")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    Spacer()
                    addAdmissionButton()
                }
                .padding(.horizontal)
                DayView()
            }
            .background(Color(red: 236/255, green: 240/255, blue: 255/255))
            .environmentObject(dayPlanner)
        }
    }
}

enum ViewPosition {
    case centerView
    case previousView
    case nextView
}

struct WeekView: View {
    @EnvironmentObject var dayPlanner: DayPlanner
    let date: Date
    let week = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
    var viewPosition = ViewPosition.centerView
    
    init(of date: Date, viewPosition: ViewPosition) {
        self.date = date
        self.viewPosition = viewPosition
    }
    
    var body: some View {
        let datesInAWeek = dayPlanner.datesInAWeek(from: date)
        HStack {
            Spacer()
            ForEach (datesInAWeek.indices, id:\.self) { i in
                let d = datesInAWeek[i]
                VStack {
                    Text(week[i])
                        .fontWeight(.bold)
                        .foregroundColor(dayPlanner.isCurrent(d) ? .white : dayPlanner.isToday(d) ? Color(red: 177/255, green: 169/255, blue: 247/255): .black)
                        .background(
                            ZStack{
                                if dayPlanner.isCurrent(d) {
                                    Circle()
                                        .fill(dayPlanner.isToday(d) ? Color(red: 177/255, green: 169/255, blue: 247/255): Color(red: 142/255, green: 144/255, blue: 153/255))
                                        .frame(width: 35, height: 35)
                                }
                            }
                        )
                    
                    ZStack {
                        let progress = dayPlanner.countProgress(date: d)
                        if (progress == 1.0) {
                            Circle()
                                .fill(RadialGradient(
                                    gradient: Gradient(colors: [Color(UIColor(red: 73/255, green: 169/255, blue: 166/255, alpha: 0.7)), Color(UIColor(red: 73/255, green: 169/255, blue: 166/255, alpha: 0.5))]),
                                    center: UnitPoint(x: 0.5, y: 0.5),
                                    startRadius: 15,
                                    endRadius: 2
                                ))
                                .frame(width: 50)
                        } else {
                            ProgressBar(progress: progress)
                                .frame(width: 50)
                        }
                        Text(d.dayNum())
                            .fontWeight(.light)
                            .foregroundColor(progress == 1 ? .white : .black)
                    }
                }
                .onTapGesture {
                    dayPlanner.setCurrentDate(to: d)
                }
                Spacer()
            }
        }
        
        .onChange(of: date) { d in
            if viewPosition == .centerView {
                let position = dayPlanner.currentPositionInWeek()
                let datesInAWeek = dayPlanner.datesInAWeek(from: d)
                dayPlanner.setCurrentDate(to: datesInAWeek[position])
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



struct addAdmissionButton: View {
    @State private var isPresented = false
    var body: some View {
        Button(action: {
            self.isPresented.toggle()
        }) {
            
            Image(systemName: "plus")
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(Color(red: 177/255, green: 169/255, blue: 247/255))
        }
        .sheet(isPresented: $isPresented) {
            CreateView()
                .background(Color(red: 236/255, green: 240/255, blue: 255/255))
        }
        .background(Color(red: 236/255, green: 240/255, blue: 255/255))
    }
}

struct DayView: View {
    
    @State var progressValue: Float = 0.3
    
    @State private var tapped = false
    @State private var somePill: Pill?
    @EnvironmentObject var dayPlanner: DayPlanner
    var body: some View {
        ZStack {
            RoundedRectangle (cornerRadius: 25)
                .fill (Color(red: 236/255, green: 240/255, blue: 255/255))
            ScrollView {
                VStack {
                    ForEach(dayPlanner.pills, id:\.self) { pill in
                        if dayPlanner.currentDate >= pill.startReceptionDate && dayPlanner.currentDate <= pill.endReceptionDate {
                            if (pill.receptionDatesMode == 0 || pill.receptionDatesMode == 1) && pill.receptionDates.contains(dayPlanner.currentDate) || pill.receptionDatesMode == 2 && pill.isTappedWeekday[(dayPlanner.getIdxOfWeekday(for: dayPlanner.currentDate) + 6) % 7] {
                                Button (action: {
                                    dayPlanner.allOtherNotTabbed(except: pill)
                                    dayPlanner.toggleTabbed(for: pill)
                                }, label: {
                                    PillView(for: pill)
                                })
                                .foregroundColor(.black)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
            }
            ForEach(dayPlanner.pills, id:\.self) { pill in
                if pill.pillTabbed {
                    PillDescriptionView(pill: pill)
                }
            }
        }
    }
    
}

struct PillDescriptionView: View {
    @EnvironmentObject var vm: FileManagerViewModel
    @EnvironmentObject var dayPlanner: DayPlanner
    private var pill: Pill
    init(pill: Pill) {
        self.pill = pill
    }
    @State private var typeList = ["табл.", "шт.", "мл.", "мг.", "гр.", "лож.", "ст. лож."]
    @State private var isPresented = false
    var body: some View {
        VStack {
            HStack {
                // По этой кнопке открывается инструкция
                Button (action: {
                    self.isPresented.toggle()
                }, label: {
                    Image(systemName: "info.circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(.top, 10)
                        .padding(.leading, 10)
                        .foregroundColor(Color(red: 177/255, green: 169/255, blue: 247/255))
                })
                Spacer()
                Button (action: {
                    dayPlanner.toggleTabbed(for: pill)
                }, label: {
                    Image(systemName: "multiply")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .padding(.top, 10)
                        .padding(.trailing, 10)
                        .foregroundColor(Color(red: 177/255, green: 169/255, blue: 247/255))
                })
            }
            .padding(.horizontal)
            .padding(.top, 10)
            Divider()
            HStack {
                Spacer()
                VStack {
                    Image("\(pill.choosedMedicine.medicineIcon)")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(Color(red: 73/255, green: 169/255, blue: 166/255))
                    Text("\(pill.pillName)")
                        .font(.title)
                }
                Spacer()
            }
            .padding(.horizontal)
            Group {
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(Color(red: 133/255, green: 133/255, blue: 133/255))
                    Text("Запланировано на \(pill.receptionTime.formatted(.dateTime .hour() .minute())), \(dayPlanner.currentDate.formatted(.dateTime .day() .month()))")
                        .foregroundColor(Color(red: 133/255, green: 133/255, blue: 133/255))
                    Spacer()
                }
                .padding(.top, 2)
                .padding(.horizontal)
                HStack {
                    Image(systemName: "pills.fill")
                        .foregroundColor(Color(red: 133/255, green: 133/255, blue: 133/255))
                    Text("\(pill.pillQuantity) \(typeList[pill.choosedMedicine.typeOfDosage])")
                        .foregroundColor(Color(red: 133/255, green: 133/255, blue: 133/255))
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 8)
                HStack {
                    Image(systemName: "carrot.fill")
                        .foregroundColor(Color(red: 133/255, green: 133/255, blue: 133/255))
                    if pill.receptionMode == nil {
                        Text("Не важно")
                            .foregroundColor(Color(red: 133/255, green: 133/255, blue: 133/255))
                    } else if pill.receptionMode == 0 {
                        Text("До еды")
                            .foregroundColor(Color(red: 133/255, green: 133/255, blue: 133/255))
                    } else if pill.receptionMode == 1 {
                        Text("Во время еды")
                            .foregroundColor(Color(red: 133/255, green: 133/255, blue: 133/255))
                    } else {
                        Text("После еды")
                            .foregroundColor(Color(red: 133/255, green: 133/255, blue: 133/255))
                    }
                    Spacer()
                }
                
                .padding(.horizontal)
                .padding(.top, 8)
                if pill.acceptedAt.contains(dayPlanner.currentDate) {
                    Text("Принято")
                        .font(.title3)
                        .fontWeight(.light)
                        .foregroundColor(.green)
                } else if Date().formatted(.dateTime .hour() .minute()) > pill.receptionTime.formatted(.dateTime .hour() .minute()) {
                    Text("Пропущено")
                        .font(.title3)
                        .fontWeight(.light)
                        .foregroundColor(.red)
                }
                Divider()
                Spacer()
                HStack {
                    Spacer()
                    Button (action: {
                        if pill.acceptedAt.contains(dayPlanner.currentDate) {
                            dayPlanner.removeFromAcceptedDay(for: pill, date: dayPlanner.currentDate)
                            dayPlanner.increaseNumberOfMedicine(for: pill)
                        }
                        dayPlanner.toggleTabbed(for: pill)
                        vm.rewritePill(pill: dayPlanner.pills[dayPlanner.pills.firstIndex(where: {$0.id == pill.id})!])
                        vm.rewriteMedicine(medicine: dayPlanner.medicines[dayPlanner.medicines.firstIndex(where: {$0.id == pill.choosedMedicine.id})!])
                    }, label: {
                        VStack {
                            Image(systemName: "multiply.circle")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(Color(red: 177/255, green: 169/255, blue: 247/255))
                            Text("Пропущено")
                        }
                    })
                    .foregroundColor(.black)
                    Spacer()
                    Button (action: {
                        if !pill.acceptedAt.contains(dayPlanner.currentDate) {
                            dayPlanner.addAcceptedDay(to: pill, date: dayPlanner.currentDate)
                            dayPlanner.reduceNumberOfMedicine(for: pill)
                        }
                        dayPlanner.toggleTabbed(for: pill)
                        vm.rewritePill(pill: dayPlanner.pills[dayPlanner.pills.firstIndex(where: {$0.id == pill.id})!])
                        vm.rewriteMedicine(medicine: dayPlanner.medicines[dayPlanner.medicines.firstIndex(where: {$0.id == pill.choosedMedicine.id})!])
                    }, label: {
                        VStack {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(Color(UIColor(red: 73/255, green: 169/255, blue: 166/255, alpha: 0.7)))
                            Text("Принято")
                        }
                    })
                    .foregroundColor(.black)
                    Spacer()
                }
            }
            Spacer()
        }
        .frame (maxWidth: .infinity)
        .frame (maxHeight:  450)
        .background(Color.white)
        .clipShape (RoundedRectangle (cornerRadius: 30, style: .continuous))
        .shadow(radius: 30)
        .padding (.horizontal)
        .offset(.zero)
    }
}

struct PillView: View {
    @EnvironmentObject var dayPlanner: DayPlanner
    @EnvironmentObject var vm: FileManagerViewModel
    private var pill: Pill
    init (for pill: Pill) {
        self.pill = pill
    }
    @State private var accepted = false
    @State private var typeList = ["табл.", "шт.", "мл.", "мг.", "гр.", "лож.", "ст. лож."]
    @State private var offset: CGFloat = 0
    @State private var isSwiped = false
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                Button(action: {
                    dayPlanner.deletePill(pill: pill)
                    vm.deletePill(pillId: pill.id.uuidString)
                }, label: {
                    Image(systemName: "trash")
                        .foregroundColor(.white)
                        .frame(maxWidth: 90, maxHeight: .infinity)
                })
                
            }
            .background(Color(red: 73/255, green: 169/255, blue: 166/255))
            .cornerRadius(25)
            VStack(spacing: 0){
                HStack {
                    Image("\(pill.choosedMedicine.medicineIcon)")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(Color(red: 73/255, green: 169/255, blue: 166/255))
                        .padding(.trailing)
                    VStack (alignment: .leading) {
                        Text(pill.pillName)
                            .font(.title2)
                            .fontWeight(.semibold)
                        HStack {
                            Text(pill.pillQuantity)
                                .font(.title3)
                                .fontWeight(.light)
                                .foregroundColor(Color(red: 33/255, green: 33/255, blue: 33/255))
                            Text("\(typeList[pill.choosedMedicine.typeOfDosage])")
                        }
                        if pill.acceptedAt.contains(dayPlanner.currentDate) {
                            Text("Принято")
                                .font(.title3)
                                .fontWeight(.light)
                                .foregroundColor(.green)
                        } else if dayPlanner.currentDate < dayPlanner.setStartOfDay(for: Date()) ||
                                    dayPlanner.currentDate == dayPlanner.setStartOfDay(for: Date()) &&
                            (Date().formatted(.dateTime .hour(.twoDigits(amPM: .abbreviated))) > pill.receptionTime.formatted(.dateTime .hour(.twoDigits(amPM: .abbreviated))) // часы сегодня больше часры принятия
                                    || Date().formatted(.dateTime .hour(.twoDigits(amPM: .abbreviated))) == pill.receptionTime.formatted(.dateTime .hour(.twoDigits(amPM: .abbreviated))) // часы сегодня равно часы принятия
                                    && Date().formatted(.dateTime .minute()) > pill.receptionTime.formatted(.dateTime .minute())) // минуты сегодня больше минут приема
                        {
                            Text("Пропущено")
                                .font(.title3)
                                .fontWeight(.light)
                                .foregroundColor(.red)
                        }
                        if dayPlanner.countRequiredQuantity(for: pill) < 0.0 {
                            HStack() {
                                Text("Требуется еще \(Int(round(-dayPlanner.countRequiredQuantity(for: pill)))) \(typeList[pill.choosedMedicine.typeOfDosage])")
                                    .foregroundColor(.red)
                                Spacer()
                            }
                        }
                    }
                    
                    Spacer()
                    Text("\(pill.receptionTime.formatted(.dateTime .hour() .minute()))")
                        .font(.title)
                        .fontWeight(.light)
                        .foregroundColor(Color(red: 33/255, green: 33/255, blue: 33/255))
                    
                    
                    Image(systemName: "chevron.forward")
                }
                .padding()
            }
            .background(Color(.white))
            .cornerRadius(25)
            .shadow(color: Color.black.opacity (0.08), radius: 5, x: 5, y: 5)
            .offset(x: offset)
            .gesture(DragGesture().onChanged(onChanged(value:)).onEnded(onEnded(value:)))
        }
        
    }
    
    func onChanged(value: DragGesture.Value) {
        if value.translation.width < 0 {
            if isSwiped {
                offset = value.translation.width - 90
            } else {
                offset = value.translation.width
            }
        }
    }
    
    func onEnded(value: DragGesture.Value) {
        withAnimation(.easeOut) {
            if value.translation.width < 0 {
                if -value.translation.width > UIScreen.main.bounds.width / 2 {
                    offset = -1000
                    dayPlanner.deletePill(pill: pill)
                    vm.deletePill(pillId: pill.id.uuidString)
                } else if -offset > 50 {
                    isSwiped = true
                    offset = -90
                } else {
                    isSwiped = false
                    offset = 0
                }
            } else {
                isSwiped = false
                offset = 0
            }
        }
        
    }
}

struct ProgressBar: View {
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
                .animation(.easeInOut(duration: 2.0), value: 0)
        }
    }
}
