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
    var emailError: Bool = false
    var nameError: Bool = false
    var passwordError: Bool = false
    var passwordCheckError: Bool = false
    
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
        emailDescLabel.isHidden = true
        nameDescLabel.isHidden = true
        passwordDescLabel.isHidden = true
        passwordCheckDescLabel.isHidden = true

        NotificationCenter.default.addObserver(self, selector: #selector(textChanged(_:)), name: UITextField.textDidChangeNotification, object: nil)
        
        emailTF.addTarget(self, action: #selector(emailTFDidChange(textField:)), for: .editingChanged)
        nameTF.addTarget(self, action: #selector(nameTFDidChange(textField:)), for: .editingChanged)
        passwordTF.addTarget(self, action: #selector(passwordTFDidChange(textField:)), for: .editingChanged)
        passwordCheckTF.addTarget(self, action: #selector(passwordCheckTFDidChange(textField:)), for: .editingChanged)
    }
    
    @objc func emailTFDidChange(textField: UITextField) {
        if emailTF.text!.validateEmail() {
            emailError = false
            emailDescLabel.isHidden = true
            emailTF.setBorder(borderColor: UIColor.lightGreen, borderWidth: 1)
        } else {
            emailError = true
            emailDescLabel.isHidden = false
            emailDescLabel.text = "올바른 이메일 형식이 아닙니다."
            emailTF.setBorder(borderColor: UIColor.red, borderWidth: 1)
        }
    }
    
    @objc func nameTFDidChange(textField: UITextField) {
        if nameTF.text!.validateName() {
            nameError = false
            nameDescLabel.isHidden = true
            nameTF.setBorder(borderColor: UIColor.lightGreen, borderWidth: 1)
        } else {
            nameError = true
            nameDescLabel.isHidden = false
            nameTF.setBorder(borderColor: UIColor.red, borderWidth: 1)
        }
    }
    
    @objc func passwordTFDidChange(textField: UITextField) {
        if passwordTF.text!.validatePassword() {
            passwordError = false
            passwordDescLabel.isHidden = true
            passwordTF.setBorder(borderColor: UIColor.lightGreen, borderWidth: 1)
        } else {
            passwordError = true
            passwordDescLabel.isHidden = false
            passwordTF.setBorder(borderColor: UIColor.red, borderWidth: 1)
        }
    }
    
    @objc func passwordCheckTFDidChange(textField: UITextField) {
        if passwordTF.text! != passwordCheckTF.text! {
            passwordCheckError = true
            passwordCheckDescLabel.isHidden = false
            passwordCheckTF.setBorder(borderColor: UIColor.red, borderWidth: 1)
        } else {
            passwordCheckError = false
            passwordCheckDescLabel.isHidden = true
            passwordCheckTF.setBorder(borderColor: UIColor.lightGreen, borderWidth: 1)
        }
    }
    
    @objc func textChanged(_ notification: NSNotification) {
        if !emailError && !nameTF.text!.isEmpty && !passwordError && !passwordCheckError {
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
        if !emailError && !passwordError && !passwordCheckError {
            AuthService.shared.signup(email: emailTF.text!, password: passwordTF.text!, name: nameTF.text!) { [weak self] data in
                guard let `self` = self else { return }
                
                switch data {
                case .success(let res):
                    let popUpVC = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "SignupPopUpVC") as! SignupPopUpVC
                    self.addChild(popUpVC)
                    popUpVC.view.frame = self.view.frame
                    self.view.addSubview(popUpVC.view)
                    popUpVC.didMove(toParent: self)
                    
                    break
                case .requestErr(let err):
                    if(String(describing: err) == "중복된 email이 존재합니다.") {
                        self.emailError = true
                        self.emailDescLabel.isHidden = false
                        self.emailDescLabel.text = "이미 등록된 이메일입니다."
                        self.emailTF.setBorder(borderColor: UIColor.red, borderWidth: 1)
                    }
                    print(".requestErr(\(err))")
                    break
                case .pathErr:
                    print("경로 에러")
                    break
                case .serverErr:
                    print("서버 에러")
                    break
                case .networkFail:
                    self.simpleAlert(title: "통신 실패", message: "네트워크 상태를 확인하세요.")
                    break
                }
            }
        }
    }
    
    @IBAction func tosBtnAction(_ sender: Any) {
        let dvc = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "PolicyVC") as! PolicyVC
        
        dvc.policyNum = 1
        
        self.navigationController!.pushViewController(dvc, animated: true)
    }
    
    @IBAction func privacyPolicyBtnAction(_ sender: Any) {
        let dvc = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "PolicyVC") as! PolicyVC
        
        dvc.policyNum = 2
        
        self.navigationController!.pushViewController(dvc, animated: true)
    }
    
}

extension SignupVC : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGreen.cgColor
        
        switch textField {
        case emailTF:
            if emailError {
                emailTF.setBorder(borderColor: UIColor.red, borderWidth: 1)
            }
        case nameTF:
            if nameError {
                nameTF.setBorder(borderColor: UIColor.red, borderWidth: 1)
            }
        case passwordTF:
            if passwordError {
                passwordTF.setBorder(borderColor: UIColor.red, borderWidth: 1)
            }
        case passwordCheckTF:
            if passwordError {
                passwordCheckTF.setBorder(borderColor: UIColor.red, borderWidth: 1)
            }
        default:
            break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.grayForBorder.cgColor
        
        switch textField {
        case emailTF:
            if emailError {
                emailTF.setBorder(borderColor: UIColor.red, borderWidth: 1)
            }
        case nameTF:
            if nameError {
                nameTF.setBorder(borderColor: UIColor.red, borderWidth: 1)
            }
        case passwordTF:
            if passwordError {
                passwordTF.setBorder(borderColor: UIColor.red, borderWidth: 1)
            }
        case passwordCheckTF:
            if passwordError {
                passwordCheckTF.setBorder(borderColor: UIColor.red, borderWidth: 1)
            }
        default:
            break
        }
    }
}

