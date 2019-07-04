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
    private let testArr: NSArray = ["First", "Second", "Third"]
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
        
    }
    
    @IBAction func newBtnAction(_ sender: Any) {
        let dvc = UIStoryboard(name: "Diary", bundle: nil).instantiateViewController(withIdentifier: "DiaryNewVC")
        
        self.navigationController!.pushViewController(dvc, animated: true)
    }
    
    @IBAction func settingsBtnAction(_ sender: Any) {
        let dvc = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "SettingsVC")
        
        self.navigationController!.pushViewController(dvc, animated: true)
    }
    
    
    func setNavigationBar() {
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "yyyy년 M월"
        let dateStr = dateFormatter.string(from: today)
        
        self.navigationItem.title = dateStr
    }
    
    func registerTVC() {
        let nibName = UINib(nibName: "DiaryListTVC", bundle: nil)
        diaryListTV.register(nibName, forCellReuseIdentifier: "DiaryListTVC")
    }
}

extension DiaryListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return testArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = diaryListTV.dequeueReusableCell(withIdentifier: "DiaryListTVC") as! DiaryListTVC

        cell.dateLabel.text = "16"
        cell.dayOfWeekLabel.text = "수"
        cell.titleLabel.text = "여기에 본문이 들어감 여기에 본문이 들어감 여기에 본문이 들어감"
        
        return cell
    }
}

extension DiaryListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dvc = storyboard?.instantiateViewController(withIdentifier: "DiaryDetailVC") as! DiaryDetailVC

        navigationController?.pushViewController(dvc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제", handler: { (ac:UIContextualAction, view: UIView, success: (Bool) -> Void) in
            
            success(true)
            
        })
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
