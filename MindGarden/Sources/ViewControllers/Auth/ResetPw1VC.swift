//
//  resetPW1.swift
//  MindGarden
//
//  Created by Sunghee Lee on 05/08/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit

class ResetPw1VC: UIViewController {

    @IBOutlet var descLabel: UILabel!
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var sendEmailBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setView()
    }
    
    func setView() {
        emailTF.delegate = self
        
        let formattedString = NSMutableAttributedString()
        formattedString
            .normal("이메일 주소를 입력하면,")
            .bold("\n새로운 비밀번호")
            .normal("를 메일로 보내드립니다.")
        
        descLabel.attributedText = formattedString
        
        emailTF.makeRounded(cornerRadius: 4)
        emailTF.setBorder(borderColor: UIColor.grayForBorder, borderWidth: 0.5)
        emailTF.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: emailTF.frame.height))
        emailTF.leftViewMode = .always
        
        sendEmailBtn.makeRounded(cornerRadius: 4)
        sendEmailBtn.alpha = 0.6
        sendEmailBtn.isEnabled = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged(_:)), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    @objc func textChanged(_ notification: NSNotification) {
        if !emailTF.text!.isEmpty {
            sendEmailBtn.alpha = 1
            sendEmailBtn.isEnabled = true
        } else {
            sendEmailBtn.alpha = 0.6
            sendEmailBtn.isEnabled = false
        }
    }
    
    @IBAction func sendEmailBtnAction(_ sender: Any) {
        AuthService.shared.resetPassword(email: emailTF.text!) { [weak self] data in
            guard let `self` = self else { return }
            
            switch data {
            case .success(let message):
                if String(describing: message) == "메일 전송 성공" {
                    let dvc = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "ResetPw2VC")
                    
                    self.navigationController!.pushViewController(dvc, animated: true)
                } else {
                    print(message)
                }
                break
            case .requestErr(let err):
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
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}

extension ResetPw1VC : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGreen.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.grayForBorder.cgColor
    }
}
