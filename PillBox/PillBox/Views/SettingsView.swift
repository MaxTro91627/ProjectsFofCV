//
//  SettingsView.swift
//  PillBox
//
//  Created by Максим Троицкий
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentation
    @EnvironmentObject var dayPlanner: DayPlanner
    var vm = FileManagerViewModel()
    @State var remainsNotif: Bool = true
    @State var expirationNotif: Bool = true
    @State var acceptNotif: Bool = true
    @State var userLoggedOut = false
    
    var body: some View {
        NavigationStack {
            ZStack {
            
                ScrollView(showsIndicators: false) {
                    
                    HStack {
                        Text("Настройки")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding()
                        Spacer()
                    }
                    Group {
                        HStack {
                            Text("Основные")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(Color(red: 133/255, green: 133/255, blue: 133/255))
                            Spacer()
                        }
                        .padding(.horizontal)
                        HStack {
                            NavigationLink(destination: ChooseHomeView()) {
                                Text("Вид главного экрана")
                                    .foregroundColor(.black)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.black)
                            }
                            .padding()
                        }
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.white)
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                    Group {
                        HStack {
                            Text("Уведомления")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(Color(red: 133/255, green: 133/255, blue: 133/255))
                            Spacer()
                        }
                        .padding(.horizontal)
                        HStack {
                            NavigationLink(destination: ChooseNotifications()) {
                                Text("Звук")
                                    .foregroundColor(.black)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.black)
                            }
                            .padding()
                        }
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.white)
                        }
                        .padding(.horizontal)
                        HStack {
                            Toggle("Напоминание об остатках", isOn: $remainsNotif)
                                .toggleStyle(.switch)
                                .tint(Color(red: 73/255, green: 169/255, blue: 166/255))
                                .foregroundColor(.black)
                                .padding()
                            Spacer()
                        }
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.white)
                        }
                        .padding(.horizontal)
                        HStack {
                            Toggle("Напоминание о сроке годности", isOn: $expirationNotif)
                                .toggleStyle(.switch)
                                .tint(Color(red: 73/255, green: 169/255, blue: 166/255))
                                .foregroundColor(.black)
                                .padding()
                            Spacer()
                        }
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.white)
                        }
                        .padding(.horizontal)
                        HStack {
                            Toggle("Напоминание о приеме", isOn: $acceptNotif)
                                .toggleStyle(.switch)
                                .tint(Color(red: 73/255, green: 169/255, blue: 166/255))
                                .foregroundColor(.black)
                                .padding()
                            Spacer()
                        }
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.white)
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                    Group {
                        HStack {
                            Text("О приложении")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(Color(red: 133/255, green: 133/255, blue: 133/255))
                            Spacer()
                        }
                        .padding(.horizontal)
                        HStack {
                            NavigationLink(destination: PrivacyPolicy()) {
                                Text("Политика конфиденциальности")
                                    .foregroundColor(.black)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.black)
                            }
                            .padding()
                        }
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.white)
                        }
                        .padding(.horizontal)
                        HStack {
                            NavigationLink(destination: TermsOfUse()) {
                                Text("Условия пользования")
                                    .foregroundColor(.black)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.black)
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
                                let a = 0
                            }) {
                                Text("Поддержка")
                                    .padding()
                                Spacer()
                            }
                        }
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.white)
                        }
                        .padding(.horizontal)
                        HStack {
                            Button(action: {
                                let a = 0
                            }) {
                                Text("Обучение")
                                    .padding()
                                Spacer()
                            }
                        }
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.white)
                        }
                        .padding(.horizontal)
                        HStack {
                            Button(action: {
                                let a = 0
                            }) {
                                Text("Premium Pro")
                                    .padding()
                                Spacer()
                            }
                            .foregroundColor(Color(red: 73/255, green: 169/255, blue: 166/255))
                        }
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.white)
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                        
                    }
                    Group {
                        HStack {
                            Text("Аккаунт")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(Color(red: 133/255, green: 133/255, blue: 133/255))
                            Spacer()
                        }
                        .padding(.horizontal)
                        HStack {
                            Button(action: {
//                                try! Auth.auth().signOut()
                                vm.clearBase()
                                dayPlanner.clearBase()
                                UserDefaults.standard.set("", forKey: "UserPhoneNumber")
                                UserDefaults.standard.set("", forKey: "UserName")
                                UserDefaults.standard.set("", forKey: "UserSurname")
                                UserDefaults.standard.set("", forKey: "UserBirthday")
//                                UserDefaults.standard.set(false, forKey: "status")
                                userLoggedOut = true
                            }) {
                                Text("Выйти")
                                    .padding()
                                Spacer()
                            }
                            .foregroundColor(.red)
                        }
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.white)
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                    Spacer()
                }
                VStack {
                    HStack {
                        Spacer()
                        Spacer()
                    }
                    .frame(maxHeight: 1)
                    .background(Color(red: 236/255, green: 240/255, blue: 255/255))
                    Spacer()
                }
                
            }
            .background(Color(red: 236/255, green: 240/255, blue: 255/255))
            .background(ignoresSafeAreaEdges: [.bottom])
        }
        .navigationDestination(isPresented: $userLoggedOut) {
            startView()
        }
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct ChooseHomeView: View {
    var body: some View {
        VStack {
            Text("Выбор вида главного экрана")
        }
    }
}

struct ChooseNotifications: View {
    var body: some View {
        VStack {
            Text("Выбор режима уведомлений")
        }
    }
}

struct PrivacyPolicy: View {
    var body: some View {
        VStack {
            Text("Политика конфиденциальности")
        }
    }
}

struct TermsOfUse: View {
    var body: some View {
        VStack {
            Text("Политика конфиденциальности")
        }
    }
}
