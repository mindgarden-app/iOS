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
    
    var testArr: [String] = ["기분이 너무 좋아요", "기분이 너무 좋아요", "기분이 너무 좋아요", "기분이 너무 좋아요", "기분이 너무 좋아요", "기분이 너무 좋아요", "기분이 너무 좋아요", "기분이 너무 좋아요", "기분이 너무 좋아요", "기분이 너무 좋아요", "기분 선택 안함"]
    var imgArr: [String] = ["imgWeather1", "imgWeather1", "imgWeather1", "imgWeather1", "imgWeather1", "imgWeather1", "imgWeather1", "imgWeather1", "imgWeather1", "imgWeather1", "imgWeather0"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerTVC()
        moodTV.delegate = self
        moodTV.dataSource = self
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        moodTV.makeRounded(cornerRadius: 10)
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

