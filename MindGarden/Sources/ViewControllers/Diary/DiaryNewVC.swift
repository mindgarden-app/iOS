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

    @IBOutlet var backBtn: UIBarButtonItem!
    @IBOutlet var moodTextBtn: UIButton!
    @IBOutlet var moodImgBtn: UIButton!
    @IBOutlet var galleryBtn: UIButton!
    @IBOutlet var inputTextView: UITextView!
    @IBOutlet var inputTextViewHeightConstraint: NSLayoutConstraint!
    
    var mode: DiaryMode!
    var imageView: UIImageView!
    let picker = UIImagePickerController()
    var placeholder = "내용"
    var moodText: String = "기분 수정 중"
    var moodImg: String = "imgWeather1"
    var image: String = "https://homepages.cae.wisc.edu/~ece533/images/airplane.png"
    var body: String = "본문 수정 중 본문 수정 중 본문 수정 중 본문 수정 중 본문 수정 중 본문 수정 중 본문 수정 중 본문 수정 중 본문 수정 중 본문 수정 중 본문 수정 중 본문 수정 중 본문 수정 중 본문 수정 중 본문 수정 중 본문 수정 중 본문 수정 중 본문 수정 중 본문 수정 중 본문 수정 중 본문 수정 중 본문 수정 중 "
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBar()
        setTextView()
        
        if mode == .edit {
            setData()
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
        let dayOfTheWeekStr: String? = today.getDayOfTheWeek()
        
        self.navigationItem.title = "\(dateStr) (\(String(dayOfTheWeekStr!)))"
        
        if mode == .new {
            let rightBtn = UIBarButtonItem(image: UIImage(named: "btnRegister"), style: .plain, target: self, action: #selector(saveBtnAction(_:)))
            rightBtn.tintColor = UIColor.lightGreen
            self.navigationItem.rightBarButtonItem = rightBtn
        } else if mode == .edit {
            let rightBtn = UIBarButtonItem(image: UIImage(named: "btnComplete"), style: .plain, target: self, action: #selector(completeBtnAction(_:)))
            rightBtn.tintColor = UIColor.lightGreen
            self.navigationItem.rightBarButtonItem = rightBtn
        }
    }
    
    func setTextView() {
        inputTextView.text = placeholder
        inputTextView.textColor = UIColor.lightGray
    }
    
    func setData() {
        moodTextBtn.setTitle(moodText, for: .normal)
        moodTextBtn.setTitleColor(UIColor.GrayForFont, for: .normal)
        moodImgBtn.setImage(UIImage(named: moodImg), for: .normal)
        inputTextView.text = body
        inputTextView.textColor = UIColor.GrayForFont
        inputTextView.textContainerInset = UIEdgeInsets.zero
        inputTextView.textContainer.lineFragmentPadding = 0
        inputTextViewHeightConstraint.constant = inputTextView.contentSize.height
        
        if !image.isEmpty {
            imageView = UIImageView(image: UIImage(named: "imgWeather0"))
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: URL(string: image), placeholder: nil, options:  [.transition(.fade(0.7))], progressBlock: nil)
            imageView.frame = CGRect(x: self.view.center.x - 100, y: inputTextView.frame.maxY + 5 + inputTextView.contentSize.height, width: 200, height: imageView.frame.size.height * 300 / imageView.frame.size.width)
            self.view.addSubview(imageView)
        }
    }

    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
        let dvc = UIStoryboard(name: "Diary", bundle: nil).instantiateViewController(withIdentifier: "DiaryDetailVC")

        self.navigationController!.pushViewController(dvc, animated: true)
    }
    
    @IBAction func completeBtnAction(_ sender: Any) {
        let dvc = UIStoryboard(name: "Diary", bundle: nil).instantiateViewController(withIdentifier: "DiaryListVC")
        
        self.navigationController!.pushViewController(dvc, animated: true)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            galleryBtn.frame = CGRect(x: galleryBtn.frame.origin.x, y: galleryBtn.frame.origin.y - keyboardSize.size.height, width: galleryBtn.frame.size.width, height: galleryBtn.frame.size.height)
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            galleryBtn.frame = CGRect(x: galleryBtn.frame.origin.x, y: galleryBtn.frame.origin.y + keyboardSize.size.height, width: galleryBtn.frame.size.width, height: galleryBtn.frame.size.height)
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
            textView.textColor = UIColor.Gray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        print(self.inputTextView.contentSize.height)
        
        inputTextViewHeightConstraint.constant = self.inputTextView.contentSize.height
//        let fixedWidth = textView.frame.size.width
//        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
//        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
//        var newFrame = textView.frame
//        print(newSize.height)
//        newFrame.size = CGSize(width: fixedWidth, height: newSize.height)
//        textView.frame = newFrame
//
        if imageView != nil && imageView.frame.origin.y != inputTextView.frame.maxY + 10 {
//            imageView.frame = CGRect(x: imageView.frame.origin.x, y: 247 + self.inputTextView.contentSize.height, width: imageView.frame.size.width, height: imageView.frame.size.height)
            // 위에거는 부드럷게 내려가는데 폭이 너무 큼.. 아래는 부드럽지 않은데 폭 유지.
            // 아무래도 같이 바뀌지않아서 텀때문에 부드럽지 않아 보이는 것 같음..
            imageView.frame = CGRect(x: imageView.frame.origin.x, y: inputTextView.frame.maxY + 5, width: imageView.frame.size.width, height: imageView.frame.size.height)
        }
    }
}

extension DiaryNewVC: MoodDelegate {
    
    func changeMood(img: String, text: String) {
        moodImgBtn.setImage(UIImage(named: img), for: .normal)
        moodTextBtn.setTitle(text, for: .normal)
        moodTextBtn.setTitleColor(UIColor.Gray, for: .normal)
    }
    
}

extension DiaryNewVC : UIImagePickerControllerDelegate,
UINavigationControllerDelegate{

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }

        if imageView != nil {
           imageView.image = nil
        }
        
        imageView = UIImageView(image: pickedImage)
        imageView.frame = CGRect(x: self.view.center.x - 100, y: inputTextView.frame.maxY + 5, width: 200, height: pickedImage.size.height * 300 / pickedImage.size.width)
        imageView.contentMode = .scaleAspectFit
        
        view.addSubview(imageView)
        
//        let verticalSpace = NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: inputTextView, attribute: .bottom, multiplier: 1, constant: 100)
//
//        NSLayoutConstraint.activate([verticalSpace])

        self.dismiss(animated: true, completion: nil)
    }
}
