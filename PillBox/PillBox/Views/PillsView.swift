//
//  PillsView.swift
//  PillBox
//
//  Created by Максим Троицкий
//

import SwiftUI

struct PillsView: View {
    @EnvironmentObject var dayPlanner: DayPlanner
    var body: some View {
        ZStack {
            VStack {
                HStack() {
                    Text("Список лекарств")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    Spacer()
                    addPillButton()
                }
                .padding(.horizontal)
               
                Spacer()
                
                MedicineListView()
            }
            .background(Color(red: 236/255, green: 240/255, blue: 255/255))
            
        }
        .background(Color(red: 236/255, green: 240/255, blue: 255/255))
    }
    
}

struct MedicineListView: View {
    @EnvironmentObject var dayPlanner: DayPlanner
    @State var medicineNamePicker: String = ""
    var addedMedicineNames: [String] = []
    var body: some View {
        HStack {
            TextField("Введите название", text: $medicineNamePicker)
                .fontWeight(.semibold)
                .foregroundColor(Color(red: 133/255, green: 133/255, blue: 133/255))
                .padding(.horizontal)
        }
        .frame(height: 30)
        .background {
            RoundedRectangle(cornerRadius: 15)
                .fill(.white)
        }
        .padding()
        ScrollView {
            let medicineNames = getAllNames()
            
            ForEach(medicineNames, id:\.self) { name in
                if countDeleted(for: name) != 0 {
                    if name.lowercased().contains(medicineNamePicker.lowercased()) || medicineNamePicker == "" {
                        HStack {
                            Text(name)
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        .padding(.horizontal)
                        ForEach(dayPlanner.medicines, id:\.self) { medicine in
                            if medicine.medicineName.lowercased() == name.lowercased() {
                                if !medicine.isDeleted {
                                    MedicineView(for: medicine)
                                }
                            }
                        }
                        Divider()
                            .fontWeight(.bold)
                    }
                    
                }
            }
        }
        
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
    
    func countDeleted(for name: String) -> Int {
        var deleted = 0
        let medicines = dayPlanner.medicines
        let deletedArr = medicines.filter({$0.medicineName.lowercased() == name.lowercased()})
        deleted = deletedArr.filter( {!$0.isDeleted} ).count
        return deleted
    }
}

struct addPillButton: View {
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
            CreatePillView()
                .background(Color(red: 236/255, green: 240/255, blue: 255/255))
        }
        .background(Color(red: 236/255, green: 240/255, blue: 255/255))
    }
}

struct MedicineView: View {
    private var medicine: Medicine
    @EnvironmentObject var dayPlanner: DayPlanner
    @EnvironmentObject var vm: FileManagerViewModel
    @State private var typeList = ["табл.", "шт.", "мл.", "мг.", "гр.", "лож.", "ст. лож."]
    @State private var offset: CGFloat = 0
    @State private var isSwiped = false
    init (for medicine: Medicine) {
        self.medicine = medicine
    }
    
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                Button(action: {
                    dayPlanner.deleteMedicine(medicine: medicine)
                    vm.rewriteMedicine(medicine: dayPlanner.medicines[dayPlanner.medicines.firstIndex(where: {$0.id == medicine.id})!])
                }, label: {
                    Image(systemName: "trash")
                        .foregroundColor(.white)
                        .frame(maxWidth: 90, maxHeight: .infinity)
                })
            }
            .background(Color(red: 73/255, green: 169/255, blue: 166/255))
            .cornerRadius(25)
            .padding(.horizontal)
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
                Text("\(medicine.restOfMedicine) \(typeList[medicine.typeOfDosage])")
                    .foregroundColor(Float(medicine.restOfMedicine)! / Float(medicine.totalMedicine)! <= 0.2 ? .red : .black)
            }
            .padding()
            .background() {
                RoundedRectangle(cornerRadius: 25)
                    .fill(.white)
                    .shadow(color: Color.black.opacity (0.08), radius: 5, x: 5, y: 5)
            }
            .padding(.horizontal)
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
                    dayPlanner.deleteMedicine(medicine: medicine)
                    vm.rewriteMedicine(medicine: dayPlanner.medicines[dayPlanner.medicines.firstIndex(where: {$0.id == medicine.id})!])
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

struct PillsView_Previews: PreviewProvider {
    static var previews: some View {
        PillsView()
    }
}
