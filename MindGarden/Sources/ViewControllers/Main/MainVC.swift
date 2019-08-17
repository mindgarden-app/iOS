//
//  GameViewController.swift
//  MindGarden
//
//  Created by Sunghee Lee on 30/06/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class MainVC: UIViewController, NVActivityIndicatorViewable {
 
    @IBOutlet var newBtn: UIButton!
    @IBOutlet var treeAddBtn: UIButton!
    @IBOutlet var balloonImageView: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var descriptionFirstLabel: UILabel!
    @IBOutlet var descriptionSecondLabel: UILabel!
   
    var dateStr: String = ""
    var inputDate: DateComponents!
    var inputYear: Int!
    var inputMonth: Int!
    var currentYear: Int!
    var currentMonth: Int!
    var isCurrent: Bool! = true
    var day: String!
    var dayOfTheWeek: String!
    var treeNum: Int = 0
    var treeList: [Tree] = []
    var descriptionArr: [[String]] = [["이번 달 정원도 잘 꾸며볼까요?", "함께 멋있는 정원을 만들어보아요."], ["오늘 기분은 어땠어요?", "정원이 조금씩 채워지고 있어요"], ["정원이 복작복작 해졌어요", "이번 달 마무리를 잘해봅시다!"], ["축하해요!", "정원을 멋지게 완성했네요"]]
    var previousDescriptionArr: [[String]] = [["나무가 하나도 없어요", "정원이 휑하네요"], ["개의 나무를 심었네요", "많이 바빴나요?"], ["개의 나무를 심었네요", "꽤 멋있는데요!"], ["개의 나무를 심었네요", "수고했어요 짝짝짝"]]
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        getGarden(date: "\(inputYear!)-\(String(format: "%02d", inputMonth!))")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        
        balloonImageView.isHidden = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        setDate()
        setBarButtonItem()
        getGarden(date: "\(inputYear!)-\(String(format: "%02d", inputMonth!))")
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
        
        if inputDate == nil || isCurrent == true {
            let today = Date()
            let calendar = Calendar.current
            currentYear = calendar.component(.year, from: today)
            inputYear = calendar.component(.year, from: today)
            currentMonth = calendar.component(.month, from: today)
            inputMonth = calendar.component(.month, from: today)
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
        
        if currentYear == inputYear && currentMonth == inputMonth {
            dateLabel.isHidden = false
            dateLabel.text = "\(day!). \(dayOfTheWeek!)"
        } else {
            dateLabel.isHidden = true
        }
    }
    
    func setBarButtonItem() {
        self.setNavigationBarItem(image: "btnList.png", target: self, action: #selector(listBtnAction), direction: "left")
    }
    
    func getGarden(date: String) {
        GardenService.shared.getGarden(date: date) { [weak self] data in
            guard let `self` = self else { return }
            
            switch data {
            case .success(let res):
                self.treeList = res as! [Tree]
                self.makeGarden()
                self.setDescriptionLabel(treeNum: self.treeList[0].treeNum, current: self.isCurrent)
                if self.treeList[0].balloon == 1 {
                    self.balloonImageView.isHidden = false
                    self.treeAddBtn.setImage(UIImage(named: "btnPlusRed"), for: .normal)
                } else {
                    self.balloonImageView.isHidden = true
                    self.treeAddBtn.setImage(UIImage(named: "btnPlus"), for: .normal)
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
                            GardenService.shared.getGarden(date: date) { [weak self] data in
                                guard let `self` = self else { return }
                                
                                switch data {
                                case .success(let res):
                                    self.treeList = res as! [Tree]
                                    self.makeGarden()
                                    self.setDescriptionLabel(treeNum: self.treeList[0].treeNum, current: self.isCurrent)
                                    if self.treeList[0].balloon == 1 {
                                        self.balloonImageView.isHidden = false
                                        self.treeAddBtn.setImage(UIImage(named: "btnPlusRed"), for: .normal)
                                    } else {
                                        self.balloonImageView.isHidden = true
                                        self.treeAddBtn.setImage(UIImage(named: "btnPlus"), for: .normal)
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
    }
    
    func makeGarden() {
        var locationArr: [Int] = Array(1...32)
        
        if treeList[0].balloon == 1 {
            balloonImageView.isHidden = false
        } else {
            balloonImageView.isHidden = true
        }
        
        for tree in treeList {
            let imageName: String = tree.treeIdx != 16 ? "ios_tree\(tree.treeIdx + 1)": "ios_weeds"
            let treeImageView = self.view.viewWithTag(tree.location) as! UIImageView
            treeImageView.image = UIImage(named: imageName)
            locationArr.removeAll{ $0 == tree.location }
        }
        
        for location in locationArr {
            let treeImageView = self.view.viewWithTag(location) as! UIImageView
            treeImageView.image = nil
        }
    }
    
    func setDescriptionLabel(treeNum: Int, current: Bool) {
        if current {
            switch treeNum {
            case 0:
                descriptionFirstLabel.text = descriptionArr[0][0]
                descriptionSecondLabel.text = descriptionArr[0][1]
            case 1...10:
                descriptionFirstLabel.text = descriptionArr[1][0]
                descriptionSecondLabel.text = descriptionArr[1][1]
            case 11...20:
                descriptionFirstLabel.text = descriptionArr[2][0]
                descriptionSecondLabel.text = descriptionArr[2][1]
            case 21...32:
                descriptionFirstLabel.text = descriptionArr[3][0]
                descriptionSecondLabel.text = descriptionArr[3][1]
            default:
                break
            }
        } else {
            switch treeNum {
            case 0:
                descriptionFirstLabel.text = previousDescriptionArr[0][0]
                descriptionSecondLabel.text = previousDescriptionArr[0][1]
            case 1...10:
                descriptionFirstLabel.text = "\(treeNum)" + previousDescriptionArr[1][0]
                descriptionSecondLabel.text = previousDescriptionArr[1][1]
            case 11...20:
                descriptionFirstLabel.text = "\(treeNum)" + previousDescriptionArr[2][0]
                descriptionSecondLabel.text = previousDescriptionArr[2][1]
            case 21...32:
                descriptionFirstLabel.text = "\(treeNum)" + previousDescriptionArr[3][0]
                descriptionSecondLabel.text = previousDescriptionArr[3][1]
            default:
                break
            }
        }
    }
    
    @IBAction func newBtnAction(_ sender: Any) {
        let dvc = UIStoryboard(name: "Diary", bundle: nil).instantiateViewController(withIdentifier: "DiaryNewVC") as! DiaryNewVC

        dvc.mode = .new
        
        self.navigationController!.pushViewController(dvc, animated: true)
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
        popUpVC.year = inputYear
        self.addChild(popUpVC)
        popUpVC.view.frame = self.view.frame
        self.view.addSubview(popUpVC.view)
        popUpVC.didMove(toParent: self)
    }
    
    @IBAction func treeAddBtnAction(_ sender: Any) {
//        if !balloonImageView.isHidden {
            let dvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainGridVC") as! MainGridVC
            
            dvc.date = "\(inputYear!)-\(String(format: "%02d", inputMonth!))"
            
            self.navigationController!.pushViewController(dvc, animated: true)
//        } else {
//            self.simpleAlert(title: "Oops!", message: "일기를 작성해야 나무를 심을 수 있어요!ㅠㅠ")
//        }
    }
}

extension MainVC: DateDelegate {
    func changeDate(year: Int, month: Int) {
        inputDate = DateComponents(year: year, month: month)
        self.inputYear = year
        self.inputMonth = month
        
        if currentYear == inputYear && currentMonth == inputMonth {
            isCurrent = true
        } else {
            isCurrent = false
        }
        
        setDate()
        getGarden(date: "\(inputYear!)-\(String(format: "%02d", inputMonth!))")
    }
}

