//
//  MainGridVC.swift
//  MindGarden
//
//  Created by Sunghee Lee on 07/07/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit

class MainGridVC: UIViewController {
    
    @IBOutlet var gardenGridCV: UICollectionView!
    @IBOutlet var treeInventoryCV: UICollectionView!
    @IBOutlet var gridCV: UICollectionView!
    @IBOutlet var inventoryBackgroundView: UIView!
    @IBOutlet var waterView: UIView!
    
    let gardenGridNum = 6 * 6
    let gardenGridCellSize = 51
    let treeInventoryCellSize = 55
    let gardenGridSpacing: CGFloat = 7
    let treeInventorySpacing: CGFloat = 8
    let userIdx = UserDefaults.standard.integer(forKey: "userIdx")
    
    var date: String!
    var selectedTree: Int? = nil
    var selectedGrid: Int? = nil
    var treeList: [Tree]!
    var treeDict: Dictionary = [Int: Tree]()
    
    let gridIdxArr: [Int] = [1, 3, 6, 10, 14, 18, 2, 5, 9, 13, 17, 22, 4, 8, 0, 0, 21, 26, 7, 12, 0, 0, 25, 29, 11, 16, 20, 24, 28, 31, 15, 19, 23, 27, 30, 32]
    let gridInverseIdxArr: [Int] = [0, 6, 1, 12, 7, 2, 18, 13, 8, 3, 24, 19, 9, 4, 30, 25, 10, 5, 31, 26, 16, 11, 32, 27, 22, 17, 33, 28, 23, 34, 29, 35]
    
    let treeImageArr: [String] = ["ios_tree1", "ios_tree2", "ios_tree3", "ios_tree4", "ios_tree5", "ios_tree6", "ios_tree7", "ios_tree8", "ios_tree9", "ios_tree10", "ios_tree11", "ios_tree12", "ios_tree13", "ios_tree14", "ios_tree15", "ios_tree16"]
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        getGardenData()
        setWaterview()
        setInventoryBackgroundView()
        
        registerCVC()
        gardenGridCV.delegate = self
        gardenGridCV.dataSource = self
        treeInventoryCV.delegate = self
        treeInventoryCV.dataSource = self
        
        treeInventoryCV.allowsMultipleSelection = false
        gardenGridCV.allowsMultipleSelection = false
    }
    
    func getGardenData() {
        GardenService.shared.getGarden(userIdx: userIdx, date: date) {
            [weak self]
            data in
            
            guard let `self` = self else { return }
            
            switch data {
            case .success(let res):
                self.treeList = res as! [Tree]
                self.treeDict = Dictionary(uniqueKeysWithValues: self.treeList.map { ($0.location, $0) })

                self.gardenGridCV.reloadData()
                
                break
            case .requestErr(let err):
                print(".requestErr(\(err))")
                break
            case .pathErr:
                print("경로 에러")
                break
            case .serverErr:
                print("서버 에러")
                break
            case .networkFail:
                self.simpleAlert(title: "통신 실패", message: "네트워크 상태를 확인하세요.")
                break
            }
        }
    }
    
    func setTree() {
        for tree in treeList {
            let indexPath = IndexPath(row: gridInverseIdxArr[tree.location], section: 0)
            let cell = gardenGridCV.dequeueReusableCell(withReuseIdentifier: "TreeCVC", for: indexPath) as! TreeCVC
            
            cell.treeImageView.image = UIImage(named: "ios_tree\(tree.treeIdx)")
        }
    }

    func registerCVC() {
        let nibName = UINib(nibName: "TreeCVC", bundle: nil)
        gardenGridCV.register(nibName, forCellWithReuseIdentifier: "TreeCVC")
        treeInventoryCV.register(nibName, forCellWithReuseIdentifier: "TreeCVC")
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.pop()
    }
    
    func setWaterview() {
        waterView.makeRounded(cornerRadius: 4)
    }
    
    func setInventoryBackgroundView() {
        inventoryBackgroundView.setBorder(borderColor: UIColor.whiteForMainBorder, borderWidth: 0.3)
        inventoryBackgroundView.dropShadow(color: UIColor(red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0, alpha: 0.4), offSet: CGSize(width: 0, height: -1), opacity: 0.4, radius: 3)
    }
    
    @IBAction func addBtnAction(_ sender: Any) {
        if selectedTree == nil {
            self.simpleAlert(title: "Oops!", message: "나무를 선택해주세요")
            return
        } else if selectedGrid == nil {
            self.simpleAlert(title: "Oops!", message: "위치를 선택해주세요")
            return
        }
        
        let location = gridIdxArr[selectedGrid!]
        
        GardenService.shared.addTree(userIdx: userIdx, location: location, treeIdx: selectedTree!) {
            data in
            
            switch data {
            case .success(let message):
                let messageStr = String(describing: message)
                if messageStr == "일기를 써야 심을 수 있어요!" {
                    self.simpleAlertWithPop(title: "Oops!", message: messageStr)
                } else if messageStr == "이미 심으셨습니다!" {
                    self.simpleAlertWithPop(title: "Oops!", message: messageStr)
                } else {
                    self.simpleAlertWithPop(title: "성공!", message: "오늘의 나무를 심으셨습니다.")
                }
                break
            case .requestErr:
                break
            case .pathErr:
                print("경로 에러")
                break
            case .serverErr:
                print("서버 에러")
                break
            case .networkFail:
                self.simpleAlert(title: "통신 실패", message: "네트워크 상태를 확인하세요.")
                break
            }
        }
    }
}


extension MainGridVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.gardenGridCV {
            return gardenGridNum
        } else {
            return treeImageArr.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TreeCVC", for: indexPath) as! TreeCVC
        
        if collectionView == self.gardenGridCV {
            cell.makeRounded(cornerRadius: 4)
            cell.setBorder(borderColor: UIColor.lightGreen, borderWidth: 2.2)

            if treeDict.keys.contains(gridIdxArr[indexPath.row]) {
                let treeIdx: Int = treeDict[gridIdxArr[indexPath.row]]!.treeIdx
                cell.treeImageView.image = UIImage(named: treeIdx == 16 ? "ios_weeds" : "ios_tree\(treeIdx + 1)")
                cell.backgroundColor = UIColor.white
            } else if selectedGrid == indexPath.row {
                cell.backgroundColor = UIColor.lightGreenForGrid
                cell.treeImageView.image = UIImage(named: treeImageArr[selectedTree!])
            } else {
                cell.backgroundColor = UIColor.white
                cell.treeImageView.image = nil
            }
            
        } else {
            cell.treeImageView.image = UIImage(named: treeImageArr[indexPath.row])
            cell.backgroundColor = UIColor.whiteForBorder
            cell.makeRounded(cornerRadius: 4)
            
            if selectedTree == indexPath.row {
                cell.setBorder(borderColor: UIColor.lightGreen, borderWidth: 2.2)
            } else {
                cell.layer.borderColor = UIColor.clear.cgColor
            }
        }
        
        return cell
    }
}

extension MainGridVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.gardenGridCV {
            if selectedTree != nil {
                if treeDict.keys.contains(gridIdxArr[indexPath.row]) {
                    print("...???")
                    return }
                selectedGrid = indexPath.row
                
                collectionView.reloadData()
            } else {
                self.simpleAlert(title: "잠깐!", message: "나무를 먼저 선택해주세요")
            }
        } else {
            self.selectedTree = indexPath.row
            self.selectedGrid = nil
            
            collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == self.gardenGridCV {
            self.selectedGrid = nil
        } else {
            self.selectedTree = nil
        }
    }
}

extension MainGridVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat!
        let height: CGFloat!
        
        if collectionView == self.gardenGridCV {
            width = CGFloat(gardenGridCellSize)
            height = CGFloat(gardenGridCellSize)
        } else {
            width = CGFloat(treeInventoryCellSize)
            height = CGFloat(treeInventoryCellSize)
        }
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView == self.gardenGridCV {
            return gardenGridSpacing
        } else {
            return treeInventorySpacing
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView == self.gardenGridCV {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        } else {
            return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        }
    }
}

extension MainGridVC : UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if (self.navigationController?.viewControllers.count)! > 1 {
            return true
        }
        
        return false
    }
}
