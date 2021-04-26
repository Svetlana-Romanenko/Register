//
//  StorageManager.swift
//  Register
//
//  Created by Светлана Романенко on 24.04.2021.
//

import Foundation

class StorageManager {
    static var shared = StorageManager()
    
    private let userDefaults = UserDefaults.standard
    private let studentKey = "students"
    private let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private let archiveURL: URL
    
    private init() {
        archiveURL = documentDirectory.appendingPathComponent("Register").appendingPathExtension("plist")
    }
    
    func save(student: Student) {
        var students = fetchStudents()
        students.append(student)
        guard let data = try? PropertyListEncoder().encode(students) else { return }
        try? data.write(to: archiveURL, options: .noFileProtection)
    }
    
    func fetchStudents() -> [Student] {
        guard let data = try? Data(contentsOf: archiveURL) else { return [] }
        guard let students = try? PropertyListDecoder().decode([Student].self, from: data) else { return [] }
        return students
    }
    
    func deleteStudent(at index: Int) {
        var students = fetchStudents()
        students.remove(at: index)
        guard let data = try? PropertyListEncoder().encode(students) else { return }
        try? data.write(to: archiveURL, options: .noFileProtection)
    }
    
    func edit(at index: Int, student: Student) {
        deleteStudent(at: index)
        save(student: student)
    }
}
