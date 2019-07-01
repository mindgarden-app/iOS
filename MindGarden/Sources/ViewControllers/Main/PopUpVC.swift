//
//  PopUpViewController.swift
//  MindGarden
//
//  Created by Sunghee Lee on 01/07/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit

protocol sendDataToViewProtocol {
    func inputData(data:String)
}

class PopUpVC: UIViewController {
    
    var delegate:sendDataToViewProtocol? = nil
    private var year: Int = 0;

    @IBOutlet var popUpView: UIView!
    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var leftBtn: UIButton!
    @IBOutlet var rightBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setYearLabel(year: year)

        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        popUpView.setBorder(borderColor: UIColor.gray, borderWidth: 1.0)
        popUpView.makeRounded(cornerRadius: 15)
        popUpView.dropShadow(color: UIColor.gray, offSet: CGSize(width: 0.0, height: 3.0), opacity: 0.52, radius: 3)
    }
    
    func setYearLabel(year: Int) {
        if year != 0 {
            yearLabel.text = String(year)
        } else {
            let calendar = Calendar.current
            let defaultYear = calendar.component(.year, from: Date())
            self.year = defaultYear
            yearLabel.text = String(defaultYear)
        }
    }
    
    @IBAction func leftBtnAction(_ sender: Any) {
        year -= 1
        setYearLabel(year: year)
    }
    
    
    @IBAction func rightBtnAction(_ sender: Any) {
        year += 1
        setYearLabel(year: year)
    }
    
    @IBAction func numBtnAction(_ sender: Any) {
        if(delegate != nil){
            delegate?.inputData(data: yearLabel.text!)
            self.view.removeFromSuperview()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
