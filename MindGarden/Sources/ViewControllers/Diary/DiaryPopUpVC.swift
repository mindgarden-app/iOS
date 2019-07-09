//
//  DiaryPopUpVC.swift
//  MindGarden
//
//  Created by Sunghee Lee on 01/07/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit

protocol MoodDelegate: class {
    func changeMood(img: String, text: String)
}

class DiaryPopUpVC: UIViewController {

    @IBOutlet var moodTV: UITableView!
    
    var delegate: MoodDelegate? = nil
    
    var testArr: [String] = ["좋아요", "신나요", "그냥 그래요", "심심해요", "재미있어요", "설레요", "별로예요", "우울해요", "짜증나요", "화가 나요", "기분 없음"]
    var imgArr: [String] = ["imgWeather1Good", "imgWeather2Excited", "imgWeather3Soso", "imgWeather4Bored", "imgWeather5Funny", "imgWeather6Rainbow", "imgWeather7Notgood", "imgWeather8Sad", "imgWeather9Annoying", "imgWeather10Lightning", "imgWeather11None"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerTVC()
        moodTV.delegate = self
        moodTV.dataSource = self
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        moodTV.makeRounded(cornerRadius: 8)
    }
    
    func registerTVC() {
        let nibName = UINib(nibName: "DiaryPopUpTVC", bundle: nil)
        moodTV.register(nibName, forCellReuseIdentifier: "DiaryPopUpTVC")
    }
}

extension DiaryPopUpVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return testArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = moodTV.dequeueReusableCell(withIdentifier: "DiaryPopUpTVC") as! DiaryPopUpTVC
        
        let moodText = testArr[indexPath.row]
        
        cell.moodImage.image = UIImage(named: imgArr[indexPath.row])
        cell.moodLabel.text = moodText
        
        return cell
    }
}

extension DiaryPopUpVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(delegate != nil){
            let moodText = testArr[indexPath.row]
            let moodImg = imgArr[indexPath.row]
            delegate?.changeMood(img: moodImg, text: moodText)
            self.view.removeFromSuperview()
        }
        
//        let dvc = storyboard?.instantiateViewController(withIdentifier: "DiaryDetailVC") as! DiaryDetailVC
//
//        //        let episode = episodeList[indexPath.row]
//        //        dvc.epIdx = episode.idx
//
//        navigationController?.pushViewController(dvc, animated: true)
    }
}

