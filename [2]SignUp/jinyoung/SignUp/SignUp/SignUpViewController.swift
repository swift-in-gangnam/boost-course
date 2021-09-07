//
//  SignUpViewController.swift
//  SignUp
//
//  Created by Jinyoung Kim on 2021/09/01.
//

import UIKit

class SignUpViewController: UIViewController {
    
    lazy var imagePicker: UIImagePickerController = {
        let picker: UIImagePickerController = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        return picker
    }()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    @IBOutlet weak var introduceTextView: UITextView!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        idTextField.delegate = self
        passTextField.delegate = self
        confirmTextField.delegate = self
        introduceTextView.delegate = self
        
        idTextField.addDoneButtonOnKeyboard()
        passTextField.addDoneButtonOnKeyboard()
        confirmTextField.addDoneButtonOnKeyboard()
        introduceTextView.addDoneButtonOnKeyboard()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        
        nextButton.isEnabled = false
    }
    
    @objc func imageTapped() {
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cancelSignup() {
        UserInformation.shared.resetUserInformation()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextSignup(_ sender: Any) {
        UserInformation.shared.id = idTextField.text
    }
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let originalImage: UIImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imageView.image = originalImage
        }
        self.dismiss(animated: true, completion: nil)
    }
}

extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == idTextField {
            passTextField.becomeFirstResponder()
        } else if textField == passTextField {
            confirmTextField.becomeFirstResponder()
        } else if textField == confirmTextField {
            introduceTextView.becomeFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkAndSwitchNextButton()
    }
}

extension SignUpViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        checkAndSwitchNextButton()
    }
}

extension SignUpViewController {
    
    func checkAndSwitchNextButton() {
        if let _ = imageView.image,
           let t1 = idTextField.text,
           let t2 = passTextField.text,
           let t3 = confirmTextField.text,
           !t1.isEmpty && !t2.isEmpty && !t3.isEmpty && !introduceTextView.text.isEmpty && t2 == t3 {
            nextButton.isEnabled = true
        } else {
            nextButton.isEnabled = false
        }
    }
}
