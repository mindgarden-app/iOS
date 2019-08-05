//
//  SigninVC.swift
//  MindGarden
//
//  Created by Sunghee Lee on 23/07/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit

class SignupVC: UIViewController {

    @IBOutlet var emailTF: UITextField!
    @IBOutlet var nameTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    @IBOutlet var passwordCheckTF: UITextField!
    @IBOutlet var emailDescLabel: UILabel!
    @IBOutlet var nameDescLabel: UILabel!
    @IBOutlet var passwordDescLabel: UILabel!
    @IBOutlet var passwordCheckDescLabel: UILabel!
    @IBOutlet var agreeBtn: UIButton!
    @IBOutlet var signupBtn: UIBarButtonItem!
    
    var isAgree: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setView()
    }
    
    func setView() {
        emailTF.delegate = self
        nameTF.delegate = self
        passwordTF.delegate = self
        passwordCheckTF.delegate = self
        
        emailTF.makeRounded(cornerRadius: 4)
        emailTF.setBorder(borderColor: UIColor.grayForBorder, borderWidth: 0.5)
        emailTF.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: emailTF.frame.height))
        emailTF.leftViewMode = .always
        
        nameTF.makeRounded(cornerRadius: 4)
        nameTF.setBorder(borderColor: UIColor.grayForBorder, borderWidth: 0.5)
        nameTF.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: passwordTF.frame.height))
        nameTF.leftViewMode = .always
        
        passwordTF.makeRounded(cornerRadius: 4)
        passwordTF.setBorder(borderColor: UIColor.grayForBorder, borderWidth: 0.5)
        passwordTF.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: passwordTF.frame.height))
        passwordTF.leftViewMode = .always
        
        passwordCheckTF.makeRounded(cornerRadius: 4)
        passwordCheckTF.setBorder(borderColor: UIColor.grayForBorder, borderWidth: 0.5)
        passwordCheckTF.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: passwordTF.frame.height))
        passwordCheckTF.leftViewMode = .always
        
        signupBtn.isEnabled = false

        NotificationCenter.default.addObserver(self, selector: #selector(textChanged(_:)), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    @objc func textChanged(_ notification: NSNotification) {
        if !emailTF.text!.isEmpty && !nameTF.text!.isEmpty && !passwordTF.text!.isEmpty && !passwordCheckTF.text!.isEmpty {
            signupBtn.isEnabled = true
        } else {
            signupBtn.isEnabled = false
        }
    }

    @IBAction func agreeBtnAction(_ sender: Any) {
        if isAgree {
            isAgree = false
            agreeBtn.setImage(UIImage(named: "btnCheckboxOff"), for: .normal)
        } else {
            isAgree = true
            agreeBtn.setImage(UIImage(named: "btnCheckboxOn"), for: .normal)
        }
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signupBtnAction(_ sender: Any) {
        var isError = false
        
        if !emailTF.text!.validateEmail() {
            isError = true
            emailDescLabel.isHidden = false
        }
        
        if !passwordTF.text!.validatePassword() {
            isError = true
            passwordDescLabel.isHidden = false
        }
        
        if passwordTF.text! != passwordCheckTF.text! {
            isError = true
            passwordCheckDescLabel.isHidden = false
        }
        
        if !isError {
            // 가입 api
        }
    }
    
}

extension SignupVC : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGreen.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.grayForBorder.cgColor
    }
}

