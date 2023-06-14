//
//  CreatePillView.swift
//  PillBox
//
//  Created by Максим Троицкий
//

import SwiftUI

struct CreatePillView: View {
    @EnvironmentObject var dayPlanner: DayPlanner
    @EnvironmentObject var vm: FileManagerViewModel
    var body: some View {
        VStack {
            HeaderCreatePillView()
                .padding()
            ChoosePillOptionView()
                .padding()
            Spacer()
            ButtonsView()
        }
        .background(Color(red: 236/255, green: 240/255, blue: 255/255))
    }
}

struct HeaderCreatePillView: View {
    var body: some View {
        HStack {
            Spacer()
            Text("Добавление в Пилюльницу")
                .foregroundColor(.black)
            Spacer()
        }
        .font(.title3)
        .fontWeight(.semibold)
        .background(Color(red: 236/255, green: 240/255, blue: 255/255))
    }
}

struct ChoosePillOptionView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dayPlanner: DayPlanner
    @State private var addButtonTabbed = false
    @State private var medicineName: String = ""
    @State private var typeOfDosage: Int? = 1
    @State private var expirationDate = Date()
    @State private var restOfMedicine: String = ""
    @State private var typeOfDosageList = ["Таблетки", "Штуки", "Миллилитры", "Миллиграммы", "Граммы", "Чайные ложки", "Столовые ложки"]
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    TextField("Название лекарства", text: $medicineName)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(red: 133/255, green: 133/255, blue: 133/255))
                }
                .onChange(of: medicineName) { desc in
                    dayPlanner.medicineName = desc
                }
                .padding()
                IconChoose()
                    .frame(maxHeight: 200)
                
                HStack {
                    Text("Вид дозировки")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Spacer()
                    PickerTextField(data: typeOfDosageList, placeholder: "Таблетки", lastSelectedIndex: self.$typeOfDosage)
                }
                .padding()
                .onChange(of: typeOfDosage!) { desc in
                    dayPlanner.typeOfDosage = desc
                }
                HStack() {
                    DatePicker("Срок годности", selection: $expirationDate, in: PartialRangeFrom(dayPlanner.getToday()), displayedComponents: .date)
                        .accentColor(Color(red: 73/255, green: 166/255, blue: 169/255))
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                .padding(.horizontal)
                .onChange(of: expirationDate) { desc in
                    dayPlanner.expirationDate = desc
                }
                HStack {
                    TextField("Остаток медикамента", text: $restOfMedicine)
                        .keyboardType(.numberPad)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(red: 133/255, green: 133/255, blue: 133/255))
                        .padding()
                }
                .onChange(of: restOfMedicine) { desc in
                    dayPlanner.restOfMedicine = desc
                }
                
                Spacer()
            }
        }
    }
}





struct CreatePillView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePillView()
    }
}

struct IconChoose: View {
    @EnvironmentObject var dayPlanner: DayPlanner
    var body: some View {
        ZStack() {
            RoundedRectangle(cornerRadius: 25)
                .frame(maxHeight: 200)
                .foregroundColor(.white)
            HStack {
                VStack {
                    VStack {
                        Image("pill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .background(
                                ZStack {
                                    Circle()
                                        .fill(Color(dayPlanner.medicineIcon == "pill" ? UIColor(red: 177/255, green: 169/255, blue: 247/255, alpha: 0.7) : UIColor( red: 73/255, green: 169/255, blue: 166/255, alpha: 0.3)))
                                        .frame(width: 40, height: 40)
                                })
                        Text("Таблетки")
                            .font(.footnote)
                    }
                    .padding()
                    .onTapGesture {
                        dayPlanner.medicineIcon = "pill"
                    }
                    VStack {
                        Image("spoon")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .background(
                                ZStack {
                                    Circle()
                                        .fill(Color(dayPlanner.medicineIcon == "spoon" ? UIColor(red: 177/255, green: 169/255, blue: 247/255, alpha: 0.7) : UIColor( red: 73/255, green: 169/255, blue: 166/255, alpha: 0.3)))
                                        .frame(width: 40, height: 40)
                                })
                        Text("Столовые ложки")
                            .font(.footnote)
                    }
                    .padding()
                    .onTapGesture {
                        dayPlanner.medicineIcon = "spoon"
                    }
                }
                Spacer()
                VStack {
                    VStack {
                        Image("drops")
                            .resizable()
                            .frame(width: 31, height: 31)
                            .background(
                                ZStack {
                                    Circle()
                                        .fill(Color(dayPlanner.medicineIcon == "drops" ? UIColor(red: 177/255, green: 169/255, blue: 247/255, alpha: 0.7) : UIColor( red: 73/255, green: 169/255, blue: 166/255, alpha: 0.3)))
                                        .frame(width: 40, height: 40)
                                })
                        
                        Text("Капли")
                            .font(.footnote)
                    }
                    .padding()
                    .onTapGesture {
                        dayPlanner.medicineIcon = "drops"
                    }
                    VStack {
                        Image("syringe")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .background(
                                ZStack {
                                    Circle()
                                        .fill(Color(dayPlanner.medicineIcon == "syringe" ? UIColor(red: 177/255, green: 169/255, blue: 247/255, alpha: 0.7) : UIColor( red: 73/255, green: 169/255, blue: 166/255, alpha: 0.3)))
                                        .frame(width: 40, height: 40)
                                })
                        Text("Шприц")
                            .font(.footnote)
                    }
                    .padding()
                    .onTapGesture {
                        dayPlanner.medicineIcon = "syringe"
                    }
                }
                Spacer()
                VStack {
                    VStack {
                        Image("teaspoon")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .background(
                                ZStack {
                                    Circle()
                                        .fill(Color(dayPlanner.medicineIcon == "teaspoon" ? UIColor(red: 177/255, green: 169/255, blue: 247/255, alpha: 0.7) : UIColor( red: 73/255, green: 169/255, blue: 166/255, alpha: 0.3)))
                                        .frame(width: 40, height: 40)
                                })
                        Text("Чайные ложки")
                            .font(.footnote)
                    }
                    .padding()
                    .onTapGesture {
                        dayPlanner.medicineIcon = "teaspoon"
                    }
                    VStack {
                        Image("more")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .background(
                                ZStack {
                                    Circle()
                                        .fill(Color(dayPlanner.medicineIcon == "more" ? UIColor(red: 177/255, green: 169/255, blue: 247/255, alpha: 0.7) : UIColor( red: 73/255, green: 169/255, blue: 166/255, alpha: 0.3)))
                                        .frame(width: 40, height: 40)
                                })
                        Text("Другое")
                            .font(.footnote)
                    }
                    .padding()
                    .onTapGesture {
                        dayPlanner.medicineIcon = "more"
                    }
                }
            }
        }
        
        .frame(maxHeight: 200)
    }
}

struct ButtonsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dayPlanner: DayPlanner
    @EnvironmentObject var vm: FileManagerViewModel
    var body: some View {
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
                if dayPlanner.medicineName != "" && dayPlanner.expirationDate != Date() && (dayPlanner.typeOfDosage == 0 && dayPlanner.restOfMedicine != "") || (dayPlanner.typeOfDosage == 1 && dayPlanner.restOfMedicine != "") || dayPlanner.typeOfDosage != 0 || dayPlanner.typeOfDosage != 1 {
                    dayPlanner.createMedicine()
                    vm.saveMedicine(medicine: dayPlanner.lastAddedMedicine!)
                    presentationMode.wrappedValue.dismiss()
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
