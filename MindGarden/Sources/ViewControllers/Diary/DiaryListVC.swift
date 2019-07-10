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
    var inputDate: DateComponents!
    var dateStr: String = ""
    var diaryList: [Diary] = []
    @IBOutlet var settingsBtn: UIBarButtonItem!
    let dateFormatter = DateFormatter()
    var emptyView: UIView!
    var isAscending: Bool! = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = false
        
        dateFormatter.dateFormat = "yyyy-MM-dd EEE HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "KST") as TimeZone?
        
        getDiaryList(date: "2019-07")
        setNavigationBar()
        registerTVC()
        diaryListTV.delegate = self
        diaryListTV.dataSource = self
    }
    
    func getDiaryList(date: String) {
        let userIdx = UserDefaults.standard.integer(forKey: "userIdx")
        
        DiaryService.shared.getDiaryList(userIdx: userIdx, date: date) {
            [weak self]
            data in
            
            guard let `self` = self else { return }
            
            switch data {
            case .success(let res):
                self.diaryList = res as! [Diary]
                self.diaryListTV.reloadData()
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
    
    @IBAction func sortBtnAction(_ sender: Any) {
        if isAscending {
            isAscending = false
            diaryList.sort() { $0.date > $1.date }
            diaryListTV.reloadData()
        } else {
            isAscending = true
            diaryList.sort() { $0.date < $1.date }
            diaryListTV.reloadData()
        }
    }
    
    @IBAction func newBtnAction(_ sender: Any) {
        let dvc = UIStoryboard(name: "Diary", bundle: nil).instantiateViewController(withIdentifier: "DiaryNewVC") as! DiaryNewVC
        
        dvc.mode = DiaryMode.new
        
        self.navigationController!.pushViewController(dvc, animated: true)
    }
    
    @IBAction func settingsBtnAction(_ sender: Any) {
        let dvc = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "SettingsVC")
        
        self.navigationController!.pushViewController(dvc, animated: true)
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
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
        self.addChild(popUpVC)
        popUpVC.view.frame = self.view.frame
        self.view.addSubview(popUpVC.view)
        popUpVC.didMove(toParent: self)
    }
    
    func registerTVC() {
        let nibName = UINib(nibName: "DiaryListTVC", bundle: nil)
        diaryListTV.register(nibName, forCellReuseIdentifier: "DiaryListTVC")
    }

    func addEmptyView() {
        let screenSize: CGRect = UIScreen.main.bounds
        emptyView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        emptyView.backgroundColor = UIColor.whiteForBorder
        let image: UIImage = UIImage(named: "imgListZero")!
        let emptyImageView = UIImageView(image: image)
        emptyImageView.frame = CGRect(x: 117, y: 225, width: image.size.width, height: image.size.height)
        emptyView.addSubview(emptyImageView)
        self.view.addSubview(emptyView)
    }
}

extension DiaryListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if diaryList.count == 0 {
            tableView.backgroundView?.isHidden = false
//            addEmptyView()
        } else {
            tableView.backgroundView?.isHidden = true
//            emptyView.removeFromSuperview()
        }
        
        print(diaryList.count)
        
        return diaryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = diaryListTV.dequeueReusableCell(withIdentifier: "DiaryListTVC") as! DiaryListTVC
        
        let date: Date = dateFormatter.date(from: diaryList[indexPath.row].date)!
        let day = Calendar.current.component(.day, from: date)
        
        cell.dateLabel.text = String(day)
        cell.dayOfWeekLabel.text = date.getDayOfTheWeek(lang: "ko")
        cell.titleLabel.text = diaryList[indexPath.row].diary_content
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.whiteForBorder.cgColor
        
        return cell
    }
}

extension DiaryListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! DiaryListTVC
        
        let dvc = storyboard?.instantiateViewController(withIdentifier: "DiaryDetailVC") as! DiaryDetailVC
    
        dvc.date = "\(inputDate.year!)-\(String(format: "%02d", inputDate.month!))-\(cell.dateLabel.text!)"

        navigationController?.pushViewController(dvc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제", handler: { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            
            tableView.beginUpdates()
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            // 데이터 삭제하는 부분.. 서버 연동하면 바꿔야됨.
//            self.testArr.remove(at: 0)
            
            tableView.endUpdates()
            
            success(true)
            
        })
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}


extension DiaryListVC: DateDelegate {
    func changeDate(year: Int, month: Int) {
        inputDate = DateComponents(year: year, month: month)
        
        setNavigationBar()
        diaryListTV.reloadData()
    }
}
