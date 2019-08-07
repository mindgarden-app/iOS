//
//  SignupPopUpVC.swift
//  MindGarden
//
//  Created by Sunghee Lee on 06/08/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit

class SignupPopUpVC: UIViewController {

    @IBOutlet var popUpView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setView()
    }
    
    func setView() {
        popUpView.makeRounded(cornerRadius: 8)
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
