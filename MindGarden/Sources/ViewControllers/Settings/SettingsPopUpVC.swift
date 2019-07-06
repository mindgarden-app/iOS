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
    
    var delegate: FontSizeDelegate? = nil

    @IBOutlet var popUpView: UIView!
    @IBOutlet var fontSizeBtn1: DLRadioButton!
    @IBOutlet var fontSizeBtn2: DLRadioButton!
    @IBOutlet var fontSizeBtn3: DLRadioButton!
    @IBOutlet var fontSizeBtn4: DLRadioButton!
    @IBOutlet var fontSizeBtn5: DLRadioButton!

    var radioBtnValue: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBtnSelected()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        popUpView.makeRounded(cornerRadius: 15)
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
}
