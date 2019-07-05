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
//    var testArr: [String] = []
    private var testArr: [String] = ["First", "Second", "Third"]
    var inputDate: DateComponents!
    var dateStr: String = ""
    @IBOutlet var settingsBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = false
        
        setNavigationBar()
        registerTVC()
        diaryListTV.delegate = self
        diaryListTV.dataSource = self
    }
    
    @IBAction func sortBtnAction(_ sender: Any) {
        // diaryListTV.reloadData()
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
//        let dvc: UIViewController! = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
////
////        self.navigationController!.popToViewController(dvc, animated: true)
//        for controller in self.navigationController!.viewControllers as Array {
//            if controller.isKind(of: dvc) {
//                self.navigationController!.popToViewController(controller, animated: true)
//                break
//            }
//        }
        
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
        
//        let comps = DateComponents(year: 2019, month: 3, day: 1)
//        date = calendar.date(from: comps)
//
//        self.navigationItem.title = dateStr
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
        let emptyView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        emptyView.backgroundColor = UIColor.whiteForBorder
        let emptyImageView = UIImageView(image: UIImage(named: "imgListzero"))
        emptyImageView.frame = CGRect(x: 117, y: 136, width: emptyImageView.frame.size.width, height: emptyImageView.frame.size.height)
        emptyView.addSubview(emptyImageView)
        self.view.addSubview(emptyView)
    }
}

extension DiaryListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if testArr.count == 0 {
            tableView.backgroundView?.isHidden = false
            addEmptyView()
        } else {
            tableView.backgroundView?.isHidden = true
        }
        
        return testArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = diaryListTV.dequeueReusableCell(withIdentifier: "DiaryListTVC") as! DiaryListTVC
        
        let day = 16
        let dateComponents = DateComponents(year: inputDate.year, month: inputDate.month, day: day)
        let date = Calendar.current.date(from: dateComponents)
        
        cell.dateLabel.text = String(day)
        cell.dayOfWeekLabel.text = date?.getDayOfTheWeek()
        cell.titleLabel.text = "여기에 본문이 들어감 여기에 본문이 들어감 여기에 본문이 들어감"
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.whiteForBorder.cgColor
        
        return cell
    }
}

extension DiaryListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dvc = storyboard?.instantiateViewController(withIdentifier: "DiaryDetailVC") as! DiaryDetailVC

        navigationController?.pushViewController(dvc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제", handler: { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            
            tableView.beginUpdates()
            
            print(indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            // 데이터 삭제하는 부분.. 서버 연동하면 바꿔야됨.
            self.testArr.remove(at: 0)
            
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
