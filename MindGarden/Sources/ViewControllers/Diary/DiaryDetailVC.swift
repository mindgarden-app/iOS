//
//  DetailViewController.swift
//  MindGarden
//
//  Created by Sunghee Lee on 30/06/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit
import Kingfisher
import NVActivityIndicatorView

class DiaryDetailVC: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var contentView: UIView!
    @IBOutlet var backBtn: UIBarButtonItem!
    @IBOutlet var moodImageView: UIImageView!
    @IBOutlet var moodLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var bodyTextView: UITextView!
    @IBOutlet var bodyTextViewHeightConstraint: NSLayoutConstraint!
    
    let moodTextArr: [String] = ["좋아요", "신나요", "그냥 그래요", "심심해요", "재미있어요", "설레요", "별로예요", "우울해요", "짜증나요", "화가 나요", "기분 없음"]
    let bodyFontSizeArr: [Float] = [13, 13.5, 14, 14.5, 15]
    let timeFontSizeArr: [Float] = [12, 12.5, 13, 13.5, 14]
    
    var imageView: UIImageView!
    var weatherIdx: Int!
    var date: String!
    var diary: Diary!
    var diaryIdx: Int!
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
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func getData() {
        DiaryService.shared.getDiary(diaryIdx: diaryIdx!) { data in
            switch data {
            case .success(let res):
                self.diary = res as! Diary
                self.setData()
                if self.diary.diary_img != nil {
                    DispatchQueue.main.async {
                        self.setImageView()
                    }
                }
                break
            case .requestErr(let err):
                if String(describing: err) == "만료된 토큰입니다." {
                    AuthService.shared.refreshAccesstoken() { [weak self] data in
                        guard let `self` = self else { return }
                        
                        switch data {
                        case .success(let res):
                            let data = res as! Token
                            
                            UserDefaults.standard.set(data.token, forKey: "token")
                            break
                        case .requestErr(let err):
                            print(".requestErr(\(err))")
                            break
                        case .pathErr:
                            print("경로 에러")
                            break
                        case .serverErr:
                            print("서버 에러")
                            break
                        case .networkFail:
                            self.simpleAlert(title: "통신 실패", message: "네트워크 상태를 확인하세요.")
                            break
                        }
                    }
                }
                break
            case .pathErr:
                print("경로 에러")
                break
            case .serverErr:
                print("서버 에러")
                break
            case .networkFail:
                self.simpleAlert(title: "통신 실패", message: "네트워크 상태를 확인하세요.")
                break
            }
        }
    }
    
    func setData() {
        let moodImage = "imgWeather\(diary.weatherIdx + 1)"
        moodImageView.image = UIImage(named: moodImage)
        moodLabel.text = moodTextArr[diary.weatherIdx]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd EEE HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "KST") as TimeZone?
        let date: Date = dateFormatter.date(from: diary.date)!
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        setNavigationBar(date: date)
        
        timeLabel.text = "\(String(format: "%02d", hour)):\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))"
        timeLabel.font = UIFont(name:"NotoSansCJKkr-Bold", size: CGFloat(timeFontSizeArr[UserDefaults.standard.integer(forKey: "fontSize")]))
        bodyTextView.font = UIFont(name:"NotoSansCJKkr-DemiLight", size: CGFloat(bodyFontSizeArr[UserDefaults.standard.integer(forKey: "fontSize")]))
        bodyTextView.text = diary.diary_content
        bodyTextView.textContainerInset = UIEdgeInsets.zero
        bodyTextView.textContainer.lineFragmentPadding = 0
        bodyTextView.sizeToFit()
        bodyTextViewHeightConstraint.constant = bodyTextView.contentSize.height
        bodyTextView.isEditable = false
        scrollViewContentSize = bodyTextView.frame.minY + bodyTextView.contentSize.height + 10
        scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width, height: self.scrollViewContentSize)
    }

    func setImageView() {
        let size = CGSize(width: 50, height: 50)
        let activityData = ActivityData(size: size, message: "Loading", type: .lineSpinFadeLoader, color: UIColor.lightGreen, textColor: UIColor.lightGreen)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        imageView = UIImageView(image: UIImage(named: "imgWeather11"))
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: URL(string: diary.diary_img!), placeholder: nil, options:  [.transition(.fade(0.7))], progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
            
            self.imageView.frame = CGRect(x: self.view.center.x - 166, y: 150 + self.bodyTextView.contentSize.height, width: 333, height: (self.imageView.image?.size.height)! * 333 / (self.imageView.image?.size.width)!)
            
            self.scrollViewContentSize += (self.imageView.image?.size.height)! * 333 / (self.imageView.image?.size.width)!
//            self.scrollViewContentSize = (self.imageView.image?.size.height)! * 333 / (self.imageView.image?.size.width)! + 150 + self.bodyTextView.contentSize.height
            self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width, height: self.scrollViewContentSize)
            
            self.contentView.addSubview(self.imageView)
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        })
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.pop()
    }
    
    func backTwo() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
    
    @IBAction func editBtnAction(_ sender: Any) {
        let dvc = UIStoryboard(name: "Diary", bundle: nil).instantiateViewController(withIdentifier: "DiaryNewVC") as! DiaryNewVC
        
        dvc.mode = DiaryMode.edit
        dvc.date = date!
        dvc.diaryIdx = diaryIdx
        
        self.navigationController!.pushViewController(dvc, animated: true)
    }
}
