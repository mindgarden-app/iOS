//
//  WriteViewController.swift
//  MindGarden
//
//  Created by Sunghee Lee on 30/06/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit

class DiaryNewVC: UIViewController, sendDataToViewProtocol {

    @IBOutlet var backBtn: UIBarButtonItem!
    @IBOutlet var moodBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBar()
    }
    
    func setNavigationBar() {
        // 중앙 날짜 버튼
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "yy.MM.dd"
        let dateStr = dateFormatter.string(from: today)
        let dayOfTheWeekStr: String? = today.getDayOfTheWeek()
        
        self.navigationItem.title = "\(dateStr) (\(String(dayOfTheWeekStr!)))"
    }

    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func moodBtnAction(_ sender: Any) {
        let popUpVC = UIStoryboard(name: "Diary", bundle: nil).instantiateViewController(withIdentifier: "DiaryPopUpVC") as! DiaryPopUpVC
        popUpVC.delegate = self
        self.addChild(popUpVC)
        popUpVC.view.frame = self.view.frame
        self.view.addSubview(popUpVC.view)
        popUpVC.didMove(toParent: self)
    }
    
    func inputData(data: String) {
        print(data)
        moodBtn.setTitle(data, for: .normal)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}