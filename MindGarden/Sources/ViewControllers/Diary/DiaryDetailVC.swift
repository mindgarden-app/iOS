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
    @IBOutlet var bodyTextViewHeightConstraint: NSLayoutConstraint!
    
    var imageView: UIImageView!
    var moodText: String = "기분이 좋아"
    var moodImg: String = "imgWeather1"
    var time: String = "21:00:00"
    var image: String = "https://homepages.cae.wisc.edu/~ece533/images/airplane.png"
    var body: String = "여기는 본문입니다 여기는 본문입니다 여기는 본문입니다 여기는 본문입니다 여기는 본문입니다 여기는 본문입니다 여기는 본문입니다 여기는 본문입니다 여기는 본문입니다 여기는 본문입니다 여기는 본문입니다 여기는 본문입니다 여기는 본문입니다 여기는 본문입니다 여기는 본문입니다 여기는 본문입니다 여기는 본문입니다 여기는 본문입니다 여기는 본문입니다 여기는 본문입니다 "
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBar()
        
        setData()
        if !image.isEmpty {
            print("image is not empty!")
            imageView = UIImageView(image: UIImage(named: "imgWeather0"))
            setImageView()
        }
    }
    
    func setNavigationBar() {
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "yy.MM.dd"
        let dateStr = dateFormatter.string(from: today)
        let dayOfTheWeekStr: String? = today.getDayOfTheWeek()
        
        self.navigationItem.title = "\(dateStr) (\(String(dayOfTheWeekStr!)))"
    }
    
    func setData() {
        moodImageView = UIImageView(image: UIImage(named: moodImg))
        moodLabel.text = moodText
        timeLabel.text = time
        bodyTextView.text = body
        bodyTextView.textContainerInset = UIEdgeInsets.zero
        bodyTextView.textContainer.lineFragmentPadding = 0
        bodyTextViewHeightConstraint.constant = bodyTextView.contentSize.height
    }

    func setImageView() {
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: URL(string: image), placeholder: nil, options:  [.transition(.fade(0.7))], progressBlock: nil)
        imageView.frame = CGRect(x: self.view.center.x - 166, y: bodyTextView.frame.maxY + 5 + bodyTextView.contentSize.height, width: 333, height: imageView.frame.size.height * 300 / imageView.frame.size.width)
        self.view.addSubview(imageView)
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
        let dvc = UIStoryboard(name: "Diary", bundle: nil).instantiateViewController(withIdentifier: "DiaryNewVC") as! DiaryNewVC
        
        dvc.mode = DiaryMode.edit
        
        self.navigationController!.pushViewController(dvc, animated: true)
    }

}
