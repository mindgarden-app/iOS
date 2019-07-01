//
//  ListViewController.swift
//  MindGarden
//
//  Created by Sunghee Lee on 01/07/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet var diaryListTV: UITableView!
    //    private var diaryListTV: UITableView!
    private let testArr: NSArray = ["First", "Second", "Third"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        addTableView()
        setNavigationBar()
        
        let nibName = UINib(nibName: "diaryListCell", bundle: nil)
        diaryListTV.register(nibName, forCellReuseIdentifier: "diaryListCell")
        
    }
    
    func setNavigationBar() {
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "yyyy년 M월"
        let dateStr = dateFormatter.string(from: today)
        
        self.navigationItem.title = dateStr
    }
    
    func addTableView() {
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeihgt: CGFloat = self.view.frame.height
        
        diaryListTV = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeihgt - barHeight))
        diaryListTV.register(UITableViewCell.self, forCellReuseIdentifier: "diaryListCell")
        diaryListTV.dataSource = self
        diaryListTV.delegate = self
        self.view.addSubview(diaryListTV)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        print("Value: \(testArr[indexPath.row])")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTVC", for: indexPath as IndexPath)
//        cell.textLabel!.text = "\(testArr[indexPath.row])"
        
        cell.dateLabel.text = "16"
        cell.dayOfWeekLabel.text = "수"
        cell.titleLabel.text = "여기에 본문이 들어감 여기에 본문이 들어감 여기에 본문이 들어감"
        
        return cell
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
