//
//  DiaryPopUpVC.swift
//  MindGarden
//
//  Created by Sunghee Lee on 01/07/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit

protocol MoodDelegate: class {
    func changeMood(img: String, text: String, index: Int)
}

class DiaryPopUpVC: UIViewController {

    @IBOutlet var moodTV: UITableView!
    
    var delegate: MoodDelegate? = nil
    var moodTextArr: [String] = ["좋아요", "신나요", "그냥 그래요", "심심해요", "재미있어요", "설레요", "별로예요", "우울해요", "짜증나요", "화가 나요", "기분 없음"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerTVC()
        moodTV.delegate = self
        moodTV.dataSource = self
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.moodTV.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0);
        moodTV.makeRounded(cornerRadius: 8)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first?.view?.tag != 100 {
            removePopUp()
            super.touchesEnded(touches , with: event)
        }
    }
    
    func registerTVC() {
        let nibName = UINib(nibName: "DiaryPopUpTVC", bundle: nil)
        moodTV.register(nibName, forCellReuseIdentifier: "DiaryPopUpTVC")
    }
    
    @objc func removePopUp() {
        UIView.animate(withDuration: 0.2, animations: {self.view.alpha = 0.0},
                       completion: {(value: Bool) in
                        self.view.removeFromSuperview()
        })
    }
}

extension DiaryPopUpVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moodTextArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = moodTV.dequeueReusableCell(withIdentifier: "DiaryPopUpTVC") as! DiaryPopUpTVC
        
        let moodText = moodTextArr[indexPath.row]
        
        cell.moodImage.image = UIImage(named: "imgWeather\(indexPath.row + 1)")
        cell.moodLabel.text = moodText
        
        return cell
    }
}

extension DiaryPopUpVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(delegate != nil){
            let moodText = moodTextArr[indexPath.row]
            let moodImg = "imgWeather\(indexPath.row + 1)"
            delegate?.changeMood(img: moodImg, text: moodText, index: indexPath.row)
            self.view.removeFromSuperview()
        }
    }
}

