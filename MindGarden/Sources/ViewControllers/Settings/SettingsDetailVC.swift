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
    let fontSizeDict : Dictionary<Float, String> = [13: "아주 작게", 13.5: "작게", 14: "보통", 14.5: "크게", 15: "아주 크게"]
    
    let datePicker = UIDatePicker()
    var datePickerIndexPath: IndexPath?
    var isOn: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerTVC()
        setNavigationBar(title: settingsTitleArr[paramSettings])
        isOn = UserDefaults.standard.bool(forKey: settingsTitleArr[paramSettings])
        navigationController?.isNavigationBarHidden = false
        
        settingsDetailTV.delegate = self
        settingsDetailTV.dataSource = self
    }
    
    func registerTVC() {
        if paramSettings == 1 {
            let settingsFontNibName = UINib(nibName: "SettingsFontTVC", bundle: nil)
            settingsDetailTV.register(settingsFontNibName, forCellReuseIdentifier: "SettingsFontTVC")
        } else {
            if paramSettings == 2 {
                let datePickerNibName = UINib(nibName: "DatePickerTVC", bundle: nil)
                settingsDetailTV.register(datePickerNibName, forCellReuseIdentifier: "DatePickerTVC")
            }
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
    
    func indexPathToInsertDatePicker(indexPath: IndexPath) -> IndexPath {
        if let datePickerIndexPath = datePickerIndexPath, datePickerIndexPath.row < indexPath.row {
            return indexPath
        } else {
            return IndexPath(row: indexPath.row + 1, section: indexPath.section)
        }
    }

}

extension SettingsDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var num = 1
        
        if paramSettings != 1 {
            if datePickerIndexPath != nil {
                num += 1
            }
            if isOn {
                num += 1
            }
        }

        return num
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if paramSettings == 0 {
            if indexPath.row == 0 {
                
                let cell = settingsDetailTV.dequeueReusableCell(withIdentifier: "SettingsWithSwitchTVC") as! SettingsWithSwitchTVC
                
                cell.settingsNameLabel.text = settingsTitleArr[paramSettings]
                cell.setSwitch()
                
                cell.delegate = self
                
                cell.layer.borderWidth = 1
                cell.layer.borderColor = UIColor.whiteForBorder.cgColor
                
                return cell
            } else{
                let cell = settingsDetailTV.dequeueReusableCell(withIdentifier: "SettingsTVC") as! SettingsTVC

                cell.settingsNameLabel.text = "암호 변경"
                
                cell.layer.borderWidth = 1
                cell.layer.borderColor = UIColor.whiteForBorder.cgColor

                return cell
            }
        } else if paramSettings == 1 {
            let cell = settingsDetailTV.dequeueReusableCell(withIdentifier: "SettingsFontTVC") as! SettingsFontTVC
            
            cell.settingsNameLabel.text = "크기"
            cell.fontSizeLabel.text = fontSizeDict[UserDefaults.standard.float(forKey: "fontSize")] ?? "보통"
            
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.whiteForBorder.cgColor
            
            return cell
        } else {
            if indexPath.row == 0 {
                let cell = settingsDetailTV.dequeueReusableCell(withIdentifier: "SettingsWithSwitchTVC") as! SettingsWithSwitchTVC
                
                cell.settingsNameLabel.text = settingsTitleArr[paramSettings]
                cell.setSwitch()
                
                cell.delegate = self
                
                cell.layer.borderWidth = 1
                cell.layer.borderColor = UIColor.whiteForBorder.cgColor
                
                return cell
            } else {
                if datePickerIndexPath == indexPath {
                    let datePickerCell = settingsDetailTV.dequeueReusableCell(withIdentifier: "DatePickerTVC") as! DatePickerTVC
                    if let inputTime: Date = UserDefaults.standard.object(forKey: "alarmTime") as? Date {
                        datePickerCell.updateCell(date: inputTime, indexPath: indexPath)
                    } else {
                        datePickerCell.updateCell(date: Date(), indexPath: indexPath)
                    }
                    datePickerCell.delegate = self
                    
                    datePickerCell.layer.borderWidth = 1
                    datePickerCell.layer.borderColor = UIColor.whiteForBorder.cgColor
                    
                    return datePickerCell
                } else {
                    let cell = settingsDetailTV.dequeueReusableCell(withIdentifier: "SettingsTVC") as! SettingsTVC
                    
                    cell.settingsNameLabel.text = "시간 설정"
                    
                    cell.layer.borderWidth = 1
                    cell.layer.borderColor = UIColor.whiteForBorder.cgColor
                    
                    return cell
                }
            }
        }
    }
}

extension SettingsDetailVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if paramSettings == 0 {
            if(indexPath.row == 1) {
                let dvc = UIStoryboard(name: "Lock", bundle: nil).instantiateViewController(withIdentifier: "LockVC")
                
//                dvc.mode = .
                
                self.navigationController!.pushViewController(dvc, animated: true)
            }
        } else if paramSettings == 1 {
            let popUpVC = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "SettingsPopUpVC") as! SettingsPopUpVC
            popUpVC.delegate = self
            self.addChild(popUpVC)
//            popUpVC.view.frame = self.view.frame
            self.view.addSubview(popUpVC.view)
            popUpVC.didMove(toParent: self)
        } else if paramSettings == 2 && indexPath.row == 1 {
            tableView.beginUpdates()
            if let datePickerIndexPath = datePickerIndexPath, datePickerIndexPath.row - 1 == indexPath.row {
                tableView.deleteRows(at: [datePickerIndexPath], with: .fade)
                self.datePickerIndexPath = nil
            } else {
                if let datePickerIndexPath = datePickerIndexPath {
                    tableView.deleteRows(at: [datePickerIndexPath], with: .fade)
                }
                datePickerIndexPath = indexPathToInsertDatePicker(indexPath: indexPath)
                tableView.insertRows(at: [datePickerIndexPath!], with: .fade)
                tableView.deselectRow(at: indexPath, animated: true)
            }
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if datePickerIndexPath == indexPath {
            return 162
        } else {
            return 54
        }
    }
}

extension SettingsDetailVC: DatePickerDelegate {
    
    func didChangeDate(date: Date, indexPath: IndexPath) {
        UserDefaults.standard.set(date, forKey: "alarmTime")
        settingsDetailTV.reloadRows(at: [indexPath], with: .none)
    }
}

extension SettingsDetailVC: SwitchDelegate {
    
    func OnSwitch(name: String, isOn: Bool) {
        self.isOn = isOn
        settingsDetailTV.beginUpdates()
        if isOn {
            settingsDetailTV.insertRows(at: [IndexPath(row: 1, section: 0)], with: .fade)
        } else {
            settingsDetailTV.deleteRows(at: [IndexPath(row: 1, section: 0)], with: .fade)
            if datePickerIndexPath != nil {
                settingsDetailTV.deleteRows(at: [IndexPath(row: 2, section: 0)], with: .fade)
                self.datePickerIndexPath = nil
            }
        }
        settingsDetailTV.endUpdates()
        UserDefaults.standard.set(isOn, forKey: name)
    }
}


extension SettingsDetailVC: FontSizeDelegate {
    func changeFontSizeText() {
        self.settingsDetailTV.reloadData()
    }
}
