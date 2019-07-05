//
//  WriteViewController.swift
//  MindGarden
//
//  Created by Sunghee Lee on 30/06/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit

class DiaryNewVC: UIViewController {

    @IBOutlet var backBtn: UIBarButtonItem!
    @IBOutlet var moodTextBtn: UIButton!
    @IBOutlet var moodImgBtn: UIButton!
    @IBOutlet var inputTextView: UITextView!
    @IBOutlet var inputImageView: UIImageView!
    
    let picker = UIImagePickerController()
    var placeholder = "내용"
    var moodText: String = ""
    var moodImg: String = ""
    var body: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBar()
        
        picker.delegate = self
        
        setTextView()
        inputTextView.delegate = self
        
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
        
//        let rightBtn = UIBarButtonItem(image: UIImage(named: "btnRegister"), style: .plain, target: self, action: Selector(""))
//        self.navigationItem.rightBarButtonItem = rightBtn
    }
    
    func setTextView() {
        inputTextView.text = placeholder
        inputTextView.textColor = UIColor.lightGray
    }
    
//    func setImageView() {
//        let imageView = UIImageView(image: image!)
//    }

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
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print("notification: Keyboard will show")
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            }
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
}

extension DiaryNewVC: MoodDelegate {
    
    func changeMood(img: String, text: String) {
        print(img)
        print(text)
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

//        inputImageView.frame.size = CGSize(width: 100, height: 100)
        inputImageView.image = pickedImage
        inputImageView.frame = CGRect(x: 0, y: 0, width: 50, height: UIScreen.main.bounds.height * 0.2)

        self.dismiss(animated: true, completion: nil)
    }
}
