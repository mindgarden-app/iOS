//
//  PopUpViewController.swift
//  MindGarden
//
//  Created by Sunghee Lee on 01/07/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit

protocol DateDelegate {
    func changeDate(year: Int, month: Int)
}

class PopUpVC: UIViewController {
    
    var delegate:DateDelegate? = nil
    var year: Int = 0;
    private var currentYear: Int!
    private var month: Int = 0;

    @IBOutlet var backgroundView: UIView!
    @IBOutlet var popUpView: UIView!
    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var leftBtn: UIButton!
    @IBOutlet var rightBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBackgroundViewAction()
        setYearLabel(year: year)
        setBtn()

        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        popUpView.setBorder(borderColor: UIColor.gray, borderWidth: 1.0)
        popUpView.makeRounded(cornerRadius: 15)
        popUpView.dropShadow(color: UIColor.gray, offSet: CGSize(width: 0.0, height: 3.0), opacity: 0.52, radius: 3)
    }
    
    func addBackgroundViewAction() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(removePopUp))
        self.backgroundView.addGestureRecognizer(gesture)
    }
    
    func setYearLabel(year: Int) {
        let calendar = Calendar.current
        let defaultYear = calendar.component(.year, from: Date())
        self.currentYear = defaultYear
        
        if year != 0 {
            self.year = year
            yearLabel.text = String(year)
        } else {
            self.year = defaultYear
            yearLabel.text = String(defaultYear)
        }
    }
    
    func setBtn() {
        if year == currentYear - 5 {
            leftBtn.isHidden = true
        }
        
        if year == currentYear + 5 {
            rightBtn.isHidden = true
        }
    }
    
    @IBAction func leftBtnAction(_ sender: Any) {
        if year - 1 >= currentYear - 5 {
            leftBtn.isHidden = false
            rightBtn.isHidden = false
            year -= 1
            setYearLabel(year: year)
            
            if year == currentYear - 5 {
                leftBtn.isHidden = true
            }
        }
    }
    
    
    @IBAction func rightBtnAction(_ sender: Any) {
        if year + 1 <= currentYear + 5 {
            leftBtn.isHidden = false
            rightBtn.isHidden = false
            year += 1
            setYearLabel(year: year)
            
            if year == currentYear + 5 {
                rightBtn.isHidden = true
            }
        }
    }
    
    @IBAction func numBtnAction(_ sender: UIButton) {
        sender.backgroundColor = UIColor.lightGreenForButton
        sender.makeRounded(cornerRadius: 20)
        if(delegate != nil){
            month = sender.tag
            delegate?.changeDate(year: year, month: month)
            removePopUp()
//            UIView.animate(withDuration: 0.2, animations: {self.view.alpha = 0.0},
//                           completion: {(value: Bool) in
//                            self.view.removeFromSuperview()
//            })
        }
    }
    
    @objc func removePopUp() {
        UIView.animate(withDuration: 0.2, animations: {self.view.alpha = 0.0},
                       completion: {(value: Bool) in
                        self.view.removeFromSuperview()
        })
    }
}
