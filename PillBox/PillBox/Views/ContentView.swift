//
//  ContentView.swift
//  PillBox
//
//  Created by Максим Троицкий
//

import SwiftUI
import iPhoneNumberField

struct ContentView: View {
    let dayPlanner = DayPlanner()
    let vm = FileManagerViewModel()
    init() {
        UINavigationBar.appearance().tintColor = UIColor.black
        let userPills = FileManager.default.urlss(for: .documentDirectory, idx: 0)
        let userPillBox = FileManager.default.urlss(for: .documentDirectory, idx: 1)
        if userPills != nil {
            for file in userPills! {
                dayPlanner.createPillFromFileManager(pill: vm.getPillFromFileManager(pillId: file))
            }
        }
        if userPillBox != nil {
            for file in userPillBox! {
                dayPlanner.createPillBoxFromFileManager(medicine: vm.getPillBoxFromFileManager(medicineId: file))
            }
        }
        dayPlanner.setAllPillsTabbedToFalse()
        
    }
    @State var selectedIndex = 0
    let tabBarImages = ["house.fill", "pills.circle.fill", "person.fill"]
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    switch selectedIndex {
                    case 0:
                        HomeView()
                    case 1:
                        PillsView()
                            .background(Color(red: 236/255, green: 240/255, blue: 255/255))
                    default:
                        UserView()
                    }
                }
                Spacer()
                ZStack {
                    HStack {
                        ForEach(0..<3) { num in
                            Button(action: {
                                selectedIndex = num
                            }, label: {
                                Spacer()
                                if num == 1 {
                                    Image(systemName:  tabBarImages[num])
                                        .font(.system(size: 60))
                                        .frame(width: 10, height: 60)
                                        .foregroundColor(selectedIndex == num ?  Color(red: 73/255, green: 169/255, blue: 166/255) : .gray)
                                        .padding(.bottom, 10)
                                    
                                } else {
                                    Image(systemName:  tabBarImages[num])
                                        .font(.system(size: 36))
                                        .foregroundColor(selectedIndex == num ?  Color(red: 73/255, green: 169/255, blue: 166/255) : .gray)
                                }
                                Spacer()
                            })
                            .cornerRadius(60)
                        }
                    }
                }
            }
            .background(Color(red: 236/255, green: 240/255, blue: 255/255))
            .environmentObject(dayPlanner)
            .environmentObject(vm)
            .ignoresSafeArea(.keyboard)
        }
//        .onAppear {
//            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
//            AppDelegate.orientationLock = .portrait
//        }
        .navigationBarHidden(true)
    }
}

struct startView: View {
    @State var userName: String = UserDefaults.standard.string(forKey: "UserName") ?? ""
    @State var userSurname: String = UserDefaults.standard.string(forKey: "UserSurname") ?? ""
    @State var userPhoneNumber: String = UserDefaults.standard.string(forKey: "UserPhoneNumber") ?? ""
    @State var userBirthday: String = UserDefaults.standard.string(forKey: "UserBirthday") ?? ""
    @State var userNameTextField = ""
    @State var userSurnameTextField = ""
    @State var userPhoneNumberTextField = ""
    @State var userBirthdayPicker = Date()
    private let dateFormatter = DateFormatter()
    @State var isPresentedContentView = false
    @State var isTabbedButton = false
    
    init() {
        dateFormatter.dateFormat = "yyyyMMdd"
    }
    var body: some View {
        NavigationStack {
            if !isPresentedContentView {
                ZStack {
                    VStack {
                        Group {
                            Spacer()
                            HStack {
                                Spacer()
                                Text("Введите данные о себе")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .padding()
                                Spacer()
                            }
                            .padding()
                            HStack {
                                TextField("Имя", text: userName == "" ? $userNameTextField : $userName)
                                    .foregroundColor(Color(.black))
                                Spacer()
                                if isTabbedButton && userNameTextField == "" {
                                    Image(systemName: "multiply.circle")
                                        .foregroundColor(.red)
                                }
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
                                if isTabbedButton && userSurnameTextField == "" {
                                    Image(systemName: "multiply.circle")
                                        .foregroundColor(.red)
                                }
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
                                Spacer()
                                if isTabbedButton && dateFormatter.date(from: dateFormatter.string(from: userBirthdayPicker)) == dateFormatter.date(from: dateFormatter.string(from: Date())) {
                                    Image(systemName: "multiply.circle")
                                        .foregroundColor(.red)
                                }
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
                                Spacer()
                                if isTabbedButton && userPhoneNumberTextField == "" {
                                    Image(systemName: "multiply.circle")
                                        .foregroundColor(.red)
                                }
                            }
                            .fontWeight(.bold)
                            .padding(.horizontal)
                            .onChange(of: userPhoneNumberTextField) { desc in
                                UserDefaults.standard.set(desc, forKey: "UserPhoneNumber")
                            }
                            Divider()
                                .padding(.horizontal)
                                .padding(.bottom)
                            Button(action: {
                                if UserDefaults.standard.string(forKey: "UserPhoneNumber") != "" &&
                                    UserDefaults.standard.string(forKey: "UserBirthday") != "" &&
                                    UserDefaults.standard.string(forKey: "UserSurname") != "" &&
                                    UserDefaults.standard.string(forKey: "UserName") != "" &&
                                    UserDefaults.standard.string(forKey: "UserPhoneNumber") != nil &&
                                    UserDefaults.standard.string(forKey: "UserBirthday") != nil &&
                                    UserDefaults.standard.string(forKey: "UserSurname") != nil &&
                                    UserDefaults.standard.string(forKey: "UserName") != nil {
                                    isPresentedContentView = true;
                                } else {
                                    isTabbedButton = true
                                }
                            }, label: {
                                Text("сохранить")
                                    .padding()
                                    .foregroundColor(.white)
                                    .background() {
                                        RoundedRectangle(cornerRadius: 25)
                                            .fill((Color(red: 73/255, green: 169/255, blue: 166/255)))
                                    }
                            })
                        }
                        Spacer()
                    }
                }
                .background(Color(red: 236/255, green: 240/255, blue: 255/255))
            } else {
                ContentView()
            }
        }
        .navigationBarHidden(true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
