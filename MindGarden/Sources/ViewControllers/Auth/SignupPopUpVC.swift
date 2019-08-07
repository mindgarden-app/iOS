//
//  SignupPopUpVC.swift
//  MindGarden
//
//  Created by Sunghee Lee on 06/08/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit

class SignupPopUpVC: UIViewController {

    @IBOutlet var backgroundView: UIView!
    @IBOutlet var popUpView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setView()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    }
    
    func setView() {
        popUpView.makeRounded(cornerRadius: 8)
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
