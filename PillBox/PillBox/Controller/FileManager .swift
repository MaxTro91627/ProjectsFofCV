//
//  FileManager .swift
//  PillBox
//
//  Created by Максим Троицкий
//

import Foundation
import UIKit

class LocalFileManager {
    static let instance = LocalFileManager()
    
    init() {
        createPillFolderIfNeeded()
        createPillBoxFolderIfNeeded()
        initMedicine() // Заранее заданные значения для демонстрации работы приложения
    }
    
    func initMedicine() {
        saveMedicine(medicine: Medicine(medicineName: "SomeName", id: UUID(uuidString: "424EB438-3F10-4A64-BDEF-7763BDB03FD8")!, typeOfDosage: 2, expirationDate: Date(), restOfMedicine: "10", totalMedicine: "10", medicineIcon: "pill", isDeleted: false), medicineId: "424EB438-3F10-4A64-BDEF-7763BDB03FD8")
        saveMedicine(medicine: Medicine(medicineName: "NewName", id: UUID(uuidString: "C3645457-2AD5-40B3-8CFD-75A64C9CDB67")!, typeOfDosage: 4, expirationDate: Date(), restOfMedicine: "10", totalMedicine: "10", medicineIcon: "drops", isDeleted: false), medicineId: "C3645457-2AD5-40B3-8CFD-75A64C9CDB67")
        saveMedicine(medicine:  Medicine(medicineName: "Name1", id: UUID(uuidString: "311D67F9-C69F-4B7C-B48D-4479382A0DA0")!, typeOfDosage: 2, expirationDate: Date(), restOfMedicine: "10", totalMedicine: "10", medicineIcon: "pill", isDeleted: false), medicineId: "311D67F9-C69F-4B7C-B48D-4479382A0DA0")
        saveMedicine(medicine: Medicine(medicineName: "Name2", id: UUID(uuidString: "1391727A-9203-4125-AC16-1A390D66C76C")!, typeOfDosage: 2, expirationDate: Date(), restOfMedicine: "10", totalMedicine: "10", medicineIcon: "spoon", isDeleted: false), medicineId: "1391727A-9203-4125-AC16-1A390D66C76C")
        saveMedicine(medicine: Medicine(medicineName: "Name3", id: UUID(uuidString: "496FEF4D-2D5B-4951-89E3-588A90F564D5")!, typeOfDosage: 2, expirationDate: Date(), restOfMedicine: "10", totalMedicine: "10", medicineIcon: "teaspoon", isDeleted: false), medicineId: "496FEF4D-2D5B-4951-89E3-588A90F564D5")
        saveMedicine(medicine: Medicine(medicineName: "Name4", id: UUID(uuidString: "6203C390-1388-45B0-B979-95D1F3C502F3")!, typeOfDosage: 2, expirationDate: Date(), restOfMedicine: "10", totalMedicine: "10", medicineIcon: "more", isDeleted: false), medicineId: "6203C390-1388-45B0-B979-95D1F3C502F3")
        saveMedicine(medicine: Medicine(medicineName: "Name5", id: UUID(uuidString: "2025D469-CCF3-4F17-83C7-F4EDCB6326D1")!, typeOfDosage: 2, expirationDate: Date(), restOfMedicine: "10", totalMedicine: "10", medicineIcon: "syringe", isDeleted: false), medicineId: "2025D469-CCF3-4F17-83C7-F4EDCB6326D1")
        saveMedicine(medicine: Medicine(medicineName: "Name6", id: UUID(uuidString: "6ED05482-418A-4251-8ADE-0096FC28A1F3")!, typeOfDosage: 2, expirationDate: Date(), restOfMedicine: "10", totalMedicine: "10", medicineIcon: "more", isDeleted: false), medicineId: "6ED05482-418A-4251-8ADE-0096FC28A1F3")
        saveMedicine(medicine: Medicine(medicineName: "Name7", id: UUID(uuidString: "3B52E53F-E4AF-4F0A-BDB1-E29D685E9FF5")!, typeOfDosage: 2, expirationDate: Date(), restOfMedicine: "10", totalMedicine: "10", medicineIcon: "pill", isDeleted: false), medicineId: "3B52E53F-E4AF-4F0A-BDB1-E29D685E9FF5")
        saveMedicine(medicine: Medicine(medicineName: "Name8", id: UUID(uuidString: "6E9317AE-B605-43B4-8B65-3BBA278FF784")!, typeOfDosage: 2, expirationDate: Date(), restOfMedicine: "10", totalMedicine: "10", medicineIcon: "drops", isDeleted: false), medicineId: "6E9317AE-B605-43B4-8B65-3BBA278FF784")
    }
    
    func createPillBoxFolderIfNeeded() {
        guard
            let path = FileManager
                .default
                .urls(for: .documentDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent ("User_PillBox")
                .path else {
            return
        }
        if !FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
                print("Success creating folder. ")
            } catch let error {
                print("Error creating folder. \(error)")
            }
        }
    }
    
    func createPillFolderIfNeeded() {
        guard
            let path = FileManager
                .default
                .urls(for: .documentDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent ("User_Pills")
                .path else {
            return
        }
        if !FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
                print("Success creating folder. ")
            } catch let error {
                print("Error creating folder. \(error)")
            }
        }
    }
    
    func getMedicine(medicineId: URL) -> Medicine {
        var medicine: Medicine? = nil
        do {
            let data = try Data(contentsOf: medicineId)
            let decodedresults = try JSONDecoder().decode(Medicine.self, from: data)
            medicine = decodedresults
        } catch let error {
            print("\(error)")
        }
        return medicine!
    }
    
    func getPill(pillId: URL) -> Pill {
        var pill: Pill? = nil
        do {
            let data = try Data(contentsOf: pillId)
            let decodedresults = try JSONDecoder().decode(Pill.self, from: data)
            pill = decodedresults
        } catch let error {
            print("\(error)")
        }
        return pill!
    }
    
    func getPathForPill(name: String) -> URL? {
        guard
            let path = FileManager
                .default
                .urls(for: .documentDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent("User_Pills")
                .appendingPathComponent("\(name).json") else {
            print("Error getting path")
            return nil
        }
        return path
    }
    
    func getPathForMedicine(name: String) -> URL? {
        guard
            let path = FileManager
                .default
                .urls(for: .documentDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent("User_PillBox")
                .appendingPathComponent("\(name).json") else {
            print("Error getting path")
            return nil
        }
        return path
    }
    
    func savePill(pill: Pill, pillId: String) {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let documentURL = (directoryURL?.appendingPathComponent("User_Pills").appendingPathComponent(pillId).appendingPathExtension("json"))!
        let jsonEncoder = JSONEncoder()
        let data = try? jsonEncoder.encode(pill)
        do {
            try data?.write(to: documentURL, options: .noFileProtection)
            return
        } catch {
            return
        }
    }
    
    func saveMedicine(medicine: Medicine, medicineId: String) {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let documentURL = (directoryURL?.appendingPathComponent("User_PillBox").appendingPathComponent(medicineId).appendingPathExtension("json"))!
        let jsonEncoder = JSONEncoder()
        let data = try? jsonEncoder.encode(medicine)
        do {
            try data?.write(to: documentURL, options: .noFileProtection)
            return
        } catch {
            return
        }
    }
    
    func deleteMedicine(medicineId: String) {
        guard
            let path = getPathForMedicine(name: medicineId)?.path,
            FileManager.default.fileExists(atPath: path) else {
            return
        }
        do {
            try FileManager.default.removeItem(atPath: path)
            return
        } catch {
            return
        }
    }
    
    func deletePill(pillId: String) {
        guard
            let path = getPathForPill(name: pillId)?.path,
            FileManager.default.fileExists(atPath: path) else {
            return
        }
        do {
            try FileManager.default.removeItem(atPath: path)
            return
        } catch {
            return
        }
    }
    func clearBase() {
        guard
            let path_pill = FileManager
                .default
                .urls(for: .documentDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent("User_Pills")
                .path else {
            return
        }
        do {
            try FileManager.default.removeItem(atPath: path_pill)
        } catch {
            print("error deleting folder")
        }
        guard
            let path_pillBox = FileManager
                .default
                .urls(for: .documentDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent("User_PillBox")
                .path else {
            return
        }
        do {
            try FileManager.default.removeItem(atPath: path_pillBox)
        } catch {
            print("error deleting folder")
        }
    }
}

class FileManagerViewModel: ObservableObject {
    let manager = LocalFileManager.instance
    init() {}
    
    func getPillBoxFromFileManager(medicineId: URL) -> Medicine {
        let medicine = manager.getMedicine(medicineId: medicineId)
        return medicine
    }
    
    func getPillFromFileManager(pillId: URL) -> Pill {
        let pill = manager.getPill(pillId: pillId)
        return pill
    }
    func savePill(pill: Pill) {
        manager.savePill(pill: pill, pillId: pill.id.uuidString)
    }
    func saveMedicine(medicine: Medicine) {
        manager.saveMedicine(medicine: medicine, medicineId: medicine.id.uuidString)
    }
    func deletePill(pillId: String) {
        manager.deletePill(pillId: pillId)
    }
    func deleteMedicine(medicineId: String) {
        manager.deleteMedicine(medicineId: medicineId)
    }
    func rewritePill(pill: Pill) {
        manager.deletePill(pillId: pill.id.uuidString)
        manager.savePill(pill: pill, pillId: pill.id.uuidString)
    }
    func rewriteMedicine(medicine: Medicine) {
        manager.deleteMedicine(medicineId: medicine.id.uuidString)
        manager.saveMedicine(medicine: medicine, medicineId: medicine.id.uuidString)
    }
    func clearBase() {
        manager.clearBase()
    }
}

extension FileManager {
    func urlss(for directory: FileManager.SearchPathDirectory, idx: Int, skipsHiddenFiles: Bool = true ) -> [URL]? {
        let neededFolterArr = ["User_Pills", "User_PillBox"]
        let documentsURL = urls(for: directory, in: .userDomainMask)[0]
            .appendingPathComponent(neededFolterArr[idx])
        let fileURLs = try? contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: skipsHiddenFiles ? .skipsHiddenFiles : [] )
        return fileURLs
    }
}
