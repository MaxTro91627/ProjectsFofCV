//
//  MyPlanner.swift
//  PillBox
//
//  Created by Максим Троицкий
//

import Foundation
import SwiftUI

struct Pill: Identifiable, Hashable, Encodable, Decodable {
    var pillName: String
    var id: UUID
    var isTappedWeekday: [Bool]
    var pillQuantity: String
    var receptionTime: Date
    var receptionMode: Int?
    var endByOption: Int?
    var startReceptionDate: Date
    var endReceptionDate: Date
    var pillMaxQuantity: String
    var pillMaxDay: String
    var pillTabbed: Bool
    var choosedMedicine: Medicine
    var acceptedAt: [Date]
    var receptionDatesMode: Int?
    var receptionDates: [Date]
}

struct MyPlanner {
    private(set) var pills: [Pill]
    private(set) var isTappedWeekday = [false, false, false, false, false, false, false]
    private let dateFormatter = DateFormatter()
    
    init() {
        pills = []
        dateFormatter.dateFormat = "yyyyMMdd"
    }
    
    mutating func clearBase() {
        pills = []
    }
    
    mutating func countEndDate(for pill: Pill) {
        var endDate: Date
        let idx = pills.firstIndex(where: {$0.id == pill.id})
        let calendar = Calendar.current
        
        if pill.endByOption == nil {
            
            endDate = pill.startReceptionDate
            pills[idx!].endReceptionDate = dateFormatter.date(from: dateFormatter.string(from: endDate))!
            
        } else if pill.endByOption == 1 {
            
            let f = DateFormatter()
            let weekday = f.weekdaySymbols[Calendar.current.component(.weekday, from: pills[idx!].startReceptionDate)]
            var weekdayIdx = f.weekdaySymbols.firstIndex(of: weekday)
            
            var pillsInWeek: Float = 0.0
            
            for value in pills[idx!].isTappedWeekday {
                if value {
                    pillsInWeek += Float(pills[idx!].pillQuantity)!
                }
            }
            
            let weeks = Int(Float(pills[idx!].pillMaxQuantity)! / pillsInWeek)
            
            var restPills = Float(pills[idx!].pillMaxQuantity)! - Float(weeks) * pillsInWeek
            
            var countOfDays = 0
            
            while restPills > 0 {
                if pills[idx!].isTappedWeekday[weekdayIdx! % 7] {
                    restPills -= Float(pills[idx!].pillQuantity)!
                }
                countOfDays += 1
                weekdayIdx! += 1
            }
            endDate = calendar.date(byAdding: .day, value: weeks * 7 + countOfDays, to: pills[idx!].startReceptionDate)!
            let dateStr = dateFormatter.string(from: endDate)
            pills[idx!].endReceptionDate = dateFormatter.date(from: dateStr)!
            
        } else if pill.endByOption == 2 {
            endDate = calendar.date(byAdding: .day, value: Int(pills[idx!].pillMaxDay)!, to: pills[idx!].startReceptionDate)!
            let dateStr = dateFormatter.string(from: endDate)
            pills[idx!].endReceptionDate = dateFormatter.date(from: dateStr)!
            
        }
    }
    
    mutating func changeTabbed(in idx: Int) {
        pills[idx].pillTabbed.toggle()
    }
    
    mutating func setPillTabbedToFalse(for pill: Pill) {
        let idx = pills.firstIndex(where: {$0.id == pill.id})
        pills[idx!].pillTabbed = false
    }
    
    mutating func createPillFromFileManager(pill: Pill) {
        pills.append(pill)
        pills.sort { (pill1: Pill, pill2: Pill) -> Bool in
            return pill1.receptionTime < pill2.receptionTime
        }
    }
    
    func countRequiredQuantity(for pill: Pill) -> Float {
        let allDays = Float(pill.receptionDates.count)
        let acceptedDays = Float(pill.acceptedAt.count)
        return (allDays - acceptedDays) * Float(pill.pillQuantity)!
    }
    
    mutating func createPill(pillName: String, pillQuantity: String, receptionTime: Date, startReceptionDate: Date, endReceptionDate: Date, pillMaxQuantity: String, pillMaxDay: String, endByOption: Int?, receptionMode: Int?, id: UUID, pillTabbed: Bool, choosedMedicine: Medicine, receptionDatesMode: Int?) {
        var countTrue = 0
        for val in isTappedWeekday {
            if val {
                countTrue += 1
            }
        }
        if countTrue == 0 {
            isTappedWeekday = [true, true, true, true, true, true, true]
        }
        if receptionDatesMode != 2 {
            isTappedWeekday = [true, true, true, true, true, true, true]
        }
        
        
        pills.append(Pill(pillName: pillName, id: id, isTappedWeekday: isTappedWeekday, pillQuantity: pillQuantity, receptionTime: receptionTime, receptionMode: receptionMode, endByOption: endByOption, startReceptionDate: startReceptionDate, endReceptionDate: endReceptionDate, pillMaxQuantity: pillMaxQuantity, pillMaxDay: pillMaxDay, pillTabbed: pillTabbed, choosedMedicine: choosedMedicine, acceptedAt: [], receptionDatesMode: receptionDatesMode, receptionDates: []))
        countEndDate(for: pills[pills.count - 1])
        if (receptionDatesMode == 1) {
            everySecondDateFromStartDate(for: pills[pills.count - 1])
        } else if receptionDatesMode == 0{
            getEveryDayBetweenDays(for: pills[pills.count - 1])
        } else {
            getDatesByWeekdays(for: pills[pills.count - 1])
        }
        isTappedWeekday = [false, false, false, false, false, false, false]
        pills.sort { (pill1: Pill, pill2: Pill) -> Bool in
            return pill1.receptionTime < pill2.receptionTime
        }
    }
    
    mutating func getDatesByWeekdays(for pill: Pill) {
        let start = pill.startReceptionDate
        let end = pill.endReceptionDate
        let idx = pills.firstIndex(where: {$0.id == pill.id})
        let dis = Calendar.current.dateComponents([.day], from: start, to: end).day!
        var off = 0
        var dates: [Date] = []
        while off <= dis {
            let offDate = Calendar.current.date(byAdding: .day, value: off, to: start)
            let f = DateFormatter()
            let weekday = f.weekdaySymbols[(Calendar.current.component(.weekday, from: offDate!) + 5) % 7]
            let weekdayIdx = f.weekdaySymbols.firstIndex(of: weekday)
            if pill.isTappedWeekday[weekdayIdx!] {
                dates.append(Calendar.current.date(byAdding: .day, value: off, to: start)!)
            }
            off += 1
        }
        pills[idx!].receptionDates = dates
    }
    
    
    mutating func everySecondDateFromStartDate(for pill: Pill) {
        let start = pill.startReceptionDate
        let end = pill.endReceptionDate
        let idx = pills.firstIndex(where: {$0.id == pill.id})
        let dis = Calendar.current.dateComponents([.day], from: start, to: end).day!
        var i = true
        var off = 0
        var dates: [Date] = []
        while off <= dis {
            if i {
                dates.append(Calendar.current.date(byAdding: .day, value: off, to: start)!)
            }
            off += 1
            i.toggle()
        }
        pills[idx!].receptionDates = dates
    }
    
    mutating func getEveryDayBetweenDays(for pill: Pill) {
        let start = pill.startReceptionDate
        let end = pill.endReceptionDate
        let idx = pills.firstIndex(where: {$0.id == pill.id})
        let dis = Calendar.current.dateComponents([.day], from: start, to: end).day!
        var off = 0
        var dates: [Date] = []
        while off <= dis {
            dates.append(Calendar.current.date(byAdding: .day, value: off, to: start)!)
            off += 1
        }
        pills[idx!].receptionDates = dates
    }
    
    mutating func changeWeekdayTapped(in i: Int) {
        isTappedWeekday[i].toggle()
    }
    
    mutating func addAcceptedDay(to idx: Int, date: Date) {
        pills[idx].acceptedAt.append(date)
    }
    
    mutating func removeFromAcceptedDay(for idx: Int, date: Date) {
        pills[idx].acceptedAt = pills[idx].acceptedAt.filter{ $0 != date }
    }
    
    mutating func deletePill(idx: Int) {
        pills.remove(at: idx)
    }
}
