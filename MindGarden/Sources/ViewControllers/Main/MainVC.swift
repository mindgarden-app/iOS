//
//  GameViewController.swift
//  MindGarden
//
//  Created by Sunghee Lee on 30/06/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import PopupDialog

class MainVC: UIViewController {
 
    @IBOutlet var newBtn: UIButton!
    @IBOutlet var balloonImageView: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    private var dateStr: String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 말풍선 유무로 플러스 버튼 이미지 변경되어야함.
//        balloonImageView.isHidden = true
        
        
        setDate()
    }
    
    func setDate() {
        navigationController?.navigationBar.barTintColor = UIColor.white

        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "yyyy년 M월"
        dateStr = dateFormatter.string(from: today)
        
        let dateBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        dateBtn.setTitle(dateStr, for: .normal)
        dateBtn.setTitleColor(.black, for: .normal)
        dateBtn.addTarget(self, action: #selector(dateBtnAction), for: .touchUpInside)
        self.navigationItem.titleView = dateBtn
        
        let calendar = Calendar.current
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .ordinal
        let day = numberFormatter.string(from: calendar.component(.day, from: today) as NSNumber)
        let dayOfTheWeek: String = today.getDayOfTheWeek(lang: "en")!
        dateLabel.text = "\(day!). \(dayOfTheWeek)"
    }
    
    @IBAction func newBtnAction(_ sender: Any) {
        let dvc = UIStoryboard(name: "Diary", bundle: nil).instantiateViewController(withIdentifier: "DiaryNewVC")

        self.navigationController!.pushViewController(dvc, animated: true)
        
        // 일기를 이미 작성한 경우
//        self.simpleAlert(title: "Oops!", message: "일기는 하루에 하나만 쓸 수 있어요!ㅠㅠ")
    }
    
    @IBAction func listBtnAction(_ sender: Any) {
        let dvc = UIStoryboard(name: "Diary", bundle: nil).instantiateViewController(withIdentifier: "DiaryListVC")
        
        self.navigationController!.pushViewController(dvc, animated: true)
    }
    
    @IBAction func settingsBtnAction(_ sender: Any) {
        let dvc = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "SettingsVC")

        self.navigationController!.pushViewController(dvc, animated: true)
    }
    
    @objc func dateBtnAction() {
        let popUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopUpVC") as! PopUpVC
        popUpVC.delegate = self
        self.addChild(popUpVC)
        popUpVC.view.frame = self.view.frame
        self.view.addSubview(popUpVC.view)
        popUpVC.didMove(toParent: self)
    }
    
    func setDateLabel() {
        
    }
    
    @IBAction func treeAddBtnAction(_ sender: Any) {
        if !balloonImageView.isHidden {
            let dvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainGridVC")
            
            self.navigationController!.pushViewController(dvc, animated: true)
        } else {
            self.simpleAlert(title: "Oops!", message: "일기를 작성해야 나무를 심을 수 있어요!ㅠㅠ")
        }
    }
}


extension MainVC: DateDelegate {
    func changeDate(year: Int, month: Int) {
        dateStr = String(year)
    }
}
