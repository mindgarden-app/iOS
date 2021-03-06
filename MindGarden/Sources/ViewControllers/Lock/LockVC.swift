//
//  LockVC.swift
//  MindGarden
//
//  Created by Sunghee Lee on 03/07/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit
import LocalAuthentication
import NVActivityIndicatorView

public enum LockMode {
    case validate
    case change
    case create
}

class LockVC: UIViewController {
    
    @IBOutlet var closeBtn: UIButton!
    @IBOutlet var passcodeCV: UICollectionView!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var passcodeResetBtn: UIButton!
    @IBOutlet var passcodeImg1: UIImageView!
    @IBOutlet var passcodeImg2: UIImageView!
    @IBOutlet var passcodeImg3: UIImageView!
    @IBOutlet var passcodeImg4: UIImageView!
    
    var mode: LockMode!
    var selectedNumIdx: Int!
    var stageForChange: Int = 0
    var codeArr: [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "", "0", "<"]
    var inputNumber: String = ""
    var newPasscode: Int!
    var error: NSError?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        setDescriptionLabel()
        
        registerCVC()
        passcodeCV.delegate = self
        passcodeCV.dataSource = self
        
        if mode == .validate {
            closeBtn.isHidden = true
            useBiometricAuthentication()
        } else {
            navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }
    }
    
    func setDescriptionLabel() {
        if mode == .create {
            descriptionLabel.text = "비밀번호를 입력해주세요."
        } else if mode == .change {
            descriptionLabel.text = "기존 비밀번호를 입력해주세요."
        } else if mode == .validate {
            descriptionLabel.text = "비밀번호를 입력해주세요."
            passcodeResetBtn.setTitle("비밀번호를 잊어버리셨나요?", for: .normal)
            descriptionLabel.textAlignment = .center
            descriptionLabel.frame = CGRect(x: 0, y: 0, width: descriptionLabel.intrinsicContentSize.width, height: descriptionLabel.intrinsicContentSize.width)
        }
    }
    
    @IBAction func closeBtnAction(_ sender: Any) {
        self.pop()
    }
    
    func changePasscodeImg(count: Int) {
        let passcodeImgArr: [UIImageView] = [passcodeImg1, passcodeImg2, passcodeImg3, passcodeImg4]
        
        for i in 0...passcodeImgArr.count - 1 {
            if i < count {
                passcodeImgArr[i].image = UIImage(named: "imgPasswordOn")
            } else {
                passcodeImgArr[i].image = UIImage(named: "imgPasswordOff")
            }
        }
    }
    
    func registerCVC() {
        let nibName = UINib(nibName: "LockCodeCVC", bundle: nil)
        passcodeCV.register(nibName, forCellWithReuseIdentifier: "LockCodeCVC")
    }
    
    @IBAction func resetBtnAction(_ sender: Any) {
        if UserDefaults.standard.string(forKey: "email") == "not email" {
            self.simpleAlert(title: "이메일 없음", message: "이메일 제공 동의를 하지 않으셨습니다.")
            return;
        }
        let message = "\(String(describing: UserDefaults.standard.string(forKey: "email")!))으로\n새로운 비밀번호를 보내겠습니까?"
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "메일 보내기", style: .destructive, handler: { action in
            AuthService.shared.resetPasscode() { [weak self] data in
                guard let `self` = self else { return }
                
                switch data {
                case .success(let rand):
                    self.passcodeResetBtn.setTitle("메일로 발송된 번호를 입력하세요.", for: .normal)
                    UserDefaults.standard.set(rand, forKey: "passcode")
                    break
                case .requestErr(let err):
                    print(".requestErr(\(err))")
                    if String(describing: err) == "만료된 토큰입니다." {
                        AuthService.shared.refreshAccesstoken() { [weak self] data in
                            guard let `self` = self else { return }
                            
                            switch data {
                            case .success(let res):
                                let data = res as! Token
                                print(res)
                                UserDefaults.standard.set(data.token, forKey: "token")
                                break
                            case .requestErr(let err):
                                print(".requestErr(\(err))")
                                AuthService.shared.resetPasscode() { [weak self] data in
                                    guard let `self` = self else { return }
                                    
                                    switch data {
                                    case .success(let rand):
                                        self.passcodeResetBtn.setTitle("메일로 발송된 번호를 입력하세요.", for: .normal)
                                        UserDefaults.standard.set(rand, forKey: "passcode")
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
        })
        let cancelAction = UIAlertAction(title: "취소", style: .default, handler: nil)
        okAction.setValue(UIColor.lightGreen, forKey: "titleTextColor")
        cancelAction.setValue(UIColor.Gray, forKey: "titleTextColor")
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showfailAnimation() {
        UIView.animate(withDuration: 0.1, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.passcodeImg1.center.x += 10
            self.passcodeImg2.center.x += 10
            self.passcodeImg3.center.x += 10
            self.passcodeImg4.center.x += 10
        }, completion: nil)
        UIView.animate(withDuration: 0.1, delay: 0.1, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.passcodeImg1.center.x -= 20
            self.passcodeImg2.center.x -= 20
            self.passcodeImg3.center.x -= 20
            self.passcodeImg4.center.x -= 20
        }, completion: nil)
        UIView.animate(withDuration: 0.1, delay: 0.2, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.passcodeImg1.center.x += 10
            self.passcodeImg2.center.x += 10
            self.passcodeImg3.center.x += 10
            self.passcodeImg4.center.x += 10
        }, completion: nil)
    }
    
    func useBiometricAuthentication() {
        let authContext = LAContext()
        var error: NSError?

        var description: String!
        
        if authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {

            description = "앱에 접근하기 위해서 인증이 필요합니다"
        
            authContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: description) { (success, authenticationError) in
                DispatchQueue.main.async {
                    if success {
                        let dvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainVC")
                        
                        self.navigationController!.pushViewController(dvc, animated: true)
                    } else {
                        let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified.", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default)
                        okAction.setValue(UIColor.lightGreen, forKey: "titleTextColor")
                        ac.addAction(okAction)
                        self.present(ac, animated: true)
                    }
                }
            }
        }
    }
}


extension LockVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return codeArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LockCodeCVC", for: indexPath) as! LockCodeCVC
        
        cell.codeLabel.text = codeArr[indexPath.row]
        cell.layer.borderColor = UIColor.clear.cgColor
        
        return cell
    }
}

extension LockVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (0 <= indexPath.row && indexPath.row < 9) || indexPath.row == 10 {
            
            inputNumber += codeArr[indexPath.row]
            
            changePasscodeImg(count: inputNumber.count)
            
            if inputNumber.count == 4 {
                if mode == .validate {
                    if UserDefaults.standard.integer(forKey: "passcode") == Int(inputNumber) {
                        let dvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainVC")
                        
                        inputNumber = ""
                        changePasscodeImg(count: 0)
                        
                        self.navigationController!.pushViewController(dvc, animated: true)
                    } else {
                        showfailAnimation()
                        inputNumber = ""
                        changePasscodeImg(count: 0)
                    }
                } else if mode == .create {
                    UserDefaults.standard.set(inputNumber, forKey: "passcode")
                    self.pop()
                    navigationController?.isNavigationBarHidden = false
                } else if mode == .change {
                    if stageForChange == 0 {
                        if UserDefaults.standard.integer(forKey: "passcode") == Int(inputNumber) {
                            descriptionLabel.text = "새 비밀번호를 입력해주세요."
                            stageForChange = 1
                        } else {
                            showfailAnimation()
                        }
                        passcodeCV.reloadData()
                    } else if stageForChange == 1 {
                        newPasscode = Int(inputNumber)
                        descriptionLabel.text = "한 번 더 입력해주세요."
                        stageForChange = 2
                        passcodeCV.reloadData()
                    } else if stageForChange == 2 {
                        if newPasscode == Int(inputNumber) {
                            UserDefaults.standard.set(Int(inputNumber), forKey: "passcode")
                            self.pop()
                            navigationController?.isNavigationBarHidden = false
                        } else {
                            showfailAnimation()
                            descriptionLabel.text = "한 번 더 입력해주세요."
                            passcodeCV.reloadData()
                        }
                    }
                    inputNumber = ""
                    changePasscodeImg(count: 0)
                }
            }
        } else if indexPath.row == 11 {
            inputNumber = String(inputNumber.dropLast())
            
            changePasscodeImg(count: inputNumber.count)
        }
    
        collectionView.reloadData()
        
    }
}

extension LockVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = (passcodeCV.bounds.width) / 3
        let height: CGFloat = (passcodeCV.bounds.height) / 4
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
