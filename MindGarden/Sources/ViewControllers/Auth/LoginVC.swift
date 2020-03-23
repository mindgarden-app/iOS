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
import AuthenticationServices

class LoginVC: UIViewController, UIScrollViewDelegate, NVActivityIndicatorViewable {
    
    @IBOutlet var descriptionSV: UIScrollView! {
        didSet {
            descriptionSV.delegate = self
        }
    }
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var emailLoginBtn: UIButton!
    @IBOutlet var appleLoginView: UIView!
    
    var slides: [DescriptionSlide] = [];
    var webView: WKWebView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slides = createSlides()
        setupSlideScrollView(slides: slides)
        emailLoginBtn.makeRounded(cornerRadius: 4)
        addAppleLoginButton()
    }
    
    func createSlides() -> [DescriptionSlide] {
        let slide1: DescriptionSlide = Bundle.main.loadNibNamed("DescriptionSlide", owner: self, options: nil)?.first as! DescriptionSlide
        slide1.logoImage.image = UIImage(named: "imgLogInNew1")
        
        let slide2: DescriptionSlide = Bundle.main.loadNibNamed("DescriptionSlide", owner: self, options: nil)?.first as! DescriptionSlide
        slide2.logoImage.image = UIImage(named: "imgLogInNew2")
        
        let slide3: DescriptionSlide = Bundle.main.loadNibNamed("DescriptionSlide", owner: self, options: nil)?.first as! DescriptionSlide
        slide3.logoImage.image = UIImage(named: "imgLogInNew3")
        
        let slide4: DescriptionSlide = Bundle.main.loadNibNamed("DescriptionSlide", owner: self, options: nil)?.first as! DescriptionSlide
        slide4.logoImage.image = UIImage(named: "imgLogInNew4")
        
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
        let url = NSURL(string: APIConstants.KaKaoLoginURL)
        let request = NSURLRequest(url: url! as URL)

        let config = WKWebViewConfiguration()
        config.websiteDataStore = WKWebsiteDataStore.nonPersistent()
        webView = WKWebView(frame: self.view.frame, configuration: config)
        webView.navigationDelegate = self
        webView.load(request as URLRequest)
        self.view.addSubview(webView)
    }
    
    func addAppleLoginButton() {
        if #available(iOS 13.0, *) {
            let button = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .whiteOutline)
            button.addTarget(self, action: #selector(handleAppleSignInButton), for: .touchUpInside)
            appleLoginView.addSubview(button)
            
            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                button.centerXAnchor.constraint(equalTo: appleLoginView.centerXAnchor),
                button.centerYAnchor.constraint(equalTo: appleLoginView.centerYAnchor),
                button.widthAnchor.constraint(equalToConstant: appleLoginView.frame.size.width),
                button.heightAnchor.constraint(equalToConstant: appleLoginView.frame.size.height)
            ])
        }
    }
    
    @objc func handleAppleSignInButton() {
        if #available(iOS 13.0, *) {
            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.fullName, .email]
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self as? ASAuthorizationControllerDelegate
            controller.presentationContextProvider = self as? ASAuthorizationControllerPresentationContextProviding
            controller.performRequests()
        }
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
            if url == APIConstants.KakaoLoginSuccessURL {
                webView.load(URLRequest(url: URL(string:"about:blank")!))
                
                webView.evaluateJavaScript("document.body.innerText", completionHandler: { (data, error) in
                    
                    let dataStr = data as! String
                    
                    if let result = dataStr.data(using: .utf8) {
                        do {
                            let kakao = try JSONDecoder().decode(ResponseArray<Login>.self, from: result)
                            
                            UserDefaults.standard.set(kakao.data![0].token, forKey: "token")
                            UserDefaults.standard.set(kakao.data![0].refreshToken, forKey: "refreshtoken")
                            
                            if kakao.data![0].email != nil{
                                UserDefaults.standard.set(kakao.data![0].email, forKey: "email")
                            } else {
                                UserDefaults.standard.set("not email", forKey: "email")
                            }
                            
                            UserDefaults.standard.set(kakao.data![0].name, forKey: "name")
                            
                            if UserDefaults.standard.bool(forKey: "암호 설정") {
                                let dvc = UIStoryboard(name: "Lock", bundle: nil).instantiateViewController(withIdentifier: "LockVC") as! LockVC

                                dvc.mode = LockMode.validate

                                self.navigationController!.pushViewController(dvc, animated: true)

                                webView.removeFromSuperview()
                            } else {
                                let dvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainVC")

                                self.navigationController!.pushViewController(dvc, animated: true)

                                webView.removeFromSuperview()
                            }
                        } catch {
                            print(error)
                        }
                    }
                })
                
            } else if url == APIConstants.KakaoLoginFailURL {
                self.simpleAlert(title: "Oops!", message: "로그인을 다시 시도해주세요")
                webView.removeFromSuperview()
            }
        }
    }
}

@available(iOS 13.0, *)
extension LoginVC: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
         switch authorization.credential {
           case let appleIDCredential as ASAuthorizationAppleIDCredential:
               
               let userIdentifier = appleIDCredential.user
               if let email: String = appleIDCredential.email, let fullName = appleIDCredential.fullName {
                    let name = fullName.givenName
                    AuthService.shared.appleLogin(fullName: name!, email: email, user: userIdentifier) { [weak self] data in
                            guard let `self` = self else { return }
                            
                            switch data {
                                case .success(let res):
                                    let data = res as! Login
                                    
                                    print(data.token)
                                    UserDefaults.standard.set(data.refreshToken, forKey: "refreshtoken")
                                    UserDefaults.standard.set(data.token, forKey: "token")
                                    UserDefaults.standard.set(data.email, forKey: "email")
                                    UserDefaults.standard.set(data.name, forKey: "name")
                                    
                                    if UserDefaults.standard.bool(forKey: "암호 설정") {
                                        let dvc = UIStoryboard(name: "Lock", bundle: nil).instantiateViewController(withIdentifier: "LockVC") as! LockVC
                                        
                                        dvc.mode = LockMode.validate
                                        
                                        self.navigationController!.pushViewController(dvc, animated: true)
                                    } else {
                                        let dvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainVC")
                                        
                                        self.navigationController!.pushViewController(dvc, animated: true)
                                    }
                                    
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
               } else {
                    AuthService.shared.appleLogin(fullName: nil, email: nil, user: userIdentifier) { [weak self] data in
                        guard let `self` = self else { return }
                        
                        switch data {
                            case .success(let res):
                                let data = res as! Login
                                
                                UserDefaults.standard.set(data.refreshToken, forKey: "refreshtoken")
                                UserDefaults.standard.set(data.token, forKey: "token")
                                UserDefaults.standard.set(data.email, forKey: "email")
                                UserDefaults.standard.set(data.name, forKey: "name")
                                
                                if UserDefaults.standard.bool(forKey: "암호 설정") {
                                    let dvc = UIStoryboard(name: "Lock", bundle: nil).instantiateViewController(withIdentifier: "LockVC") as! LockVC
                                    
                                    dvc.mode = LockMode.validate
                                    
                                    self.navigationController!.pushViewController(dvc, animated: true)
                                } else {
                                    let dvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainVC")
                                    
                                    self.navigationController!.pushViewController(dvc, animated: true)
                                }
                                
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
         default:
            break;
        }
    }
    
    // Handle error
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
    }
    
//    private func registerNewAccount(credential: ASAuthorizationAppleIDCredential) {
//        let userData = UserData(email: credential.email!, name: credential.fullName!, identifier: credential.user)
//
//        let keychain = UserDataKeychain()
//
//        // icloud 넣기
//        do {
//            try keychain.store(userData)
//        } catch {
//            // fail
//        }
//
//        do {
//            let success = try WebApi.Register( user: userData, identityToken: credential.identityToken, authorizationCode: credential.authorizationCode )
//            self.signInSucceeded(success)
//
//        } catch { self.signInSucceeded(false) }
//    }
}
