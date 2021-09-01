//
//  ViewController.swift
//  SignUp
//
//  Created by Jinyoung Kim on 2021/09/01.
//

import UIKit

class LogInViewController: UIViewController {

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        idTextField.addDoneButtonOnKeyboard()
        passTextField.addDoneButtonOnKeyboard()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        idTextField.text = UserInformation.shared.id
    }
    
    @IBAction func signupButtonTapped(_ sender: Any) {
        UserInformation.shared.resetUserInformation()
    }
}

