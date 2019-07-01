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

//        addTableView()
        setNavigationBar()
        registerTVC()
        diaryListTV.delegate = self
        diaryListTV.dataSource = self
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
    
//    func addTableView() {
//        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
//        let displayWidth: CGFloat = self.view.frame.width
//        let displayHeihgt: CGFloat = self.view.frame.height
//
//        diaryListTV = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeihgt - barHeight))
//        diaryListTV.register(UITableViewCell.self, forCellReuseIdentifier: "diaryListCell")
//        diaryListTV.dataSource = self
//        diaryListTV.delegate = self
//        self.view.addSubview(diaryListTV)
//    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("Num: \(indexPath.row)")
//        print("Value: \(testArr[indexPath.row])")
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return testArr.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "DiaryListTVC", for: indexPath as IndexPath)
//        cell.textLabel!.text = "\(testArr[indexPath.row])"
        
//        cell.dateLabel.text = "16"
//        cell.dayOfWeekLabel.text = "수"
//        cell.titleLabel.text = "여기에 본문이 들어감 여기에 본문이 들어감 여기에 본문이 들어감"
        
//        return cell
//    }
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
        
//        let episode = episodeList[indexPath.row]
        
//        cell.thumbnailImg.imageFromUrl(gsno(episode.thumbnail), defaultImgPath: "thumbnailImg")
//        cell.titleLabel.text = episode.title
//
//        let largeNumber = gino(episode.hits)
//        let numberFormatter = NumberFormatter()
//        numberFormatter.numberStyle = .decimal
//        let formattedNumber = numberFormatter.string(from: NSNumber(value: largeNumber))
//
//        cell.hitsLabel.text = "조회수 \(gsno(formattedNumber)) 회"
        
        return cell
    }
}

extension DiaryListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dvc = storyboard?.instantiateViewController(withIdentifier: "DiaryDetailVC") as! DiaryDetailVC
        
//        let episode = episodeList[indexPath.row]
//        dvc.epIdx = episode.idx
        
        navigationController?.pushViewController(dvc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제", handler: { (ac:UIContextualAction, view: UIView, success: (Bool) -> Void) in
            
            success(true)
            
        })
        
//        deleteAction.image = UIImage(named: "")
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
