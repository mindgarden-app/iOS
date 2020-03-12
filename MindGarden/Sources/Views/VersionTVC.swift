//
//  VersionTVC.swift
//  MindGarden
//
//  Created by Sunghee Lee on 2020/03/11.
//  Copyright © 2020 Sunghee Lee. All rights reserved.
//

import UIKit

class VersionTVC: UITableViewCell {
    
    @IBOutlet var versionNumberLabel: UILabel!
    @IBOutlet var versionAlertLabel: UILabel!
    let newVersionString = "현재 최신 버전 사용 중입니다."
    let oldVersionString = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        initView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // only old version
//        openAppStore()
    }
    
    func initView() {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            versionNumberLabel.text = "V \(version)"
            
            if(checkLatestVersion()) {
                versionAlertLabel.text = oldVersionString
            } else {
                versionAlertLabel.text = newVersionString
            }
        }
    }
    
    func checkLatestVersion() -> Bool {
        guard
            let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
            let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(AppConstants.BundleId)"),
            let data = try? Data(contentsOf: url),
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
            let results = json["results"] as? [[String: Any]],
            results.count > 0,
            let appStoreVersion = results[0]["version"] as? String
            else { return false }
        if !(version >= appStoreVersion) { return true }
        else{ return false }
    }
    
    func openAppStore() {
        if let url = URL(string: "itms-apps://itunes.apple.com/app/apple-store/id\(AppConstants.AppId)?mt=8"),
            UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url, options: [:]) { (opened) in
                if(opened){
                    print("App Store Opened")
                }
            }
        } else {
            print("Can't Open URL on Simulator")
        }
    }
}
