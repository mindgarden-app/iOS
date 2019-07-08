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
    @IBOutlet var descriptionFirstLabel: UILabel!
    @IBOutlet var descriptionSecondLabel: UILabel!
    
    private var dateStr: String = ""
    var inputDate: DateComponents!
    var year: Int!
    var day: String!
    var dayOfTheWeek: String!
    var isBalloon: Bool = false
    var treeNum: Int = 0
    var descriptionArr: [[String]] = [["이번 달 정원도 잘 꾸며볼까요?", "함께 멋있는 정원을 만들어보아요."], ["오늘 기분은 어땠어요?", "정원이 조금씩 채워지고 있어요"], ["정원이 복작복작 해졌어요", "이번 달 마무리를 잘해봅시다!"], ["축하해요!", "정원을 멋지게 완성했네요"]]
//    var previousDescriptionArr: [[String]] = [["나무가 하나도 없어요", "정원이 휑하네요"], ["\(self.treeNum)개의 나무를 심었네요", "많이 바빴나요?"], ["\(self.treeNum)개의 나무를 심었네요", "꽤 멋있는데요!"], ["\(self.treeNum)개의 나무를 심었네요", "수고했어요 짝짝짝"]]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 말풍선 유무로 플러스 버튼 이미지 변경되어야함.
//        balloonImageView.isHidden = true
        
        
        
        setDate()
        setBarButtonItem()
    }
    
    func setBarButtonItem() {
        self.setNavigationBarItem(image: "btnList.png", target: self, action: #selector(listBtnAction), direction: "left")
    }
    
    func setDate() {
        navigationController?.navigationBar.barTintColor = UIColor.white

        let calendar = Calendar.current
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .ordinal
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "yyyy년 M월"
        
        if inputDate == nil {
            let today = Date()
            let calendar = Calendar.current
            year = calendar.component(.year, from: today)
            inputDate = DateComponents(year: calendar.component(.year, from: today), month: calendar.component(.month, from: today), day: calendar.component(.day, from: today))
            dateStr = dateFormatter.string(from: today)
            day = numberFormatter.string(from: calendar.component(.day, from: today) as NSNumber)
            dayOfTheWeek = today.getDayOfTheWeek(lang: "en")
        } else {
            let compsToDate: Date = Calendar.current.date(from: inputDate)!
            dateStr = dateFormatter.string(from: compsToDate)
            day = numberFormatter.string(from: calendar.component(.day, from: compsToDate) as NSNumber)
            dayOfTheWeek = compsToDate.getDayOfTheWeek(lang: "en")
        }
        
        let dateBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        dateBtn.setTitle(dateStr, for: .normal)
        dateBtn.setTitleColor(.black, for: .normal)
        dateBtn.addTarget(self, action: #selector(dateBtnAction), for: .touchUpInside)
        self.navigationItem.titleView = dateBtn
        
        dateLabel.text = "\(day!). \(dayOfTheWeek!)"
    }
    
    func setDescriptionLabel() {
        
    }
    
    @IBAction func newBtnAction(_ sender: Any) {
        let dvc = UIStoryboard(name: "Diary", bundle: nil).instantiateViewController(withIdentifier: "DiaryNewVC") as! DiaryNewVC

        dvc.mode = .new
        
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
        popUpVC.year = year
        self.addChild(popUpVC)
        popUpVC.view.frame = self.view.frame
        self.view.addSubview(popUpVC.view)
        popUpVC.didMove(toParent: self)
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
        inputDate = DateComponents(year: year, month: month)
        self.year = year
        
        setDate()
    }
}

