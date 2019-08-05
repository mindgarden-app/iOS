//
//  ResetPw2VC.swift
//  MindGarden
//
//  Created by Sunghee Lee on 06/08/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit

class ResetPw2VC: UIViewController {

    @IBOutlet var descLabel: UILabel!
    @IBOutlet var sendEmailBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setView()
    }
    
    func setView() {
        let formattedString = NSMutableAttributedString()
        formattedString
            .bold("이메일 전송 완료")
            .normal("\n메일에 안내된 내용에 따라 새 비밀번호를 설정하세요.")
        
        descLabel.attributedText = formattedString
    }
    

    @IBAction func sendEmailBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popToViewController((navigationController?.viewControllers[(navigationController?.viewControllers.count)! - 3])!, animated: true)
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
