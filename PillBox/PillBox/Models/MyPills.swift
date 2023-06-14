//
//  MyPills.swift
//  PillBox
//
//  Created by Максим Троицкий 
//

import Foundation
import SwiftUI

struct Medicine: Identifiable, Hashable, Encodable, Decodable {
    var medicineName: String
    var id: UUID
    var typeOfDosage: Int
    var expirationDate: Date
    var restOfMedicine: String
    var totalMedicine: String
    var medicineIcon: String
    var isDeleted: Bool
}

struct MyPills {
    
    private(set) var medicines: [Medicine]
    
    init() {
        medicines = []
    }
    
    mutating func clearBase() {
        medicines = []
    }

    mutating func createPillBoxFromFileManager(medicine: Medicine) {
        medicines.append(medicine)
        medicines.sort { (med1: Medicine, med2: Medicine) -> Bool in
            return med1.expirationDate < med2.expirationDate
        }
    }
    
    mutating func createMedicine(medicineName: String, id: UUID, typeOfDosage: Int, expirationDate: Date, restOfMedicine: String, medicineIcon: String) {
        medicines.append(Medicine(medicineName: medicineName, id: id, typeOfDosage: typeOfDosage, expirationDate: expirationDate, restOfMedicine: restOfMedicine, totalMedicine: restOfMedicine, medicineIcon: medicineIcon, isDeleted: false))
        medicines.sort { (med1: Medicine, med2: Medicine) -> Bool in
            return med1.expirationDate < med2.expirationDate
        }
    }
    
    mutating func deleteMedicine(idx: Int) {
        medicines[idx].isDeleted = true
    }
    
    mutating func increaseNumberOfMedicine(for idx: Int, in quant: String) {
        let rest = Float(medicines[idx].restOfMedicine)! + Float(quant)!
        medicines[idx].restOfMedicine = String(rest)
    }
    
    mutating func reduceNumberOfMedicine(for idx: Int, in quant: String) {
        let rest = Float(medicines[idx].restOfMedicine)! - Float(quant)!
        medicines[idx].restOfMedicine = String(rest)
        
    }
}
