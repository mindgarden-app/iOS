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
    
    @IBOutlet var homeBtn: UIButton!
    @IBOutlet var newBtn: UIButton!
    @IBOutlet var listBtn: UIButton!
    
    private var dateStr: String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
    }
    
    func setNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor.white
        
        // 중앙 날짜 버튼
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
    }
    
    @IBAction func homeBtnAction(_ sender: Any) {
        let dvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainVC")
        
        self.navigationController!.pushViewController(dvc, animated: true)
    }
    
    @IBAction func newBtnAction(_ sender: Any) {
        let dvc = UIStoryboard(name: "Diary", bundle: nil).instantiateViewController(withIdentifier: "DiaryNewVC")

        self.navigationController!.pushViewController(dvc, animated: true)
    }

    @IBAction func listBtnAction(_ sender: Any) {
        let dvc = UIStoryboard(name: "Diary", bundle: nil).instantiateViewController(withIdentifier: "DiaryListVC")

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

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}


extension MainVC: DateDelegate {
    func changeDate(year: Int, month: Int) {
        dateStr = String(year)
    }
}
