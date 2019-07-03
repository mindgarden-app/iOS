//
//  DatePickerTVC.swift
//  MindGarden
//
//  Created by Sunghee Lee on 04/07/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit

protocol DatePickerDelegate: class {
    func didChangeDate(date: Date, indexPath: IndexPath)
}

class DatePickerTVC: UITableViewCell {

    @IBOutlet var datePicker: UIDatePicker!
    
    var indexPath: IndexPath!
    weak var delegate: DatePickerDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func initView() {
        datePicker.addTarget(self, action: #selector(changeDate), for: .valueChanged)
    }
    
    func updateCell(date: Date, indexPath: IndexPath) {
        datePicker.setDate(date, animated: true)
        self.indexPath = indexPath
    }
    
    @objc func changeDate(_ sender: UIDatePicker) {
        let indexPathForDisplayDate = IndexPath(row: indexPath.row - 1, section: indexPath.section)
        delegate?.didChangeDate(date: sender.date, indexPath: indexPathForDisplayDate)
    }
    
}
