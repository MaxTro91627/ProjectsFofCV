//
//  AuthView.swift
//  PillBox
//
//  Created by Максим Троицкий on 17.05.2023.
//

import SwiftUI
import iPhoneNumberField

struct AuthView: View {
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
    @State var ID = ""
    
    init() {
        dateFormatter.dateFormat = "yyyyMMdd"
    }
    var body: some View {
        NavigationStack {
                ZStack {
                    VStack {
                        Group {
                            HStack {
                                Spacer()
                                Text("Введите данные о себе")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .padding()
                                Spacer()
                            }
                            .padding()
                            Spacer()
                            HStack {
                                ZStack {
                                    Circle()
                                        .frame(maxWidth: 190)
                                        .foregroundColor(Color(red: 169/255, green: 210/255, blue: 216/255))
                                    Image("AuthImage")
                                        .resizable()
                                        .frame(maxWidth: 130, maxHeight: 130)
                                }
                            }
                            Spacer()
                            HStack {
                                TextField("Имя", text: userName == "" ? $userNameTextField : $userName)
                                    .foregroundColor(Color(.black))
                                Spacer()
                                if isTabbedButton && userNameTextField == "" {
                                    Image(systemName: "multiply.circle")
                                        .foregroundColor(.red)
                                }
                            }
                            .padding()
                            .background(Color(UIColor(red: 190/255, green: 190/255, blue: 190/255, alpha: 0.2)))
                            .cornerRadius(20)
                            .padding(.horizontal)
                            .onChange(of: userNameTextField) { desc in
                                UserDefaults.standard.set(desc, forKey: "UserName")
                            }
                            HStack {
                                TextField("Фамилия", text: userSurname == "" ? $userSurnameTextField : $userSurname)
                                    .foregroundColor(Color(.black))
                                
                                Spacer()
                                if isTabbedButton && userSurnameTextField == "" {
                                    Image(systemName: "multiply.circle")
                                        .foregroundColor(.red)
                                }
                            }
                            .padding()
                            .background(Color(UIColor(red: 190/255, green: 190/255, blue: 190/255, alpha: 0.2)))
                            .cornerRadius(20)
                            .padding(.horizontal)
                            .onChange(of: userSurnameTextField) { desc in
                                UserDefaults.standard.set(desc, forKey: "UserSurname")
                            }
                        }
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
                        .background(Color(UIColor(red: 190/255, green: 190/255, blue: 190/255, alpha: 0.2)))
                        .cornerRadius(20)
                        .padding(.horizontal)
                        .onChange(of: userBirthdayPicker) { desc in
                            let date = dateFormatter.string(from: desc)
                            UserDefaults.standard.set(date, forKey: "UserBirthday")
                        }
                        HStack {
                            TextField("jsnjvkskjv", text: userPhoneNumber == "" ? $userPhoneNumberTextField : $userPhoneNumber)
//                            iPhoneNumberField("Телефон (для верификации)", text: userPhoneNumber == "" ? $userPhoneNumberTextField : $userPhoneNumber)
//                                .prefixHidden(false)
//                                .flagSelectable(true)
//                                .maximumDigits(10)
//                                .clearButtonMode(.whileEditing)
//                                .formatted(true)
                            Spacer()
                            if isTabbedButton && userPhoneNumberTextField == "" {
                                Image(systemName: "multiply.circle")
                                    .foregroundColor(.red)
                            }
                        }
                        .padding()
                        .background(Color(UIColor(red: 190/255, green: 190/255, blue: 190/255, alpha: 0.2)))
                        .cornerRadius(20)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        .onChange(of: userPhoneNumberTextField) { desc in
                            UserDefaults.standard.set(desc, forKey: "UserPhoneNumber")
                        }
                        Spacer()
                        NavigationLink(destination: SecondAuthView(ID: $ID), isActive: $isPresentedContentView) {
                                Button(action: {
                                    if UserDefaults.standard.string(forKey: "UserBirthday") != "" &&
                                        UserDefaults.standard.string(forKey: "UserSurname") != "" &&
                                        UserDefaults.standard.string(forKey: "UserName") != "" &&
                                        UserDefaults.standard.string(forKey: "UserBirthday") != nil &&
                                        UserDefaults.standard.string(forKey: "UserSurname") != nil &&
                                        UserDefaults.standard.string(forKey: "UserName") != nil {
                                        self.userPhoneNumber = UserDefaults.standard.string(forKey: "UserPhoneNumber")!
                                        PhoneAuthProvider.provider().verifyPhoneNumber(self.userPhoneNumber, uiDelegate: nil) { (ID, err) in
                                            if err != nil {
                                                return
                                            }
                                            self.ID = ID!
                                            self.isPresentedContentView.toggle()
                                        }
                                    } else {
                                        isTabbedButton = true
                                    }
                                }, label: {
                                    Text("сохранить")
                                        .padding()
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .background((Color(red: 73/255, green: 169/255, blue: 166/255)))
                                        .cornerRadius(20)
                                })
                        }
                        .padding()
                        
                    }
                }
                .background(Color(red: 236/255, green: 240/255, blue: 255/255))
            
        }
        .background(ignoresSafeAreaEdges: [.all])
        .navigationBarHidden(true)
    }
        
}

struct SecondAuthView: View {
    @State var verificationCode: String = ""
    @State var isPresentedContentView = false
    @State var isTabbedButton = false
    @Binding var ID : String
    var body: some View {
        NavigationStack {
            if !isPresentedContentView {
                ZStack {
                    VStack {
                        HStack {
                            Spacer()
                            Text("Подтверждение номера телефона")
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding()
                            Spacer()
                        }
                        .padding()
                        Spacer()
                        HStack {
                            ZStack {
                                Circle()
                                    .frame(maxWidth: 190)
                                    .foregroundColor(Color(red: 169/255, green: 210/255, blue: 216/255))
                                Image("AuthImage")
                                    .resizable()
                                    .frame(maxWidth: 130, maxHeight: 130)
                            }
                        }
                        Spacer()
                        HStack {
                            Text("Введите код верификации")
                        }
                        HStack {
                            TextField("Код верификации", text: $verificationCode)
                                .foregroundColor(Color(.black))
                                .keyboardType(.phonePad)
                            Spacer()
                        }
                        .padding()
                        .background(Color(UIColor(red: 190/255, green: 190/255, blue: 190/255, alpha: 0.2)))
                        .cornerRadius(20)
                        .padding(.horizontal)
                        Spacer()
                        Button(action: {
                            let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.ID, verificationCode: self.verificationCode)
                            Auth.auth().signIn(with: credential) { (res, err) in
                                if err != nil {
                                    return
                                }
                                UserDefaults.standard.set(true, forKey: "status")
                            }
                        }, label: {
                            Text("Войти")
                                .padding()
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .background((Color(red: 73/255, green: 169/255, blue: 166/255)))
                                .cornerRadius(20)
                        })
                        .padding()
                        
                    }
                }
                .background(Color(red: 236/255, green: 240/255, blue: 255/255))
            } else {
                ContentView()
            }
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
