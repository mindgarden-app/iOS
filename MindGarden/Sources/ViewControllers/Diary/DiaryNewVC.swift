//
//  WriteViewController.swift
//  MindGarden
//
//  Created by Sunghee Lee on 30/06/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit

enum DiaryMode {
    case new
    case edit
}

class DiaryNewVC: UIViewController {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var contentView: UIView!
    @IBOutlet var backBtn: UIBarButtonItem!
    @IBOutlet var moodTextBtn: UIButton!
    @IBOutlet var moodImgBtn: UIButton!
    @IBOutlet var galleryBtn: UIButton!
    @IBOutlet var inputTextView: UITextView!
    @IBOutlet var inputTextViewHeightConstraint: NSLayoutConstraint!
    
    let moodTextArr: [String] = ["좋아요", "신나요", "그냥 그래요", "심심해요", "재미있어요", "설레요", "별로예요", "우울해요", "짜증나요", "화가 나요", "기분 없음"]
    
    var diary: Diary!
    
    var mode: DiaryMode!
    var date: String!
    var imageView: UIImageView!
    let picker = UIImagePickerController()
//    let userIdx = UserDefaults.standard.integer(forKey: "userIdx")
    let userIdx = 2
    var weatherIdx: Int!
    var placeholder = "내용"
    var galleryBtnMinY: CGFloat!
    var galleryBtnMaxY: CGFloat!
    var scrollViewContentSize: CGFloat = 0;
    var scrollViewContentSizeWithText: CGFloat = 0;

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self

        setNavigationBar()
        setTextView()
        setgalleryBtnY()
        
        if mode == .edit {
            getData()
        }
        
        picker.delegate = self
        inputTextView.delegate = self
        
        self.hideKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification , object: nil)
    }
    
    func setNavigationBar() {
        // 중앙 날짜 버튼
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "yy.MM.dd"
        let dateStr = dateFormatter.string(from: today)
        let dayOfTheWeekStr: String? = today.getDayOfTheWeek(lang: "ko")
        
        self.navigationItem.title = "\(dateStr) (\(String(dayOfTheWeekStr!)))"
        
        if mode == .new {
            self.setNavigationBarItem(image: "btnRegister.png", target: self, action: #selector(saveBtnAction), direction: "right")
        } else if mode == .edit {
            self.setNavigationBarItem(image: "btnComplete.png", target: self, action: #selector(completeBtnAction), direction: "right")
        }
    }
    
    func setTextView() {
        inputTextView.text = placeholder
        inputTextView.textColor = UIColor.lightGray
        inputTextViewHeightConstraint.constant = self.inputTextView.contentSize.height + 36
        scrollViewContentSize = inputTextView.frame.maxY
    }
    
    func setgalleryBtnY() {
        self.view.bringSubviewToFront(galleryBtn)
        galleryBtnMaxY = galleryBtn.frame.origin.y
    }
    
    func getData() {
        
        DiaryService.shared.getDiary(userIdx: userIdx, date: date!) {
            data in
            
            switch data {
            case .success(let res):
                print("success")
                self.diary = res as? Diary
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
        print("setData")
        weatherIdx = diary.weatherIdx
        let moodImage = "imgWeather\(diary.weatherIdx + 1)"
        moodImgBtn.setImage(UIImage(named: moodImage), for: .normal)
        moodTextBtn.setTitle(moodTextArr[diary.weatherIdx], for: .normal)
        moodTextBtn.setTitleColor(UIColor.GrayForFont, for: .normal)
    
        inputTextView.text = diary.diary_content
        inputTextView.textColor = UIColor.GrayForFont
        inputTextView.textContainerInset = UIEdgeInsets.zero
        inputTextView.textContainer.lineFragmentPadding = 0
        inputTextViewHeightConstraint.constant = inputTextView.contentSize.height + 36
    }
    
    func setImageView() {
        imageView = UIImageView(image: UIImage(named: "imgWeather11"))
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: URL(string: diary.diary_img!), placeholder: nil, options:  [.transition(.fade(0.7))], progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
            
            self.imageView.frame = CGRect(x: self.view.center.x - 166, y: 150 + self.inputTextView.contentSize.height, width: 333, height: (self.imageView.image?.size.height)! * 333 / (self.imageView.image?.size.width)!)
        })
        
        scrollViewContentSize += (self.imageView.image?.size.height)! * 333 / (self.imageView.image?.size.width)!
        scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width, height: scrollViewContentSize)
        
        contentView.insertSubview(imageView, belowSubview: galleryBtn)
    }

    @IBAction func backBtnAction(_ sender: Any) {
        self.pop()
    }
    
    @IBAction func moodBtnAction(_ sender: Any) {
        let popUpVC = UIStoryboard(name: "Diary", bundle: nil).instantiateViewController(withIdentifier: "DiaryPopUpVC") as! DiaryPopUpVC
        popUpVC.delegate = self
        self.addChild(popUpVC)
        popUpVC.view.frame = self.view.frame
        self.view.addSubview(popUpVC.view)
        popUpVC.didMove(toParent: self)
    }
    
    
    @IBAction func galleryBtnAction(_ sender: Any) {
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func saveBtnAction(_ sender: Any) {
        if inputTextView.text == placeholder {
            self.simpleAlert(title: "Oops!", message: "일기를 작성해주세요")
            return
        }
        
        if weatherIdx == nil {
            self.simpleAlert(title: "Oops!", message: "기분을 선택해주세요")
            return
        }
        
        let image = imageView != nil ? imageView.image : nil
        
        DiaryService.shared.addDiary(userIdx: userIdx, diaryContent: inputTextView.text!, diaryImage: image, weatherIdx: weatherIdx!) {
            data in
            
            switch data {
            case .success(let message):
                if String(describing: message) == "이미 일기를 등록 하셨습니다!" {
                    self.simpleAlertWithPop(title: "Oops!", message: "일기는 하루에 하나만 쓸 수 있어요!ㅠㅠ")
                    
                    break
                }
                
                let dvc = UIStoryboard(name: "Diary", bundle: nil).instantiateViewController(withIdentifier: "DiaryDetailVC") as! DiaryDetailVC
                
                let today = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "ko_kr")
                dateFormatter.timeZone = TimeZone(abbreviation: "KST")
                dateFormatter.dateFormat = "yyyy-MM"
                let dateStr = dateFormatter.string(from: today)
                
                dvc.date = dateStr
                
                self.navigationController!.pushViewController(dvc, animated: true)
                
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
    
    @IBAction func completeBtnAction(_ sender: Any) {
        let image = imageView != nil ? imageView.image : nil
        
        DiaryService.shared.editDiary(userIdx: userIdx, date: date!, diaryContent: inputTextView.text!, diaryImage: image, weatherIdx: weatherIdx!) {
            data in
            
            switch data {
            case .success(_):
                self.simpleAlert(title: "수정 완료", message: "일기가 수정되었습니다")
                
//                let dvc = UIStoryboard(name: "Diary", bundle: nil).instantiateViewController(withIdentifier: "DiaryDetailVC") as! DiaryDetailVC
//
//                // Todo
//                // 오늘이 아니라 받은 날짜로 해야됨
//                let today = Date()
//                let dateFormatter = DateFormatter()
//                dateFormatter.locale = Locale(identifier: "ko_kr")
//                dateFormatter.timeZone = TimeZone(abbreviation: "KST")
//                dateFormatter.dateFormat = "yyyy-MM"
//                let dateStr = dateFormatter.string(from: today)
//
//                dvc.date = dateStr
//
//                self.navigationController!.pushViewController(dvc, animated: true)
                
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
        
        let dvc = UIStoryboard(name: "Diary", bundle: nil).instantiateViewController(withIdentifier: "DiaryListVC")
        
        self.navigationController!.pushViewController(dvc, animated: true)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            galleryBtn.frame = CGRect(x: galleryBtn.frame.origin.x, y: galleryBtnMaxY - keyboardSize.size.height, width: galleryBtn.frame.size.width, height: galleryBtn.frame.size.height)
            galleryBtnMinY = galleryBtnMaxY - keyboardSize.size.height
            print(galleryBtn.frame.origin.y)
            print("show")
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            galleryBtn.frame = CGRect(x: galleryBtn.frame.origin.x, y: (galleryBtnMinY == nil ? 746 :  galleryBtnMinY + keyboardSize.size.height), width: galleryBtn.frame.size.width, height: galleryBtn.frame.size.height)
            print(galleryBtn.frame.origin.y)
            print("hide")
        }
    }
}

extension DiaryNewVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholder {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = placeholder
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        inputTextViewHeightConstraint.constant = self.inputTextView.contentSize.height + 36
        
        galleryBtn.frame = CGRect(x: galleryBtn.frame.origin.x, y: 455, width: galleryBtn.frame.size.width, height: galleryBtn.frame.size.height)
        
        if imageView != nil && imageView.frame.origin.y != inputTextView.frame.maxY + 10 {
            imageView.frame = CGRect(x: imageView.frame.origin.x, y: 150 + self.inputTextView.contentSize.height, width: imageView.frame.size.width, height: imageView.frame.size.height)
        }
        
        scrollViewContentSizeWithText = scrollViewContentSize + inputTextViewHeightConstraint.constant
        scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width, height: scrollViewContentSizeWithText)
    }
}

extension DiaryNewVC: MoodDelegate {
    
    func changeMood(img: String, text: String, index: Int) {
        moodImgBtn.setImage(UIImage(named: img), for: .normal)
        moodTextBtn.setTitle(text, for: .normal)
        moodTextBtn.setTitleColor(UIColor.Gray, for: .normal)
        weatherIdx = index
    }
    
}

extension DiaryNewVC : UIImagePickerControllerDelegate,
UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }

        if imageView != nil {
           imageView.image = nil
        }
        
        imageView = UIImageView(image: pickedImage)
        imageView.frame = CGRect(x: self.contentView.center.x - 187, y: 150 + self.inputTextView.contentSize.height, width: 375, height: pickedImage.size.height * 300 / pickedImage.size.width)
        imageView.contentMode = .scaleAspectFit
        
        if scrollViewContentSizeWithText == nil {
            scrollViewContentSize += pickedImage.size.height * 300 / pickedImage.size.width
            scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width, height: scrollViewContentSize)
        } else {
            scrollViewContentSize += pickedImage.size.height * 300 / pickedImage.size.width
            scrollViewContentSizeWithText += pickedImage.size.height * 300 / pickedImage.size.width
        }
        
        contentView.insertSubview(imageView, belowSubview: galleryBtn)

        self.dismiss(animated: true, completion: nil)
    }
}

extension DiaryNewVC : UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if (self.navigationController?.viewControllers.count)! > 1 {
            return true
        }
        
        return false
    }
}
