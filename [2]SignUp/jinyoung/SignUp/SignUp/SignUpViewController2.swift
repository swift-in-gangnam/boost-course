//
//  SignUpViewController2.swift
//  SignUp
//
//  Created by Jinyoung Kim on 2021/09/01.
//

import UIKit

class SignUpViewController2: UIViewController {

    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var confirmButton: UIButton!
    
    private let dateFormatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneNumberTextField.delegate = self
        confirmButton.isEnabled = false
        phoneNumberTextField.addDoneButtonOnKeyboard()
        
        let date = datePicker.date
        let dateString = dateFormatter.string(from: date)
        birthdayLabel.text = dateString
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        phoneNumberTextField.text = UserInformation.shared.phoneNumber
        if let birthdayDate = UserInformation.shared.birthdayDate {
            datePicker.date = birthdayDate
            birthdayLabel.text = dateFormatter.string(from: birthdayDate)
        }
        
        checkAndSwitchConfirmButton()
    }
    

    @IBAction func didDatePickerValueChanged(_ sender: Any) {
        let date = datePicker.date
        let dateString = dateFormatter.string(from: date)
        birthdayLabel.text = dateString
        
        checkAndSwitchConfirmButton()
    }
    
    @IBAction func cancelSignup(_ sender: Any) {
        UserInformation.shared.resetUserInformation()
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func previousSignup(_ sender: Any) {
        UserInformation.shared.phoneNumber = phoneNumberTextField.text
        UserInformation.shared.birthdayDate = datePicker.date
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirmSignup(_ sender: Any) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

extension SignUpViewController2: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkAndSwitchConfirmButton()
    }
}

extension SignUpViewController2 {
    
    func checkAndSwitchConfirmButton() {
        if let phoneNumber = phoneNumberTextField.text,
           let birthDay = birthdayLabel.text,
           !phoneNumber.isEmpty && !birthDay.isEmpty {
            confirmButton.isEnabled = true
        } else {
            confirmButton.isEnabled = false
        }
    }
}
