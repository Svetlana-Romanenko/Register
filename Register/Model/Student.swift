//
//  Student.swift
//  Register
//
//  Created by Светлана Романенко on 26.04.2021.
//

struct Student: Codable {
    var firstName: String
    var lastName: String
    var mark: Int
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
}
