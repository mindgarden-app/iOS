//
//  UIViewController+Extensions.swift
//  MindGarden
//
//  Created by Sunghee Lee on 05/07/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func simpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    func simpleAlertWithPop(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "확인", style: .default) { (action: UIAlertAction!) -> Void in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(OKAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func simpleAlertwithHandler(title: String, message: String, okHandler : ((UIAlertAction) -> Void)?, cancleHandler : ((UIAlertAction) -> Void)?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인",style: .default, handler: okHandler)
        let cancelAction = UIAlertAction(title: "취소",style: .cancel, handler: cancleHandler)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func setBackBtn(color : UIColor){
        let backBTN = UIBarButtonItem(image: UIImage(named: "backBtn"),
                                      style: .plain,
                                      target: self,
                                      action: #selector(self.pop))
        navigationItem.leftBarButtonItem = backBTN
        navigationItem.leftBarButtonItem?.tintColor = color
        navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
    }
    
    @objc func pop(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func setNavigationBarItem(image: String, target: AnyObject, action: Selector, direction: String) {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: image), for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        let barButton = UIBarButtonItem(customView: button)
        if direction == "left" {
            self.navigationItem.leftBarButtonItem = barButton
        } else {
            self.navigationItem.rightBarButtonItem = barButton
        }
    }
}
