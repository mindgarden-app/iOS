//
//  DiaryPopUpVC.swift
//  MindGarden
//
//  Created by Sunghee Lee on 01/07/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit

//protocol sendDataToViewProtocol {
//    func inputData(data:String)
//}

class DiaryPopUpVC: UIViewController {

    @IBOutlet var popUpView: UIView!
    @IBOutlet var moodTV: UITableView!
    
    var delegate:sendDataToViewProtocol? = nil
    
    var testArr: [String] = ["좋음", "별로", "보통", "아주 좋음", "그냥", "자고 싶음", "배고픔"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerTVC()
        moodTV.delegate = self
        moodTV.dataSource = self
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        popUpView.setBorder(borderColor: UIColor.gray, borderWidth: 1.0)
        popUpView.makeRounded(cornerRadius: 15)
        popUpView.dropShadow(color: UIColor.gray, offSet: CGSize(width: 0.0, height: 3.0), opacity: 0.52, radius: 3)
        // Do any additional setup after loading the view.
    }
    
    func registerTVC() {
        let nibName = UINib(nibName: "DiaryPopUpTVC", bundle: nil)
        moodTV.register(nibName, forCellReuseIdentifier: "DiaryPopUpTVC")
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

extension DiaryPopUpVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return testArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = moodTV.dequeueReusableCell(withIdentifier: "DiaryPopUpTVC") as! DiaryPopUpTVC
        
        let moodText = testArr[indexPath.row]
        
//        cell.moodImage =
        cell.moodLabel.text = moodText
        
        return cell
    }
}

extension DiaryPopUpVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(delegate != nil){
            let moodText = testArr[indexPath.row]
            delegate?.inputData(data: moodText)
            self.view.removeFromSuperview()
        }
        
//        let dvc = storyboard?.instantiateViewController(withIdentifier: "DiaryDetailVC") as! DiaryDetailVC
//
//        //        let episode = episodeList[indexPath.row]
//        //        dvc.epIdx = episode.idx
//
//        navigationController?.pushViewController(dvc, animated: true)
    }
}

