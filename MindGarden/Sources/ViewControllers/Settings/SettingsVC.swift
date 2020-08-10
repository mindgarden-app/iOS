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
    
    var sectionsArr: [String] = ["Profile", "Logout", "Settings", "Version", "Notice"]
    var items = [
        [""],
        ["로그아웃", "계정 삭제"],
        ["암호 설정", "알림 설정", "글꼴 설정"],
        ["버전 정보"],
        ["서비스 종료 안내"]
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
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    func registerTVC() {
        let profileNibName = UINib(nibName: "ProfileTVC", bundle: nil)
        let settingsNibName = UINib(nibName: "SettingsTVC", bundle: nil)
        let switchNibName = UINib(nibName: "SettingsWithSwitchTVC", bundle: nil)
        let versionNibName = UINib(nibName: "VersionTVC", bundle: nil)
        settingsTV.register(profileNibName, forCellReuseIdentifier: "ProfileTVC")
        settingsTV.register(settingsNibName, forCellReuseIdentifier: "SettingsTVC")
        settingsTV.register(switchNibName, forCellReuseIdentifier: "SettingsWithSwitchTVC")
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
//            if indexPath.row < 2 {
                let cell = settingsTV.dequeueReusableCell(withIdentifier: "SettingsTVC") as! SettingsTVC

                let settingsName = items[indexPath.section][indexPath.row]

                cell.settingsNameLabel.text = settingsName
                cell.layer.borderWidth = 1
                cell.layer.borderColor = UIColor.whiteForBorder.cgColor

                return cell
//            } else {
//                let cell = settingsTV.dequeueReusableCell(withIdentifier: "SettingsWithSwitchTVC") as! SettingsWithSwitchTVC
//
//                let settingsName = items[indexPath.section][indexPath.row]
//
//                cell.settingsNameLabel.text = settingsName
//                cell.setSwitch()
//
//                cell.delegate = self
//                cell.layer.borderWidth = 1
//                cell.layer.borderColor = UIColor.whiteForBorder.cgColor
//
//                return cell
//            }
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
        } else if indexPath.section == 4 {
            simpleAlert(title: "서비스 종료 안내 😥", message: "지금까지 Mindgarden을 이용해주셔서 진심으로 감사합니다.\n\n 많은 분들이 아껴주시고 사랑해주셨던 MindGarden이 8월 21일 자로 앱스토어에서 서비스를 종료합니다. MindGarden은 그 동안 더욱 편리한 서비스 제공을 위해 노력하였으나 내부 사정으로 많은 고민 끝에 서비스 종료를 결정하게 되었습니다.\n\n기존 사용자분들은 2021년 3월까지 어플을 사용하실 수 있습니다. 어플을 삭제한다면 다시 설치할 수 없으니 유의하시길 바랍니다. \n\n그 동안 MindGarden을 이용해주시고 많은 관심과 응원을 보내주신 분들께 진심으로 감사드리며, 부득이하게 서비스를 종료하게 된 점 깊이 사과드립니다.\n\nApp Store 등록 종료: 2020. 8. 21.\n어플 이용 가능 기간: ~2021. 3. 31")
            tableView.deselectRow(at: indexPath as IndexPath, animated: true)
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

extension SettingsVC: SwitchDelegate {
    
    func OnSwitch(name: String, isOn: Bool) {
        if isOn {
            
        } else {
            
        }
//        self.isOn = isOn
//        UserDefaults.standard.set(isOn, forKey: name)
//        settingsDetailTV.beginUpdates()
//        if isOn {
//            settingsDetailTV.insertRows(at: [IndexPath(row: 1, section: 0)], with: .fade)
//        } else {
//            settingsDetailTV.deleteRows(at: [IndexPath(row: 1, section: 0)], with: .fade)
//            if datePickerIndexPath != nil {
//                settingsDetailTV.deleteRows(at: [IndexPath(row: 2, section: 0)], with: .fade)
//                self.datePickerIndexPath = nil
//            }
//
//            if name == "알림 설정" {
//                center.removeAllDeliveredNotifications()
//                center.removeAllPendingNotificationRequests()
//                UIApplication.shared.applicationIconBadgeNumber = 0
//            }
//        }
//        settingsDetailTV.endUpdates()
//
//        if name == "암호 설정" && isOn {
//            let dvc = UIStoryboard(name: "Lock", bundle: nil).instantiateViewController(withIdentifier: "LockVC") as! LockVC
//
//            dvc.mode = LockMode.create
//
//            self.navigationController!.pushViewController(dvc, animated: true)
//        }
    }
}
