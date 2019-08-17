//
//  EmailLoginVC.swift
//  MindGarden
//
//  Created by Sunghee Lee on 05/08/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit

class EmailLoginVC: UIViewController {
    
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var alarmLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)

        setView()
        // Do any additional setup after loading the view.
    }
    
    func setView() {
        emailTF.delegate = self
        passwordTF.delegate = self
        
        emailTF.makeRounded(cornerRadius: 4)
        emailTF.setBorder(borderColor: UIColor.grayForBorder, borderWidth: 0.5)
        emailTF.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: emailTF.frame.height))
        emailTF.leftViewMode = .always
        
        passwordTF.makeRounded(cornerRadius: 4)
        passwordTF.setBorder(borderColor: UIColor.grayForBorder, borderWidth: 0.5)
        passwordTF.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: passwordTF.frame.height))
        passwordTF.leftViewMode = .always
        
        loginBtn.makeRounded(cornerRadius: 4)
        loginBtn.alpha = 0.6
        loginBtn.isEnabled = false
        
        alarmLabel.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged(_:)), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    @objc func textChanged(_ notification: NSNotification) {
        if !emailTF.text!.isEmpty && !passwordTF.text!.isEmpty {
            loginBtn.alpha = 1
            loginBtn.isEnabled = true
        } else {
            loginBtn.alpha = 0.6
            loginBtn.isEnabled = false
        }
    }
    
    @IBAction func resetBtnAction(_ sender: Any) {
        let dvc = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "ResetPw1VC")
        
        self.navigationController!.pushViewController(dvc, animated: true)
    }
    
    
    @IBAction func LoginBtnAction(_ sender: Any) {
        AuthService.shared.login(email: emailTF.text!, password: passwordTF.text!) { [weak self] data in
            guard let `self` = self else { return }
            
            switch data {
            case .success(let res):
                let data = res as! Login
                
                print(data.token)
                UserDefaults.standard.set(data.refreshToken, forKey: "refreshtoken")
                UserDefaults.standard.set(data.token, forKey: "token")
                UserDefaults.standard.set(data.email, forKey: "email")
                UserDefaults.standard.set(data.name, forKey: "name")
                
                if UserDefaults.standard.bool(forKey: "암호 설정") {
                    let dvc = UIStoryboard(name: "Lock", bundle: nil).instantiateViewController(withIdentifier: "LockVC") as! LockVC
                    
                    dvc.mode = LockMode.validate
                    
                    self.navigationController!.pushViewController(dvc, animated: true)
                } else {
                    let dvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainVC")
                    
                    self.navigationController!.pushViewController(dvc, animated: true)
                }
                
                break
            case .requestErr(let err):
                self.alarmLabel.isHidden = false
                self.emailTF.text = ""
                self.passwordTF.text = ""
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
    
    @IBAction func signupBtnAction(_ sender: Any) {
        let dvc = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "SignupVC")
        
        self.navigationController!.pushViewController(dvc, animated: true)
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}

extension EmailLoginVC : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGreen.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.grayForBorder.cgColor
    }
}
