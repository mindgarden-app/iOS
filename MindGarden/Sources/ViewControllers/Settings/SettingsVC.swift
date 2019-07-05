//
//  SettingsVC.swift
//  MindGarden
//
//  Created by Sunghee Lee on 01/07/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit
import GoogleSignIn

class SettingsVC: UIViewController {
    
    @IBOutlet var settingsTV: UITableView!
    
    var sectionsArr: [String] = ["Profile", "Logout", "Settings"]
    var items = [
        [""],
        ["로그아웃"],
        ["암호 설정", "글꼴 설정", "알림 설정", "프리미엄 전환 (광고 제거)"]
    ]
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        // Hide the navigation bar on the this view controller
//        self.navigationController?.setNavigationBarHidden(true, animated: animated)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        // Show the navigation bar on other view controllers
//        self.navigationController?.setNavigationBarHidden(false, animated: animated)
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        navigationController?.isNavigationBarHidden = false
        
        settingsTV.delegate = self
        settingsTV.dataSource = self
        
        registerTVC()
    }
    
    func registerTVC() {
        let profileNibName = UINib(nibName: "ProfileTVC", bundle: nil)
        let settingsNibName = UINib(nibName: "SettingsTVC", bundle: nil)
        settingsTV.register(profileNibName, forCellReuseIdentifier: "ProfileTVC")
        settingsTV.register(settingsNibName, forCellReuseIdentifier: "SettingsTVC")
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setNavigationBar() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
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
            cell.nameLabel.text = "이성희"
            cell.typeLabel.text = "무료회원"
            cell.emailLabel.text = "630sunghee@naver.com"
            
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.whiteForBorder.cgColor

            return cell
        } else {
            let cell = settingsTV.dequeueReusableCell(withIdentifier: "SettingsTVC") as! SettingsTVC

            let settingsName = items[indexPath.section][indexPath.row]

            cell.settingsNameLabel.text = settingsName
            
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.whiteForBorder.cgColor
            
            if indexPath.row == 3 {
                cell.selectionStyle = .none
            }

            return cell
        }

    }
}

extension SettingsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.section == 1 {
            print("Logout!")
            GIDSignIn.sharedInstance()?.signOut()
            
            performSegue(withIdentifier: "unwindToLogin", sender: self)
            
        } else if indexPath.section == 2 && indexPath.row != 3{
            let dvc = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "SettingsDetailVC") as! SettingsDetailVC

            dvc.paramSettings = indexPath.row

            self.navigationController!.pushViewController(dvc, animated: true)
        }
    }
}
