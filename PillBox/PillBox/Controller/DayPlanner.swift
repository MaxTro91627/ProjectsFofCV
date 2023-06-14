//
//  DayPlanner.swift
//  PillBox
//
//  Created by Максим Троицкий
//

import Foundation
import SwiftUI

class DayPlanner: ObservableObject {
    
    @Published var pillModel = MyPlanner()
    @Published var pillBoxModel = MyPills()
    @Published private var calModel = MyCalendar()
    
    @Published var medicineName: String = ""
    @Published var typeOfDosage: Int = 1
    @Published var expirationDate = Date()
    @Published var restOfMedicine: String = ""
    @Published var medicineIcon: String = "more"
    
    @Published var pillName: String = ""
    @Published var pillQuantity: String = ""
    @Published var receptionTime = Date()
    @Published var receptionMode: Int?
    @Published var endByOption: Int?
    @Published var startReceptionDate = Date()
    @Published var endReceptionDate = Date()
    @Published var pillMaxQuantity: String = ""
    @Published var pillMaxDay: String = ""
    @Published var choosedMedicine: Medicine?
    @Published var receptionDatesMode: Int? = 2
    
    @Published var lastAddedPill: Pill? = nil
    @Published var lastAddedMedicine: Medicine? = nil

    
    var isTappedWeekday: [Bool] {
        return pillModel.isTappedWeekday
    }
    
    var pills: [Pill] {
        return pillModel.pills
    }
    
    var medicines: [Medicine] {
        return pillBoxModel.medicines
    }
    
    func clearBase() {
        pillModel.clearBase()
        pillBoxModel.clearBase()
    }
    
    func createMedicine() {
        let uuid = UUID()
        pillBoxModel.createMedicine(medicineName: medicineName, id: uuid, typeOfDosage: typeOfDosage, expirationDate: expirationDate, restOfMedicine: restOfMedicine, medicineIcon: medicineIcon)
        medicineName = ""
        typeOfDosage = 1
        expirationDate = Date()
        restOfMedicine = ""
        medicineIcon = "more"
        
        lastAddedMedicine = pillBoxModel.medicines[pillBoxModel.medicines.firstIndex(where: {$0.id == uuid})!]
    }
    
    func createPill(someDate: Date) {
        let uuid = UUID()
        startReceptionDate = calModel.setStartOfDay(for: someDate)
        pillModel.createPill(pillName: pillName, pillQuantity: pillQuantity, receptionTime: receptionTime, startReceptionDate: startReceptionDate, endReceptionDate: setStartOfDay(for: endReceptionDate), pillMaxQuantity: pillMaxQuantity, pillMaxDay: pillMaxDay, endByOption: endByOption, receptionMode: receptionMode, id: uuid, pillTabbed: false, choosedMedicine: choosedMedicine!, receptionDatesMode: receptionDatesMode)
        
        pillName = ""
        pillQuantity = ""
        receptionTime = Date()
        receptionMode = nil
        endByOption = nil
        startReceptionDate = Date()
        endReceptionDate = Date()
        receptionDatesMode = 2
        pillMaxQuantity = ""
        pillMaxDay = ""
        
        lastAddedPill = pillModel.pills[pillModel.pills.firstIndex(where: {$0.id == uuid})!]
    }
    
    func createPillFromFileManager(pill: Pill) {
        pillModel.createPillFromFileManager(pill: pill)
    }
    
    func createPillBoxFromFileManager(medicine: Medicine) {
        pillBoxModel.createPillBoxFromFileManager(medicine: medicine)
    }
    
    func getPillTabbed(of pill: Pill) -> Bool {
        let idx = pills.firstIndex(where: {$0.id == pill.id})
        return pillModel.pills[idx!].pillTabbed
    }
    
    func allOtherNotTabbed(except exPill: Pill) {
        for pill in pills {
            if pill.id != exPill.id {
                pillModel.setPillTabbedToFalse(for: pill)
            }
        }
    }
    
    func setAllPillsTabbedToFalse() {
        for pill in pills {
            pillModel.setPillTabbedToFalse(for: pill)
        }
    }
    
    func addAcceptedDay(to pill: Pill, date: Date) {
        let idx = pills.firstIndex(where: {$0.id == pill.id})
        pillModel.addAcceptedDay(to: idx!, date: date)
    }
    
    func countRequiredQuantity(for pill: Pill) -> Float {
        let need = pillModel.countRequiredQuantity(for: pill)
        var remains: Float = 0.0
        for medicine in medicines {
            if medicine.medicineName.lowercased() == pill.pillName.lowercased() && pill.choosedMedicine.typeOfDosage == medicine.typeOfDosage {
                remains += Float(medicine.restOfMedicine)!
            }
        }
        return remains - need
    }
    
    func removeFromAcceptedDay(for pill: Pill, date: Date) {
        let idx = pills.firstIndex(where: {$0.id == pill.id})
        pillModel.removeFromAcceptedDay(for: idx!, date: date)
    }
    
    func changeWeekdayTapped(in i: Int) {
        pillModel.changeWeekdayTapped(in: i)
    }
    
    func toggleTabbed(for pill: Pill) {
        let idx = pills.firstIndex(where: {$0.id == pill.id})
        pillModel.changeTabbed(in: idx!)
    }
    
    func deletePill(pill: Pill) {
        let idx = pills.firstIndex(where: {$0.id == pill.id})
        pillModel.deletePill(idx: idx!)
    }
    
    func deleteMedicine(medicine: Medicine) {
        let idx = medicines.firstIndex(where: {$0.id == medicine.id})
        pillBoxModel.deleteMedicine(idx: idx!)
    }
    
    func increaseNumberOfMedicine(for pill: Pill) {
        let idx = medicines.firstIndex(where: {$0.id == pill.choosedMedicine.id})
        pillBoxModel.increaseNumberOfMedicine(for: idx!, in: pill.pillQuantity)
    }
    
    func reduceNumberOfMedicine(for pill: Pill) {
        let idx = medicines.firstIndex(where: {$0.id == pill.choosedMedicine.id})
        pillBoxModel.reduceNumberOfMedicine(for: idx!, in: pill.pillQuantity)
    }
    
    func getIdxOfWeekday(for date: Date) -> Int {
        let f = DateFormatter()
        let weekday = f.weekdaySymbols[Calendar.current.component(.weekday, from: date) - 1]
        return f.weekdaySymbols.firstIndex(of: weekday)!
    }
    
    func getNumberOfWeekInYear(for date: Date) -> Int {
        let startDatesOfWeekInYear = calModel.startDateOfWeeksInAYear()
        return startDatesOfWeekInYear.firstIndex(of: date)!
    }
    
    var currentDate: Date {
        return calModel.currentDate
    }
    
    func getCurrentDate() -> Date {
        return calModel.currentDate
    }
    
    func setCurrentDate(to date: Date) {
        calModel.setCurrentDate(to: date)
    }
    
    func dates() -> [Date] {
        calModel.datesInYear()
    }
    
    func datesInAWeek(from date: Date) -> [Date] {
        calModel.datesInAWeek(from: date)
    }
    
    func startDateOfWeekInAYear() -> [Date] {
        calModel.startDateOfWeeksInAYear()
    }
    
    func startDateOfWeek(from date: Date) -> Date {
        calModel.startDateOfWeek(from: date)
    }
    
    func isCurrent(_ date: Date) -> Bool {
        return date == currentDate
    }
    
    func isToday(_ date: Date) -> Bool {
        return date == calModel.todayDate
    }
    
    func getToday() -> Date {
        return setStartOfDay(for: calModel.todayDate)
    }
    
    func currentPositionInWeek() -> Int {
        let startOfWeek = startDateOfWeek(from: currentDate)
        let datesInAWeek = datesInAWeek(from: startOfWeek)
        let position = datesInAWeek.firstIndex(of: currentDate)!
        return position
    }
    
    func setStartOfDay(for date: Date) -> Date {
        return calModel.setStartOfDay(for: date)
    }
    
    func countStatisticInRange(from start: Date, to end: Date, for somePillName: String) -> [Float] {
        var countOfSettedPills = 0
        var countOfAcceptedPills = 0
        for pill in pills {
            if somePillName.lowercased() == pill.pillName.lowercased() {
                countOfSettedPills += pill.receptionDates.filter({ $0 >= start && $0 <= end}).count
                countOfAcceptedPills += pill.receptionDates.filter({ $0 >= start && $0 <= end && pill.acceptedAt.contains($0)}).count
            }
        }
        return [Float(countOfAcceptedPills), Float(countOfSettedPills)]
    }
    
    func countFullStaticInRange(from start: Date, to end: Date) -> [Float] {
//        let neededPills = pills.filter({ $0.startReceptionDate <= end || $0.endReceptionDate >= start })
        let neededPills = getAllNames()
        if neededPills.count == 0 {
            return [0.00001, 0.00001]
        }
        var allPillsInPeriod: Float = 0
        var acceptedPllsInPeriod: Float = 0
        
        for neededPill in neededPills {
            allPillsInPeriod += countStatisticInRange(from: start, to: end, for: neededPill)[1]
            acceptedPllsInPeriod += countStatisticInRange(from: start, to: end, for: neededPill)[0]
        }
        if (allPillsInPeriod == 0) {
            return [0.00001, 0.00001]
        }
        return [Float(acceptedPllsInPeriod), Float(allPillsInPeriod)]
    }
    
    func getAllNames() -> [String] {
        var Names: [String] = []
        for medicine in medicines {
            if !Names.filter({$0.lowercased() == medicine.medicineName.lowercased()}).isEmpty {
                continue
            }
            Names.append(medicine.medicineName)
        }
        return Names
    }
    
    func countProgress(date: Date) -> Float {
        var totalPills: [Pill]
        var acceptedPills: [Pill]
        let newDate = setStartOfDay(for: date)
        totalPills = pills.filter { $0.startReceptionDate <= newDate && $0.endReceptionDate >= newDate && $0.isTappedWeekday[(getIdxOfWeekday(for: newDate) + 6) % 7] && $0.receptionDates.contains(newDate)}
        if totalPills.count == 0 {
            return 1.0
        }
        acceptedPills = totalPills.filter { $0.acceptedAt.contains(newDate) }
        return max(Float(Float(acceptedPills.count) / Float(totalPills.count)), 0.01)
    }
}
