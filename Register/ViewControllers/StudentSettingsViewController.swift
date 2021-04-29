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
    
    var result: Student!
    var titleBar: String?
    var delegate: StudentSettingsViewControllerDelegate!
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
        
        title = titleBar
        
        if result != nil {
        firstNameTextField.text = result.firstName
        lastNameTextField.text = result.lastName
        markTextField.text = "\(result.mark)"
        }
    }
    
    @objc private func saveSettings() {
        if titleBar == titleNavBar.edit.rawValue {
            editAndExit(index: indexStudent)
        } else {
            saveAndExit()
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func firstNameTextFieldDidChanged() {
        guard let firstName = firstNameTextField.text else { return }
        navigationItem.rightBarButtonItem?.isEnabled = !firstName.isEmpty ? true : false
    }
    
    private func saveAndExit() {
        chekTF()
        
        let firstName = firstNameTextField.text
        let lastName = lastNameTextField.text
        let mark = Int(markTextField.text ?? "")
        
        let student = Student(firstName: firstName!, lastName: lastName!, mark: mark!)
        StorageManager.shared.save(student: student)
        
        delegate?.saveStudent(student)
    }
    
    private func editAndExit(index: Int) {
        chekTF()
        
        guard let firstName = firstNameTextField.text else { return }
        guard let lastName = lastNameTextField.text else { return }
        guard let mark = markTextField.text else { return }
        
        result.firstName = firstName
        result.lastName = lastName
        result.mark = Int(mark) ?? 0
        
        StorageManager.shared.edit(at: index, student: result)
        
        delegate?.editStudent(result, index)
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
    
    private func chekTF() {
        // Проверка на пустые поля
        guard
            firstNameTextField.text != nil &&
            !firstNameTextField.text!.isEmpty &&
            lastNameTextField.text != nil &&
            !lastNameTextField.text!.isEmpty &&
            markTextField.text != nil &&
            !markTextField.text!.isEmpty
        else {
            showAlert(title: "Не все поля заполнены", message: "Для сохранения данных необходимо заполнить все поля")
            return
        }
        
        // Проверка значения оценки
        guard
            Int(markTextField.text!) != nil
            && Int(markTextField.text!)! >= 1
            && Int(markTextField.text!)! <= 5
        else {
            showAlert(title: "Неправильно указана оценка", message: "Необходимо указать цифровое значение от 1 до 5")
            markTextField.text = ""
            return
        }
        
        // Проверка значения имени и фамилии на цифры и пробелы
        guard
            firstNameTextField.text!.contains(" ") &&
            lastNameTextField.text!.contains(" ") &&
            firstNameTextField.text!.contains("\(CharacterSet.decimalDigits)") &&
            lastNameTextField.text!.contains("\(CharacterSet.decimalDigits)")
        else {
            showAlert(title: "Неправильно указано имя или фамилия", message: "Укажите корректные имя и фамилию")
            firstNameTextField.text = ""
            lastNameTextField.text = ""
            return
        }
    }
}
