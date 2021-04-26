//
//  StudentSettingsViewController.swift
//  Register
//
//  Created by Светлана Романенко on 24.04.2021.
//

import UIKit

class StudentSettingsViewController: UIViewController {
    
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var markTextField: UITextField!
    @IBOutlet var navBar: UINavigationItem!
    
    var result: Student!
    var titleBar: String!
    var delegate: StudentSettingsViewControllerDelegate?
    var indexStudent: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameTextField.addTarget(
            self,
            action: #selector(firstNameTextFieldDidChanged),
            for: .editingChanged
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(saveSettings)
        )
        
        if result != nil {
        firstNameTextField.text = result.firstName
        lastNameTextField.text = result.lastName
        markTextField.text = "\(result.mark)"
        }
        
        navBar.title = titleBar
    }
    
    @objc private func saveSettings() {
        switch navBar.title {
        case titleNavBar.add.rawValue:
            saveAndExit()
        case titleNavBar.edit.rawValue:
            editAndExit(index: indexStudent)
        default: break
        }
    }
    
    @objc private func firstNameTextFieldDidChanged() {
        guard let firstName = firstNameTextField.text else { return }
        navigationItem.rightBarButtonItem?.isEnabled = !firstName.isEmpty ? true : false
    }
    
    private func saveAndExit() {
        guard
            firstNameTextField.text != nil &&
            !firstNameTextField.text!.isEmpty &&
            !firstNameTextField.text!.contains(" ") else {
            showAlert(title: "Wrong format", message: "Please enter correct name")
            firstNameTextField.text = ""
            return
        }
        guard
            lastNameTextField.text != nil &&
            !lastNameTextField.text!.isEmpty &&
            !lastNameTextField.text!.contains(" ")
        else {
            showAlert(title: "Wrong format", message: "Please enter correct surname")
            lastNameTextField.text = ""
            return
        }
        guard markTextField.text != nil  else {
            showAlert(title: "Wrong format", message: "Please enter mark")
            markTextField.text = ""
            return
        }
        guard let mark = Int(markTextField.text!) else {
            showAlert(title: "Wrong format", message: "Please enter integer format of mark")
            markTextField.text = ""
            return
        }
        
        guard mark>=1 && mark<=5 else {
            showAlert(title: "Wrong format", message: "Please enter correct mark")
            markTextField.text = ""
            return
        }
        let firstName = firstNameTextField.text
        let lastName = lastNameTextField.text
        
        let student = Student(firstName: firstName!, lastName: lastName!, mark: mark)
        StorageManager.shared.save(student: student)
        
        delegate?.saveStudent(student)
        dismiss(animated: true)
    }
    
    private func editAndExit(index: Int) {
        guard let firstName = firstNameTextField.text else { return }
        guard let lastName = lastNameTextField.text else { return }
        guard let mark = markTextField.text else { return }
        
        let student = Student(firstName: firstName, lastName: lastName, mark: Int(mark) ?? 0)
        StorageManager.shared.edit(at: index, student: student)
        
        delegate?.saveStudent(result)
        dismiss(animated: true)
    }
}

// MARK: - Alert Controller

extension StudentSettingsViewController {
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(
            title: "OK",
            style: .destructive
        )
        
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
}
