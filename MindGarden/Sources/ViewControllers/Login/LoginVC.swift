//
//  LoginVC.swift
//  MindGarden
//
//  Created by Sunghee Lee on 02/07/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit
import WebKit

enum AuthType: String {
    case kakao = "http://13.125.190.74:3000/auth/login/kakao"
}

class LoginVC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var descriptionSV: UIScrollView! {
        didSet {
            descriptionSV.delegate = self
        }
    }
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var loginBtn: UIButton!
    var webView: WKWebView!
    var authType: AuthType!
    
    let decoder = JSONDecoder()
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
        authType = .kakao
        
        let url = NSURL(string: authType.rawValue)
        let request = NSURLRequest(url: url! as URL)
        
        webView = WKWebView(frame: self.view.frame)
        webView.navigationDelegate = self
        webView.load(request as URLRequest)
        self.view.addSubview(webView)
    }
    
    @IBAction func unwindToLogin(_ unwindSegue : UIStoryboardSegue) {}
}

extension LoginVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let url = webView.url?.absoluteString {
            if url == "http://13.125.190.74:3000/auth/login/success" {
                webView.evaluateJavaScript("document.body.innerText", completionHandler: { (data, error) in
                    let dataStr = data as! String
                    if let result = dataStr.data(using: .utf8) {
                        if self.authType == .kakao {
                            do {
                                let kakao = try JSONDecoder().decode(Login.self, from: result)
                                UserDefaults.standard.set(kakao.data.userIdx, forKey: "userIdx")
                            } catch {
                                print(error)
                            }
                        }
                    }
                })
                webView.removeFromSuperview()
                
                let dvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainVC")
                
                self.navigationController!.pushViewController(dvc, animated: true)
                
            } else if url == "http://13.125.190.74:3000/auth/login/fail" {
                self.simpleAlert(title: "Oops!", message: "로그인을 다시 시도해주세요")
                webView.removeFromSuperview()
            }
        }
    }
    
}
