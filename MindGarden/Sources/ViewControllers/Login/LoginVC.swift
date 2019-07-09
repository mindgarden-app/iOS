//
//  LoginVC.swift
//  MindGarden
//
//  Created by Sunghee Lee on 02/07/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var descriptionSV: UIScrollView! {
        didSet {
            descriptionSV.delegate = self
        }
    }
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var tmpMainBtn: UIButton!
    @IBOutlet var tmpWriteBtn: UIButton!
    
    var slides: [DescriptionSlide] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        
        slides = createSlides()
        setupSlideScrollView(slides: slides)

        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)
    }
    
    func createSlides() -> [DescriptionSlide] {
        let slide1: DescriptionSlide = Bundle.main.loadNibNamed("DescriptionSlide", owner: self, options: nil)?.first as! DescriptionSlide
        slide1.logoImage.image = UIImage(named: "imgLogIn1")
        
        let slide2: DescriptionSlide = Bundle.main.loadNibNamed("DescriptionSlide", owner: self, options: nil)?.first as! DescriptionSlide
        slide2.logoImage.image = UIImage(named: "imgLogIn2")
        
        let slide3: DescriptionSlide = Bundle.main.loadNibNamed("DescriptionSlide", owner: self, options: nil)?.first as! DescriptionSlide
        slide3.logoImage.image = UIImage(named: "imgLogIn3")
        
        let slide4: DescriptionSlide = Bundle.main.loadNibNamed("DescriptionSlide", owner: self, options: nil)?.first as! DescriptionSlide
        slide4.logoImage.image = UIImage(named: "imgLogIn1")
        
        return [slide1, slide2, slide3, slide4]
    }
    
    func setupSlideScrollView(slides : [DescriptionSlide]) {
        descriptionSV.contentSize = CGSize(width: 301 * CGFloat(slides.count), height: 208)
        descriptionSV.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: 301 * CGFloat(i), y: 0, width: 301, height: 208)
            descriptionSV.addSubview(slides[i])
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(descriptionSV.contentOffset.x/301)
        pageControl.currentPage = Int(pageIndex)
    }

    @IBAction func loginBtnAction(_ sender: Any) {
        
//        LoginService.shared.login() {
//            data in
//
//            switch data {
//            case .success(let token):
//                UserDefaults.standard.set(token, forKey: "token")
        
                if UserDefaults.standard.bool(forKey: "암호 설정") {
                    let dvc = UIStoryboard(name: "Lock", bundle: nil).instantiateViewController(withIdentifier: "LockVC") as! LockVC
                    
                    dvc.mode = LockMode.validate
                    
                    self.navigationController!.pushViewController(dvc, animated: true)
                } else {
                    let dvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainVC")
                    
                    self.navigationController!.pushViewController(dvc, animated: true)
                }
                
//                break
//            case .requestErr(let err):
//                self.simpleAlert(title: "로그인 실패", message: err as! String)
//                break
//            case .pathErr:
//                print("경로 에러")
//                break
//            case .serverErr:
//                print("서버 에러")
//                break
//            case .networkFail:
//                self.simpleAlert(title: "통신 실패", message: "네트워크 상태를 확인하세요.")
//                break
//            }
//        }
    }
    
    @IBAction func unwindToLogin(_ unwindSegue : UIStoryboardSegue) {}
}
