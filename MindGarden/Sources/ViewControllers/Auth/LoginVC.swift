//
//  LoginVC.swift
//  MindGarden
//
//  Created by Sunghee Lee on 02/07/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit
import WebKit
import NVActivityIndicatorView

enum AuthType: String {
    case kakao = "http://13.125.190.74:3000/auth/login/kakao"
}

class LoginVC: UIViewController, UIScrollViewDelegate, NVActivityIndicatorViewable {
    
    @IBOutlet var descriptionSV: UIScrollView! {
        didSet {
            descriptionSV.delegate = self
        }
    }
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var emailLoginBtn: UIButton!
    
    var slides: [DescriptionSlide] = [];
    var webView: WKWebView!
    var authType: AuthType!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.isNavigationBarHidden = true
        
        slides = createSlides()
        setupSlideScrollView(slides: slides)
        emailLoginBtn.makeRounded(cornerRadius: 4)
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
        
        print(slide2.frame.size.width)
        print(slide2.logoImage.image?.size.width)
        print(DescriptionSlide.frame)
        print(descriptionSV.frame.size.width)
        
        return [slide1, slide2, slide3, slide4]
    }
    
    func setupSlideScrollView(slides : [DescriptionSlide]) {
        descriptionSV.contentSize = CGSize(width: 301 * CGFloat(slides.count), height: 208)
        descriptionSV.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: 301 * CGFloat(i), y: 0, width: 301, height: 208)
            descriptionSV.addSubview(slides[i])
        }
        
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(descriptionSV.contentOffset.x/301)
        pageControl.currentPage = Int(pageIndex)
    }
    @IBAction func emailLoginBtnAction(_ sender: Any) {
        let dvc = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "EmailLoginVC")
        
        self.navigationController!.pushViewController(dvc, animated: true)
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
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        let size = CGSize(width: 50, height: 50)
        let activityData = ActivityData(size: size, message: "Loading", type: .lineSpinFadeLoader, color: UIColor.lightGreen, textColor: UIColor.lightGreen)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        if let url = webView.url?.absoluteString {
            print(url)
            if url == "http://13.125.190.74:3000/auth/login/success" {
                webView.evaluateJavaScript("document.body.innerText", completionHandler: { (data, error) in
                    let dataStr = data as! String
                    if let result = dataStr.data(using: .utf8) {
                        if self.authType == .kakao {
                            do {
                                let kakao = try JSONDecoder().decode(ResponseArray<Login>.self, from: result)
                                UserDefaults.standard.set(kakao.data![0].token, forKey: "token")
                                UserDefaults.standard.set(kakao.data![0].refreshToken, forKey: "refreshtoken")
                                UserDefaults.standard.set(kakao.data![0].email, forKey: "email")
                                UserDefaults.standard.set(kakao.data![0].name, forKey: "name")
                            } catch {
                                print(error)
                            }
                        }
                    }
                })
                webView.removeFromSuperview()
                
                if UserDefaults.standard.bool(forKey: "암호 설정") {
                    let dvc = UIStoryboard(name: "Lock", bundle: nil).instantiateViewController(withIdentifier: "LockVC") as! LockVC
                    
                    dvc.mode = LockMode.validate
                    
                    self.navigationController!.pushViewController(dvc, animated: true)
                } else {
                    let dvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainVC")
                    
                    self.navigationController!.pushViewController(dvc, animated: true)
                }
                
            } else if url == "http://13.125.190.74:3000/auth/login/fail" {
                self.simpleAlert(title: "Oops!", message: "로그인을 다시 시도해주세요")
                webView.removeFromSuperview()
            }
        }
    }
}
