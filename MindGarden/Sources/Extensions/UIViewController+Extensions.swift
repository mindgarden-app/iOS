//
//  UIViewController+Extensions.swift
//  MindGarden
//
//  Created by Sunghee Lee on 05/07/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit

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
        let okAction = UIAlertAction(title: "확인",style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
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
    
    func setNavigationBarClear() {
        let bar: UINavigationBar! = self.navigationController?.navigationBar
        
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        bar.backgroundColor = UIColor.clear
    }
    
    func setNavigationBarShadow() {
        let bar: UINavigationBar! = self.navigationController?.navigationBar
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.backgroundColor = UIColor.white
    }
    
    func gsno(_ value: String?) -> String{
        guard let value_ = value else {
            return ""
        }
        return value_
    }//func gsno
    
    func gino(_ value: Int?) -> Int{
        guard let value_ = value else {
            return 0
        }
        return value_
    }//func gino
    
    func gbno(_ value: Bool?) -> Bool{
        guard let value_ = value else {
            return false
        }
        return value_
    }//func gbno
    
    func gfno(_ value: Float?) -> Float{
        guard let value_ = value else{
            return 0
        }
        return value_
    }//func gfno
    
}
