//
//  ListViewController.swift
//  MindGarden
//
//  Created by Sunghee Lee on 01/07/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit

class DiaryListVC: UIViewController {

    
    @IBOutlet var diaryListTV: UITableView!
    @IBOutlet var settingsBtn: UIBarButtonItem!
    @IBOutlet var emptyView: UIView!
    @IBOutlet var grayView: UIView!
    
    let dateFormatter = DateFormatter()
    
    var isAscending: Bool! = true
    var inputDate: DateComponents!
    var dateStr: String = ""
    var diaryList: [Diary] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    
        DispatchQueue.main.async {
            if self.inputDate == nil {
                self.getDiaryList(date: "2019-07")
            } else {
                self.getDiaryList(date: "\(self.inputDate.year!)-\(String(format: "%02d", self.inputDate.month!))")
            }
        }
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(true)
//        print("willdidappear")
//        getDiaryList(date: "2019-07")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = false
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        diaryListTV.backgroundView = emptyView
        
        dateFormatter.dateFormat = "yyyy-MM-dd EEE HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "KST") as TimeZone?
        
        if inputDate == nil {
            getDiaryList(date: "2019-07")
        } else {
            getDiaryList(date: "\(inputDate.year!)-\(String(format: "%02d", inputDate.month!)))")
        }
        setNavigationBar()
        registerTVC()
        diaryListTV.delegate = self
        diaryListTV.dataSource = self
    }
    
    func getDiaryList(date: String) {
        DiaryService.shared.getDiaryList(date: date) { [weak self] data in
            guard let `self` = self else { return }
            
            switch data {
            case .success(let res):
                self.diaryList = res as! [Diary]
                self.diaryListTV.reloadData()
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
    
    @IBAction func sortBtnAction(_ sender: Any) {
        if isAscending {
            isAscending = false
            diaryList.sort() { $0.diaryIdx > $1.diaryIdx }
            diaryListTV.reloadData()
        } else {
            isAscending = true
            diaryList.sort() { $0.diaryIdx < $1.diaryIdx }
            diaryListTV.reloadData()
        }
    }
    
    @IBAction func newBtnAction(_ sender: Any) {
        let dvc = UIStoryboard(name: "Diary", bundle: nil).instantiateViewController(withIdentifier: "DiaryNewVC") as! DiaryNewVC
        
        dvc.mode = DiaryMode.new
        dvc.location = .list
        
        self.navigationController!.pushViewController(dvc, animated: true)
    }
    
    @IBAction func settingsBtnAction(_ sender: Any) {
        let dvc = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "SettingsVC")
        
        self.navigationController!.pushViewController(dvc, animated: true)
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        print("back")
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func setNavigationBar() {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "yyyy년 M월"
        
        if inputDate == nil {
            let today = Date()
            let calendar = Calendar.current
            inputDate = DateComponents(year: calendar.component(.year, from: today), month: calendar.component(.month, from: today), day: calendar.component(.day, from: today))
            dateStr = dateFormatter.string(from: today)
        } else {
            let compsToDate: Date = Calendar.current.date(from: inputDate)!
            dateStr = dateFormatter.string(from: compsToDate)
        }
        
        let dateBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        dateBtn.setTitle(dateStr, for: .normal)
        dateBtn.setTitleColor(.black, for: .normal)
        dateBtn.addTarget(self, action: #selector(dateBtnAction), for: .touchUpInside)
        self.navigationItem.titleView = dateBtn
    }
    
    @objc func dateBtnAction() {
        let popUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopUpVC") as! PopUpVC
        popUpVC.delegate = self
        popUpVC.year = inputDate.year!
        popUpVC.inputMonth = inputDate.month!
        
        self.navigationController?.navigationBar.isUserInteractionEnabled = false;
        
        self.addChild(popUpVC)
        popUpVC.view.frame = self.view.frame
        self.view.addSubview(popUpVC.view)
        popUpVC.didMove(toParent: self)
    }
    
    func registerTVC() {
        let nibName = UINib(nibName: "DiaryListTVC", bundle: nil)
        diaryListTV.register(nibName, forCellReuseIdentifier: "DiaryListTVC")
    }
}

extension DiaryListVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if diaryList.count == 0 {
            tableView.setEmptyView()
            grayView.isHidden = true
        } else {
            tableView.restore()
            grayView.isHidden = false

        }
        
        return diaryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = diaryListTV.dequeueReusableCell(withIdentifier: "DiaryListTVC") as! DiaryListTVC
        let diary = diaryList[indexPath.row]
        let date: Date = dateFormatter.date(from: diary.date)!
        let day = Calendar.current.component(.day, from: date)
        let weatherImage = "imgListWeather\(diary.weatherIdx + 1)"
        
        cell.diaryIdx = diary.diaryIdx
        cell.dateLabel.text = String(day)
        cell.dayOfWeekLabel.text = date.getDayOfTheWeek(lang: "ko")
        cell.titleLabel.text = diary.diary_content
        cell.weatherImage.image = UIImage(named: weatherImage)
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.whiteForBorder.cgColor
        
        return cell
    }
}

extension DiaryListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! DiaryListTVC
        let dvc = storyboard?.instantiateViewController(withIdentifier: "DiaryDetailVC") as! DiaryDetailVC
    
        dvc.date = "\(inputDate.year!)-\(String(format: "%02d", inputDate.month!))-\(String(format: "%02d", Int(cell.dateLabel.text!)!))"
        dvc.diaryIdx = cell.diaryIdx

        navigationController?.pushViewController(dvc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제", handler: { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            
            let alert = UIAlertController(title: "정말 일기를 삭제하겠습니까?", message: "삭제된 일기는 복구할 수 없습니다.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "삭제하기", style: .destructive, handler: { action in
                    let cell = tableView.cellForRow(at: indexPath) as! DiaryListTVC
                    let diaryIdx = cell.diaryIdx
                    DiaryService.shared.deleteDiary(diaryIdx: diaryIdx!) { [weak self] data in
                        guard let `self` = self else { return }
                        
                        switch data {
                        case .success(_):
                            self.simpleAlert(title: "삭제", message: "일기가 삭제되었습니다")
                        
                            tableView.beginUpdates()
                            tableView.deleteRows(at: [indexPath], with: .automatic)
                            
                            self.diaryList.remove(at: indexPath.row)
                            
                            tableView.endUpdates()
                            
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
                self.present(alert, animated: true, completion: nil)
            
        })
    
    
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension DiaryListVC: DateDelegate {
    func changeDate(year: Int, month: Int) {
        inputDate = DateComponents(year: year, month: month)
        
        setNavigationBar()
        getDiaryList(date: "\(year)-\(String(format: "%02d", month))")
    }
}

extension DiaryListVC : UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if (self.navigationController?.viewControllers.count)! > 1 {
            return true
        }
        return false
    }
}

