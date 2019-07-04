//
//  LockVC.swift
//  MindGarden
//
//  Created by Sunghee Lee on 03/07/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit

public enum Mode {
    case validate
    case change
    case create
}

class LockVC: UIViewController {
    
    @IBOutlet var passcodeCV: UICollectionView!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var passcodeResetBtn: UIButton!
    @IBOutlet var passcodeImg1: UIImageView!
    @IBOutlet var passcodeImg2: UIImageView!
    @IBOutlet var passcodeImg3: UIImageView!
    @IBOutlet var passcodeImg4: UIImageView!
    
    var mode: Mode = .create
//    fileprivate var mode: Mode {
//        didSet {
//            let mode = self.mode ?? validate
//        }
//    }
    
    var codeArr: [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "", "0", "<"]
    var inputNumber: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDescriptionLabel()
//        setPasscodeView()
        
        registerCVC()
        passcodeCV.delegate = self
        passcodeCV.dataSource = self
    }
    
    func setDescriptionLabel() {
        switch mode {
        case .create:
            descriptionLabel.text = "비밀번호를 입력해주세요."
        case .change:
            print("sfasdf")
        case .validate:
            descriptionLabel.text = "비밀번호를 입력해주세요."
            passcodeResetBtn.setTitle("비밀번호를 잊어버리셨나요?", for: .normal)
        }
        descriptionLabel.textAlignment = .center
        descriptionLabel.frame = CGRect(x: 0, y: 0, width: descriptionLabel.intrinsicContentSize.width, height: descriptionLabel.intrinsicContentSize.width)
    }
    
    func changePasscodeImg(count: Int) {
        let passcodeImgArr: [UIImageView] = [passcodeImg1, passcodeImg2, passcodeImg3, passcodeImg4]
        
        for i in 0...passcodeImgArr.count - 1 {
            if i < count {
                passcodeImgArr[i].image = UIImage(named: "imgPasswordOn")
            } else {
                passcodeImgArr[i].image = UIImage(named: "imgPasswordOff")
            }
        }
    }
    
    func registerCVC() {
        let nibName = UINib(nibName: "LockCodeCVC", bundle: nil)
        passcodeCV.register(nibName, forCellWithReuseIdentifier: "LockCodeCVC")
    }
}


extension LockVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return codeArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LockCodeCVC", for: indexPath) as! LockCodeCVC
        
        cell.codeLabel.text = codeArr[indexPath.row]
        
        return cell
    }
}

extension LockVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (0 <= indexPath.row && indexPath.row < 9) || indexPath.row == 10 {
//            let cell = passcodeCV.cellForItem(at: indexPath)
//            let cell = passcodeCV.(indexPath)
//            cell.codeLabel.backgroundColor = UIColor.lightGray
//            cell?.contentView.backgroundColor = UIColor
//            cell.codeLabel.backgroundColor = UIColor.lightGray
            
            inputNumber += codeArr[indexPath.row]
            print(inputNumber)
            
            changePasscodeImg(count: inputNumber.count)
            
            if inputNumber.count == 4 {
                if mode == .validate {
                    if(UserDefaults.standard.integer(forKey: "passcode") == Int(inputNumber)) {
                        let dvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainVC")
                        
                        self.navigationController!.pushViewController(dvc, animated: true)
                    }
                    inputNumber = ""
                    changePasscodeImg(count: 0)
                    print("here!!")
                } else if mode == .create {
                    UserDefaults.standard.set(inputNumber, forKey: "passcode")
                    inputNumber = ""
                    changePasscodeImg(count: 0)
                } else if mode == .change {
                    
                }
            }
            
        } else if indexPath.row == 11 {
            inputNumber = String(inputNumber.dropLast())
            print(inputNumber)
            
            changePasscodeImg(count: inputNumber.count)
        }
    }
}

extension LockVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = (passcodeCV.bounds.width) / 3
        let height: CGFloat = (passcodeCV.bounds.height) / 4
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
