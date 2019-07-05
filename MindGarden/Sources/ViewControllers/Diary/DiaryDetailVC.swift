//
//  DetailViewController.swift
//  MindGarden
//
//  Created by Sunghee Lee on 30/06/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit
import Kingfisher

class DiaryDetailVC: UIViewController {

    @IBOutlet var backBtn: UIBarButtonItem!
    @IBOutlet var moodImageView: UIImageView!
    @IBOutlet var moodLabel: UILabel!
    @IBOutlet var timeLabel: UITextField!
    @IBOutlet var bodyTextView: UITextView!
    
    var imageView: UIImageView!
    var moodText: String = ""
    var moodImg: String = ""
    var time: String = ""
    var image: String = ""
    var body: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBar()
        
        setImageView()
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
    
//    func setData() {
//        moodImageView.image = UIImage(data: <#T##Data#>)
//    }
    
    func setImageView() {
//        let url = URL(string: "https://homepages.cae.wisc.edu/~ece533/images/airplane.png")
        moodImageView.kf.indicatorType = .activity
        moodImageView.kf.setImage(with: URL(string: "https://homepages.cae.wisc.edu/~ece533/images/airplane.png"), placeholder: nil, options:  [.transition(.fade(0.7))], progressBlock: nil)
//        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 200)
//        view.addSubview(imageView)
        // https://cocoapods.org/pods/Kingfisher
//        let url = URL(string: "")
//        do {
//            let data = try Data(contentsOf: url!)
//            let image = UIImage(data: data)
//
//        }catch let err {
//            print("Error : \(err.localizedDescription)")
//        }
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        backTwo()
//        self.navigationController?.popViewController(animated: true)
    }
    
    func backTwo() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
    
    @IBAction func editBtnAction(_ sender: Any) {
        let dvc = UIStoryboard(name: "Diary", bundle: nil).instantiateViewController(withIdentifier: "DiaryNewVC")
        
        self.navigationController!.pushViewController(dvc, animated: true)
    }

}
