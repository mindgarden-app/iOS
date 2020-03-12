//
//  SettingsVC.swift
//  MindGarden
//
//  Created by Sunghee Lee on 01/07/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
    
    @IBOutlet var settingsTV: UITableView!
    
    var sectionsArr: [String] = ["Profile", "Logout", "Settings", "Version"]
    var items = [
        [""],
        ["로그아웃", "계정 삭제"],
        ["암호 설정", "알림 설정"],
        ["버전 정보"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()

        registerTVC()
        settingsTV.delegate = self
        settingsTV.dataSource = self
    }
    
    func setNavigationBar() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        navigationController?.isNavigationBarHidden = false
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    func registerTVC() {
        let profileNibName = UINib(nibName: "ProfileTVC", bundle: nil)
        let settingsNibName = UINib(nibName: "SettingsTVC", bundle: nil)
        let versionNibName = UINib(nibName: "VersionTVC", bundle: nil)
        settingsTV.register(profileNibName, forCellReuseIdentifier: "ProfileTVC")
        settingsTV.register(settingsNibName, forCellReuseIdentifier: "SettingsTVC")
        settingsTV.register(versionNibName, forCellReuseIdentifier: "VersionTVC")
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.pop()
    }
}

extension SettingsVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 || section == 1 {
            return 0
        }
        return 17
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            let cell = settingsTV.dequeueReusableCell(withIdentifier: "ProfileTVC") as! ProfileTVC

            cell.profileImage.image = UIImage(named: "imgProfile")
            cell.nameLabel.text = UserDefaults.standard.string(forKey: "name")
            cell.emailLabel.text = UserDefaults.standard.string(forKey: "email")
            
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.whiteForBorder.cgColor

            return cell
        } else if indexPath.section == 3 {
            let cell = settingsTV.dequeueReusableCell(withIdentifier: "VersionTVC") as! VersionTVC
            
            return cell
        } else {
            let cell = settingsTV.dequeueReusableCell(withIdentifier: "SettingsTVC") as! SettingsTVC

            let settingsName = items[indexPath.section][indexPath.row]

            cell.settingsNameLabel.text = settingsName
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.whiteForBorder.cgColor

            return cell
        }

    }
}

extension SettingsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                UserDefaults.standard.set(false, forKey: "암호 설정")
                UserDefaults.standard.set(nil, forKey: "refreshtoken")
                UserDefaults.standard.set(nil, forKey: "token")
                UserDefaults.standard.set(nil, forKey: "email")
                UserDefaults.standard.set(nil, forKey: "name")
                //                navigationController?.isNavigationBarHidden = true
                //                performSegue(withIdentifier: "unwindToLogin", sender: self)
                let dvc = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                var viewControllers: [UIViewController] = self.navigationController!.viewControllers
                viewControllers.removeAll()
                viewControllers.append(dvc)
                self.navigationController?.setViewControllers(viewControllers, animated: false)
            } else {
                let alert = UIAlertController(title: "정말 계정을 삭제하겠습니까?", message: "삭제된 정보는 되돌릴 수 없습니다.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "삭제하기", style: .destructive, handler: { action in
                    AuthService.shared.deleteUser() { [weak self] data in
                        guard let `self` = self else { return }
                        
                        switch data {
                        case .success(let message):
                            if String(describing: message) == "user 계정 삭제 성공!" {
                                UserDefaults.standard.set(false, forKey: "암호 설정")
                                UserDefaults.standard.set(nil, forKey: "refreshtoken")
                                UserDefaults.standard.set(nil, forKey: "token")
                                UserDefaults.standard.set(nil, forKey: "email")
                                UserDefaults.standard.set(nil, forKey: "name")
                                self.navigationController?.isNavigationBarHidden = true
                                self.performSegue(withIdentifier: "unwindToLogin", sender: self)
                            }
                            break
                        case .requestErr(let err):
                            print(".requestErr(\(err))")
                            if String(describing: err) == "만료된 토큰입니다." {
                                AuthService.shared.refreshAccesstoken() { [weak self] data in
                                    guard let `self` = self else { return }
                                    
                                    switch data {
                                    case .success(let res):
                                        let data = res as! Token
                                        UserDefaults.standard.set(data.token, forKey: "token")
                                        AuthService.shared.deleteUser() { [weak self] data in
                                            guard let `self` = self else { return }
                                            
                                            switch data {
                                            case .success(let message):
                                                if String(describing: message) == "user 계정 삭제 성공!" {
                                                    UserDefaults.standard.set(false, forKey: "암호 설정")
                                                    UserDefaults.standard.set(nil, forKey: "refreshtoken")
                                                    UserDefaults.standard.set(nil, forKey: "token")
                                                    UserDefaults.standard.set(nil, forKey: "email")
                                                    UserDefaults.standard.set(nil, forKey: "name")
                                                    self.navigationController?.isNavigationBarHidden = true
                                                    self.performSegue(withIdentifier: "unwindToLogin", sender: self)
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
                cancelAction.setValue(UIColor.Gray, forKey: "titleTextColor")
                alert.addAction(cancelAction)
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
            }
        } else if indexPath.section == 2 {
            let dvc = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "SettingsDetailVC") as! SettingsDetailVC

            dvc.paramSettings = indexPath.row

            self.navigationController!.pushViewController(dvc, animated: true)
            tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        } else if indexPath.section == 3 {
            if let url = URL(string: "itms-apps://itunes.apple.com/app/apple-store/id\(AppConstants.AppId)?mt=8"),
                UIApplication.shared.canOpenURL(url){
                UIApplication.shared.open(url, options: [:]) { (opened) in
                    if(opened){
                        print("App Store Opened")
                    }
                }
                tableView.deselectRow(at: indexPath as IndexPath, animated: true)
            } else {
                print("Can't Open URL on Simulator")
                tableView.deselectRow(at: indexPath as IndexPath, animated: true)
            }
        }
    }
}

extension SettingsVC : UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if (self.navigationController?.viewControllers.count)! > 1 {
            return true
        }
        
        return false
    }
}
