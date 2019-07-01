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

    @IBOutlet var popUpView: UIView!
    @IBOutlet var yearLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        popUpView.setBorder(borderColor: UIColor.gray, borderWidth: 1.0)
        popUpView.makeRounded(cornerRadius: 15)
        popUpView.dropShadow(color: UIColor.gray, offSet: CGSize(width: 0.0, height: 3.0), opacity: 0.52, radius: 3)
//        self.view.setBorder(borderColor: UIColor.gray, borderWidth: 1.0)
//        self.view.makeRounded(cornerRadius: nil)
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
