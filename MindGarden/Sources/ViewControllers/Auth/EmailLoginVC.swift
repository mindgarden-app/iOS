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
    }
    
    
    @IBAction func LoginBtnAction(_ sender: Any) {
    }
    
    @IBAction func signupBtnAction(_ sender: Any) {
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
