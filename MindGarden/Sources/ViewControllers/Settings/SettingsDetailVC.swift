//
//  SettingsDetailVC.swift
//  MindGarden
//
//  Created by Sunghee Lee on 02/07/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit

class SettingsDetailVC: UIViewController {

    @IBOutlet var settingsDetailTV: UITableView!
    
    var paramSettings: Int = 0
    var settingsTitleArr: [String] = ["암호 설정", "글꼴 설정", "알림 설정"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerTVC()
        setNavigationBar(title: settingsTitleArr[paramSettings])
        navigationController?.isNavigationBarHidden = false
        
        settingsDetailTV.delegate = self
        settingsDetailTV.dataSource = self
    }
    
    func registerTVC() {
        if paramSettings == 1 {
            let settingsFontNibName = UINib(nibName: "SettingsFontTVC", bundle: nil)
            settingsDetailTV.register(settingsFontNibName, forCellReuseIdentifier: "SettingsFontTVC")
        } else {
            let settingsNibName = UINib(nibName: "SettingsTVC", bundle: nil)
            let settingsWithSwitchNibName = UINib(nibName: "SettingsWithSwitchTVC", bundle: nil)
            settingsDetailTV.register(settingsNibName, forCellReuseIdentifier: "SettingsTVC")
            settingsDetailTV.register(settingsWithSwitchNibName, forCellReuseIdentifier: "SettingsWithSwitchTVC")
        }
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setNavigationBar(title: String) {
        self.navigationItem.title = title
        // Todo. font와 size 지정 들어가야됨
    }
    
    @objc func onDidChangeDate(sender: UIDatePicker) {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        
        let selectedDate: String = dateFormatter.string(from: sender.date)
        print(selectedDate)
    }

}

extension SettingsDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if paramSettings == 1 {
            return 1
        }
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if paramSettings == 0 {
            let switchObj = UISwitch(frame: CGRect(x: 1, y: 1, width: 20, height: 20))
            
            if indexPath.row == 0 {
                
                let cell = settingsDetailTV.dequeueReusableCell(withIdentifier: "SettingsTVC") as! SettingsTVC
                
                cell.settingsNameLabel.text = "암호 사용"
            
                switchObj.isOn = false
                cell.accessoryView = switchObj
                
                return cell
//                let cell = settingsDetailTV.dequeueReusableCell(withIdentifier: "SettingsWithSwitchTVC") as! SettingsWithSwitchTVC
//
//                cell.settingsNameLabel.text = "암호 사용"
//
//                return cell
            } else {
                let cell = settingsDetailTV.dequeueReusableCell(withIdentifier: "SettingsTVC") as! SettingsTVC
                
                cell.settingsNameLabel.text = "암호 변경"
                
                if switchObj.isOn {
                    cell.settingsNameLabel.textColor = .red
                } else {
                    cell.settingsNameLabel.textColor = .blue
                }
                
                return cell
            }
        } else if paramSettings == 1 {
            let cell = settingsDetailTV.dequeueReusableCell(withIdentifier: "SettingsFontTVC") as! SettingsFontTVC
            
            cell.settingsNameLabel.text = "크기"
            cell.fontSizeLabel.text = "보통"
            
            return cell
        } else {
            if indexPath.row == 0 {
                let cell = settingsDetailTV.dequeueReusableCell(withIdentifier: "SettingsWithSwitchTVC") as! SettingsWithSwitchTVC
                
                cell.settingsNameLabel.text = "푸시 알림"
                
                return cell
            } else {
                let cell = settingsDetailTV.dequeueReusableCell(withIdentifier: "SettingsTVC") as! SettingsTVC
                
                cell.settingsNameLabel.text = "시간 설정"
                
                return cell
            }
        }
    }
}

extension SettingsDetailVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if paramSettings == 2 && indexPath.row == 1 {
            let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 150, width: self.view.frame.width, height: 200))
            datePicker.timeZone = NSTimeZone.local
            datePicker.backgroundColor = UIColor.white
            datePicker.layer.cornerRadius = 5.0
            datePicker.layer.shadowOpacity = 0.5
            
            datePicker.addTarget(self, action: #selector(onDidChangeDate(sender:)), for: .valueChanged)
        }
    }
}


