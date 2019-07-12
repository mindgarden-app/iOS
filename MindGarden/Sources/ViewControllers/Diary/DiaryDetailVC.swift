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

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var contentView: UIView!
    @IBOutlet var backBtn: UIBarButtonItem!
    @IBOutlet var moodImageView: UIImageView!
    @IBOutlet var moodLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var bodyTextView: UITextView!
    @IBOutlet var bodyTextViewHeightConstraint: NSLayoutConstraint!
    
    var imageView: UIImageView!
    var weatherIdx: Int!
    var date: String!
    var diary: Diary!
    let moodTextArr: [String] = ["좋아요", "신나요", "그냥 그래요", "심심해요", "재미있어요", "설레요", "별로예요", "우울해요", "짜증나요", "화가 나요", "기분 없음"]
    let userIdx = 2
    var scrollViewContentSize: CGFloat = 0;

    override func viewDidLoad() {
        super.viewDidLoad()

        getData()
    }
    
    func setNavigationBar(date: Date?) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "yy.MM.dd"
        
        if date != nil {
            let dateStr = dateFormatter.string(from: date!)
            let dayOfTheWeekStr: String? = date!.getDayOfTheWeek(lang: "ko")
            
            self.navigationItem.title = "\(dateStr) (\(String(dayOfTheWeekStr!)))"
        } else {
            let today = Date()
            
            let dateStr = dateFormatter.string(from: today)
            let dayOfTheWeekStr: String? = today.getDayOfTheWeek(lang: "ko")
            
            self.navigationItem.title = "\(dateStr) (\(String(dayOfTheWeekStr!)))"
        }
    }
    
    func getData() {
        DiaryService.shared.getDiary(userIdx: userIdx, date: date!) {
            data in
            
            switch data {
            case .success(let res):
                self.diary = res as! Diary
                self.setData()
                if self.diary.diary_img != nil {
                    self.setImageView()
                }
                break
            case .requestErr(let err):
                print(err)
                break
            case .pathErr:
                print("경로 에러")
                break
            case .serverErr:
                print("서버 에러")
                break
            case .networkFail:
                print("네트워크 에러")
                break
            }
        }
    }
    
    func setData() {
        print("\(diary.weatherIdx)")
        let moodImage = "imgWeather\(diary.weatherIdx + 1)"
        print(moodImage)
        moodImageView.image = UIImage(named: moodImage)
        moodLabel.text = moodTextArr[diary.weatherIdx]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd EEE HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "KST") as TimeZone?
        print(diary.date)
        let date: Date = dateFormatter.date(from: diary.date)!
        print(date)
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        setNavigationBar(date: date)
        
        timeLabel.text = "\(String(format: "%02d", hour)):\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))"
        bodyTextView.text = diary.diary_content
        bodyTextView.textContainerInset = UIEdgeInsets.zero
        bodyTextView.textContainer.lineFragmentPadding = 0
        bodyTextViewHeightConstraint.constant = bodyTextView.contentSize.height
        scrollViewContentSize = bodyTextView.frame.maxY + 10
        scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width, height: self.scrollViewContentSize)
    }

    func setImageView() {
        imageView = UIImageView(image: UIImage(named: "imgWeather11"))
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: URL(string: diary.diary_img!), placeholder: nil, options:  [.transition(.fade(0.7))], progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
            
            self.imageView.frame = CGRect(x: self.view.center.x - 166, y: 150 + self.bodyTextView.contentSize.height, width: 333, height: (self.imageView.image?.size.height)! * 333 / (self.imageView.image?.size.width)!)
            
            self.scrollViewContentSize = (self.imageView.image?.size.height)! * 333 / (self.imageView.image?.size.width)! + 150 + self.bodyTextView.contentSize.height
            self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width, height: self.scrollViewContentSize)
            
            self.contentView.addSubview(self.imageView)
        })
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.pop()
//        backTwo()
//        self.navigationController?.popViewController(animated: true)
    }
    
    func backTwo() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
    
    @IBAction func editBtnAction(_ sender: Any) {
        let dvc = UIStoryboard(name: "Diary", bundle: nil).instantiateViewController(withIdentifier: "DiaryNewVC") as! DiaryNewVC
        
        dvc.mode = DiaryMode.edit
        dvc.date = date!
        print(date!)
        
        self.navigationController!.pushViewController(dvc, animated: true)
    }

}
