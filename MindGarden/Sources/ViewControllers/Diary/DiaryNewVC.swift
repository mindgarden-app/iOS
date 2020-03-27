//
//  WriteViewController.swift
//  MindGarden
//
//  Created by Sunghee Lee on 30/06/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

enum DiaryMode {
    case new
    case edit
}

public enum WriteLocation {
    case list
    case main
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
    
    let picker = UIImagePickerController()
    let moodTextArr: [String] = ["좋아요", "신나요", "그냥 그래요", "심심해요", "재미있어요", "설레요", "별로예요", "우울해요", "짜증나요", "화가 나요", "기분 없음"]
    let fontSizeArr: [Float] = [13, 13.5, 14, 14.5, 15]
    
    var diary: Diary!
    var mode: DiaryMode!
    var location: WriteLocation!
    var date: String!
    var diaryIdx: Int!
    var inputDate: Date!
    var imageView: UIImageView!
    var weatherIdx: Int!
    var placeholder = "내용"
    var galleryBtnMinY: CGFloat!
    var galleryBtnMaxY: CGFloat!
    var scrollViewContentSize: CGFloat = 0;
    var scrollViewContentSizeWithText: CGFloat = 0;
    var keyboardHeight: CGFloat = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBar()
        setTextView()
        setgalleryBtnY()
        
        if mode == .edit {
            getData()
        }
        
        picker.delegate = self
        inputTextView.delegate = self
        
        self.hideKeyboardWhenTappedAround()
        registerNotifications()
    }
    
    func registerNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification , object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification , object: nil)
    }
    
    func setNavigationBar() {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "yy.MM.dd"
        
        if mode == .new {
            let today = Date()
            
            let dateStr = dateFormatter.string(from: today)
            let dayOfTheWeekStr: String? = today.getDayOfTheWeek(lang: "ko")
            
            self.navigationItem.title = "\(dateStr) (\(String(dayOfTheWeekStr!)))"
            
            self.setNavigationBarItem(image: "btnRegister.png", target: self, action: #selector(saveBtnAction), direction: "right")
        } else if mode == .edit {
            let dateFormatterForInputDate = DateFormatter()
            dateFormatterForInputDate.dateFormat = "yyyy-MM-dd"
            inputDate = dateFormatterForInputDate.date(from: date)!
            let dateStr = dateFormatter.string(from: inputDate)
            let dayOfTheWeekStr: String? = inputDate.getDayOfTheWeek(lang: "ko")
            self.navigationItem.title = "\(dateStr) (\(String(dayOfTheWeekStr!)))"
            
            self.setNavigationBarItem(image: "btnComplete.png", target: self, action: #selector(completeBtnAction), direction: "right")
        }
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    func setTextView() {
        inputTextView.text = placeholder
        inputTextView.textColor = UIColor.lightGray
        inputTextView.font = UIFont(name:"NotoSansCJKkr-DemiLight", size: CGFloat(fontSizeArr[UserDefaults.standard.integer(forKey: "fontSize")]))
        inputTextViewHeightConstraint.constant = self.inputTextView.contentSize.height + 36
        scrollViewContentSize = inputTextView.frame.maxY
    }
    
    func setgalleryBtnY() {
        self.view.bringSubviewToFront(galleryBtn)
        galleryBtnMaxY = galleryBtn.frame.origin.y
    }
    
    func getData() {
        DiaryService.shared.getDiary(diaryIdx: diaryIdx) { data in
            switch data {
                case .success(let res):
                    self.diary = res as? Diary
                    self.setData()
                    if self.diary.diary_img != nil {
                        self.setImageView()
                    }
                    break
                case .requestErr(let err):
                    print(err)
                    if String(describing: err) == "만료된 토큰입니다." {
                        AuthService.shared.refreshAccesstoken() { [weak self] data in
                            guard let `self` = self else { return }
                            
                            switch data {
                                case .success(let res):
                                    let data = res as! Token
                                    print(res)
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
        weatherIdx = diary.weatherIdx
        let moodImage = "imgWeather\(diary.weatherIdx + 1)"
        moodImgBtn.setImage(UIImage(named: moodImage), for: .normal)
        moodTextBtn.setTitle(moodTextArr[diary.weatherIdx], for: .normal)
        moodTextBtn.setTitleColor(UIColor.GrayForFont, for: .normal)
    
        inputTextView.text = diary.diary_content
        inputTextView.textColor = UIColor.GrayForFont
        inputTextView.textContainerInset = UIEdgeInsets.zero
        inputTextView.textContainer.lineFragmentPadding = 0
        inputTextView.sizeToFit()
        inputTextViewHeightConstraint.constant = inputTextView.contentSize.height + 36
        scrollViewContentSize = inputTextView.frame.maxY
        
        if imageView != nil && imageView.frame.origin.y != inputTextView.frame.maxY + 10 {
            imageView.frame = CGRect(x: imageView.frame.origin.x, y: 150 + self.inputTextView.contentSize.height, width: imageView.frame.size.width, height: imageView.frame.size.height)
            scrollViewContentSize += imageView.frame.size.height
        }
        scrollViewContentSizeWithText += inputTextViewHeightConstraint.constant
        scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width, height: scrollViewContentSizeWithText + 200)
        scrollView.isScrollEnabled = true
//        scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width, height: 3000)
//
//        print(inputTextView.contentSize.height)
//        print(scrollViewContentSize)
//        print(self.inputTextView.contentSize.height)
//        print("\(scrollViewContentSizeWithText) 1111")
    }
    
    func setImageView() {
        imageView = UIImageView(image: UIImage(named: "imgWeather11"))
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: URL(string: diary.diary_img!), placeholder: nil, options:  [.transition(.fade(0.7))], progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
            
            self.imageView.frame = CGRect(x: self.view.center.x - 166, y: 150 + self.inputTextView.contentSize.height, width: 333, height: (self.imageView.image?.size.height)! * 333 / (self.imageView.image?.size.width)!)
            
            self.scrollViewContentSize += (self.imageView.image?.size.height)! * 333 / (self.imageView.image?.size.width)!
            self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width, height: self.scrollViewContentSize)
            
            self.contentView.insertSubview(self.imageView, belowSubview: self.galleryBtn)
        })
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
        
        DiaryService.shared.addDiary(diaryContent: inputTextView.text!, diaryImage: image, weatherIdx: weatherIdx!) {
            data in
            
            switch data {
                case .success(let message):
                    if String(describing: message) == "이미 일기를 등록 하셨습니다!" {
                        self.simpleAlertWithPop(title: "Oops!", message: "일기는 하루에 하나만 쓸 수 있어요!ㅠㅠ")
                        
                        break
                    }
                    
                    let dvc = UIStoryboard(name: "Diary", bundle: nil).instantiateViewController(withIdentifier: "DiaryListVC")
                    
                    var viewControllers: [UIViewController] = self.navigationController!.viewControllers
                    
                    if self.location == .main {
                        viewControllers.removeLast(1)
                    } else {
                        viewControllers.removeLast(2)
                    }

                    viewControllers.append(dvc)
                    
                    self.navigationController?.setViewControllers(viewControllers, animated: false)
                    
                    break
                case .requestErr(let err):
                    print(err)
                    if String(describing: err) == "만료된 토큰입니다." {
                        AuthService.shared.refreshAccesstoken() { [weak self] data in
                            guard let `self` = self else { return }
                            
                            switch data {
                                case .success(let res):
                                    let data = res as! Token
                                    print(res)
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
    
    @IBAction func completeBtnAction(_ sender: Any) {
        if inputTextView.text == "" {
            self.simpleAlert(title: "Oops!", message: "일기를 작성해주세요")
            return
        }
        
        let image = imageView != nil ? imageView.image : nil
        
        DiaryService.shared.editDiary(diaryIdx: diaryIdx!, diaryContent: inputTextView.text!, diaryImage: image, weatherIdx: weatherIdx!) {
            data in
            
            switch data {
                case .success(_):
                    
                    let dvc = UIStoryboard(name: "Diary", bundle: nil).instantiateViewController(withIdentifier: "DiaryListVC") as! DiaryListVC
                    
                    var viewControllers: [UIViewController] = self.navigationController!.viewControllers
                    
                    viewControllers.removeLast(3)
                    
                    viewControllers.append(dvc)
                    
                    
                    dvc.inputDate = Calendar.current.dateComponents([.year, .month], from: self.inputDate)
                    
                    self.navigationController?.setViewControllers(viewControllers, animated: false)
                    
                    break
                case .requestErr(let err):
                    print(err)
                    if String(describing: err) == "만료된 토큰입니다." {
                        AuthService.shared.refreshAccesstoken() { [weak self] data in
                            guard let `self` = self else { return }
                            
                            switch data {
                                case .success(let res):
                                    let data = res as! Token
                                    print(res)
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
    
    @objc func keyboardWillShow(notification: Notification) {
        let userInfo = notification.userInfo!
        
        if let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.size.height
            galleryBtn.frame = CGRect(x: galleryBtn.frame.origin.x, y: galleryBtnMaxY - keyboardSize.size.height, width: galleryBtn.frame.size.width, height: galleryBtn.frame.size.height)
            galleryBtnMinY = galleryBtnMaxY - keyboardSize.size.height
        }
        
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset: UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }

    @objc func keyboardWillHide(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            galleryBtn.frame = CGRect(x: galleryBtn.frame.origin.x, y: (galleryBtnMinY == nil ? 746 :  galleryBtnMinY + keyboardSize.size.height), width: galleryBtn.frame.size.width, height: galleryBtn.frame.size.height)
        }
    
        scrollView.contentInset.bottom = 0
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
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
        
//        var userInfo = notification.userInfo!
//
//        if let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            galleryBtn.frame = CGRect(x: galleryBtn.frame.origin.x, y: galleryBtnMaxY - keyboardSize.size.height, width: galleryBtn.frame.size.width, height: galleryBtn.frame.size.height)
//            galleryBtnMinY = galleryBtnMaxY - keyboardSize.size.height
//        }

//        if let cursorPosition = inputTextView.selectedTextRange?.start {
//            let startPosition: UITextPosition = inputTextView.beginningOfDocument
//            let caretPositionRectangle: CGRect = inputTextView.caretRect(for: cursorPosition)
//            let caretPositionRectangleForStart: CGRect = inputTextView.caretRect(for: startPosition)
//
//            var topbarHeight: CGFloat {
//                return UIApplication.shared.statusBarFrame.size.height +
//                (self.navigationController?.navigationBar.frame.height ?? 0.0)
//            }
//
//            print("\(UIScreen.main.bounds.size.height) \(inputTextView.frame.origin.y) \(caretPositionRectangleForStart.minY) \(UIScreen.main.bounds.size.height - caretPositionRectangleForStart.minY - keyboardHeight - topbarHeight) \(caretPositionRectangle.minY) \(caretPositionRectangle.maxY - 350)")
//            if caretPositionRectangle.minY + 100 > UIScreen.main.bounds.size.height - inputTextView.frame.origin.y - keyboardHeight - topbarHeight && 0 < inputTextView.frame.size.height - keyboardHeight {
//                DispatchQueue.main.async {
//                    self.scrollView.contentOffset.y = CGFloat(200)
//                }
//            }
//        }
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
