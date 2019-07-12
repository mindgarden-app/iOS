//
//  SettingsPopUpVC.swift
//  MindGarden
//
//  Created by Sunghee Lee on 03/07/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit
import DLRadioButton

protocol FontSizeDelegate: class {
    func changeFontSizeText()
}

class SettingsPopUpVC: UIViewController {

    @IBOutlet var popUpView: UIView!
    @IBOutlet var fontSizeBtn1: DLRadioButton!
    @IBOutlet var fontSizeBtn2: DLRadioButton!
    @IBOutlet var fontSizeBtn3: DLRadioButton!
    @IBOutlet var fontSizeBtn4: DLRadioButton!
    @IBOutlet var fontSizeBtn5: DLRadioButton!

    var delegate: FontSizeDelegate? = nil
    var radioBtnValue: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBtnSelected()
        
        popUpView.makeRounded(cornerRadius: 15)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first?.view?.tag != 100 {
            removePopUp()
            super.touchesEnded(touches , with: event)
        }
    }
    
    func setBtnSelected() {
        var fontSizeBtnArr: [DLRadioButton] = [fontSizeBtn1, fontSizeBtn2, fontSizeBtn3, fontSizeBtn4, fontSizeBtn5]
        
        let defaultFontSize = UserDefaults.standard.integer(forKey: "fontSize") ?? 3
        
        fontSizeBtnArr[defaultFontSize].isSelected = true
    }
    
    @IBAction func fontBtnAction(_ sender: DLRadioButton) {
        UserDefaults.standard.set(sender.tag, forKey: "fontSize")
        delegate?.changeFontSizeText()
        UIView.animate(withDuration: 0.2, animations: {self.view.alpha = 0.0},
                       completion: {(value: Bool) in
                        self.view.removeFromSuperview()
        })
    }
    
    @objc func removePopUp() {
        UIView.animate(withDuration: 0.2, animations: {self.view.alpha = 0.0},
                       completion: {(value: Bool) in
                        self.view.removeFromSuperview()
        })
    }
}
