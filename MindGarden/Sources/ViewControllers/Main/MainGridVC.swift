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
    
    let gardenGridNum = 6 * 6
    let gardenGridCellSize = 51
    let treeInventoryCellSize = 55
    let gardenGridSpacing: CGFloat = 5
    let treeInventorySpacing: CGFloat = 8
    
    let treeImageArr: [String] = ["ios_tree1", "ios_tree2", "ios_tree3", "ios_tree4", "ios_tree5", "ios_tree6", "ios_tree7", "ios_tree8", "ios_tree9", "ios_tree10", "ios_tree11", "ios_tree11", "ios_tree12", "ios_tree13", "ios_tree14", "ios_tree15", "ios_tree16"]

    override func viewDidLoad() {
        super.viewDidLoad()

        registerCVC()
        gardenGridCV.delegate = self
        gardenGridCV.dataSource = self
        treeInventoryCV.delegate = self
        treeInventoryCV.dataSource = self
    }

    func registerCVC() {
        let nibName = UINib(nibName: "TreeCVC", bundle: nil)
        gardenGridCV.register(nibName, forCellWithReuseIdentifier: "TreeCVC")
        treeInventoryCV.register(nibName, forCellWithReuseIdentifier: "TreeCVC")
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setInventoryBackgroundView() {
        inventoryBackgroundView.setBorder(borderColor: UIColor.whiteForMainBorder, borderWidth: 0.3)
        inventoryBackgroundView.dropShadow(color: UIColor(red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0, alpha: 0.04), offSet: CGSize(width: 0, height: -1), opacity: 0.4, radius: 3)
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
        } else {
            cell.treeImageView.image = UIImage(named: treeImageArr[indexPath.row])
            cell.backgroundColor = UIColor.whiteForBorder
            cell.makeRounded(cornerRadius: 4)
            
            if cell.isSelected {
                
            } else {
                
            }
        }
        return cell
    }
}

extension MainGridVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        
        if collectionView == self.gardenGridCV {
            
        } else {
            cell?.setBorder(borderColor: UIColor.lightGreen, borderWidth: 2.2)
            cell?.isSelected = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        
        if collectionView == self.gardenGridCV {
            
        } else {
            cell?.layer.borderColor = UIColor.clear.cgColor
            cell?.layer.borderWidth = 1
            cell?.isSelected = false
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

