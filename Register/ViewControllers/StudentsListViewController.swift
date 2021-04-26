//
//  StudentsListViewController.swift
//  Register
//
//  Created by Светлана Романенко on 24.04.2021.
//

import UIKit

enum titleNavBar: String {
    case edit = "Редактирование студента"
    case add = "Добавление студента"
}

protocol StudentSettingsViewControllerDelegate {
    func saveStudent(_ student: Student)
}

class StudentsListViewController: UITableViewController {
    
    private var students: [Student] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        students = StorageManager.shared.fetchStudents()
    }
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settings" {
            let studentSettingsVC = segue.destination as! StudentSettingsViewController
            let indexPath = tableView.indexPathForSelectedRow
            studentSettingsVC.result = students[indexPath?.row ?? 0]
            studentSettingsVC.indexStudent = indexPath?.row
            studentSettingsVC.titleBar = titleNavBar.edit.rawValue
        } else {
            let studentAdditingVC = segue.destination as! StudentSettingsViewController
            studentAdditingVC.delegate = self
            studentAdditingVC.titleBar = titleNavBar.add.rawValue
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        students.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let student = students[indexPath.row]
        
        if #available(iOS 14.0, *) {
            var content = cell.defaultContentConfiguration()
            content.text = student.fullName
            content.secondaryText = "\(student.mark)"
            cell.contentConfiguration = content
        } else {
            cell.textLabel?.text = student.fullName
            cell.detailTextLabel?.text = "\(student.mark)"
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
        StorageManager.shared.deleteStudent(at: indexPath.row)
        students.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

    // MARK: - StudentListViewControllerDelegate

extension StudentsListViewController: StudentSettingsViewControllerDelegate {
    func saveStudent(_ student: Student) {
    students.append(student)
    tableView.reloadData()
    }
}

