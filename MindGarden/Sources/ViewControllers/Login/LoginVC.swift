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
    @IBOutlet var tmpMainBtn: UIButton!
    
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
        slide1.logoImage.image = UIImage(named: "")
        slide1.descriptionText.text = "1. 어쩌고 어쩌고"
        
        let slide2: DescriptionSlide = Bundle.main.loadNibNamed("DescriptionSlide", owner: self, options: nil)?.first as! DescriptionSlide
        slide2.logoImage.image = UIImage(named: "")
        slide2.descriptionText.text = "2. 어쩌고 어쩌고"
        
        let slide3: DescriptionSlide = Bundle.main.loadNibNamed("DescriptionSlide", owner: self, options: nil)?.first as! DescriptionSlide
        slide3.logoImage.image = UIImage(named: "")
        slide3.descriptionText.text = "3. 어쩌고 어쩌고"
        
        let slide4: DescriptionSlide = Bundle.main.loadNibNamed("DescriptionSlide", owner: self, options: nil)?.first as! DescriptionSlide
        slide4.logoImage.image = UIImage(named: "")
        slide4.descriptionText.text = "4. 어쩌고 어쩌고"
        
        return [slide1, slide2, slide3, slide4]
    }
    
    func setupSlideScrollView(slides : [DescriptionSlide]) {
//        descriptionSV.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
//        descriptionSV.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: 100)
        descriptionSV.contentSize = CGSize(width: 290 * CGFloat(slides.count), height: 310)
        descriptionSV.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
//            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            slides[i].frame = CGRect(x: 290 * CGFloat(i), y: 0, width: 290, height: 310)
            descriptionSV.addSubview(slides[i])
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let pageIndex = round(descriptionSV.contentOffset.x/view.frame.width)
        let pageIndex = round(descriptionSV.contentOffset.x/290)
        pageControl.currentPage = Int(pageIndex)
        
        let maximumHorizontalOffset: CGFloat = descriptionSV.contentSize.width - descriptionSV.frame.width
        let currentHorizontalOffset: CGFloat = descriptionSV.contentOffset.x
        
        let maximumVerticalOffset: CGFloat = descriptionSV.contentSize.height - descriptionSV.frame.height
        let currentVerticalOffset: CGFloat = descriptionSV.contentOffset.y
        
        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
        let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset
        
        let percentOffset: CGPoint = CGPoint(x: percentageHorizontalOffset, y: percentageVerticalOffset)
        
        if(percentOffset.x > 0 && percentOffset.x <= 0.25) {
            
            slides[0].logoImage.transform = CGAffineTransform(scaleX: (0.25-percentOffset.x)/0.25, y: (0.25-percentOffset.x)/0.25)
            slides[1].logoImage.transform = CGAffineTransform(scaleX: percentOffset.x/0.25, y: percentOffset.x/0.25)
            
        } else if(percentOffset.x > 0.25 && percentOffset.x <= 0.50) {
            slides[1].logoImage.transform = CGAffineTransform(scaleX: (0.50-percentOffset.x)/0.25, y: (0.50-percentOffset.x)/0.25)
            slides[2].logoImage.transform = CGAffineTransform(scaleX: percentOffset.x/0.50, y: percentOffset.x/0.50)
            
        } else if(percentOffset.x > 0.50 && percentOffset.x <= 0.75) {
            slides[2].logoImage.transform = CGAffineTransform(scaleX: (0.75-percentOffset.x)/0.25, y: (0.75-percentOffset.x)/0.25)
            slides[3].logoImage.transform = CGAffineTransform(scaleX: percentOffset.x/0.75, y: percentOffset.x/0.75)
            
        } else if(percentOffset.x > 0.75 && percentOffset.x <= 1) {
            slides[3].logoImage.transform = CGAffineTransform(scaleX: (1-percentOffset.x)/0.25, y: (1-percentOffset.x)/0.25)
//            slides[4].logoImage.transform = CGAffineTransform(scaleX: percentOffset.x, y: percentOffset.x)
        }
    }
    
    func scrollView(_ scrollView: UIScrollView, didScrollToPercentageOffset percentageHorizontalOffset: CGFloat) {
        if(pageControl.currentPage == 0) {
            let pageUnselectedColor: UIColor = fade(fromRed: 255/255, fromGreen: 255/255, fromBlue: 255/255, fromAlpha: 1, toRed: 103/255, toGreen: 58/255, toBlue: 183/255, toAlpha: 1, withPercentage: percentageHorizontalOffset * 3)
            pageControl.pageIndicatorTintColor = pageUnselectedColor
            
            
            let bgColor: UIColor = fade(fromRed: 103/255, fromGreen: 58/255, fromBlue: 183/255, fromAlpha: 1, toRed: 255/255, toGreen: 255/255, toBlue: 255/255, toAlpha: 1, withPercentage: percentageHorizontalOffset * 3)
            slides[pageControl.currentPage].backgroundColor = bgColor
            
            let pageSelectedColor: UIColor = fade(fromRed: 81/255, fromGreen: 36/255, fromBlue: 152/255, fromAlpha: 1, toRed: 103/255, toGreen: 58/255, toBlue: 183/255, toAlpha: 1, withPercentage: percentageHorizontalOffset * 3)
            pageControl.currentPageIndicatorTintColor = pageSelectedColor
        }
    }
    
    func fade(fromRed: CGFloat,
              fromGreen: CGFloat,
              fromBlue: CGFloat,
              fromAlpha: CGFloat,
              toRed: CGFloat,
              toGreen: CGFloat,
              toBlue: CGFloat,
              toAlpha: CGFloat,
              withPercentage percentage: CGFloat) -> UIColor {
        
        let red: CGFloat = (toRed - fromRed) * percentage + fromRed
        let green: CGFloat = (toGreen - fromGreen) * percentage + fromGreen
        let blue: CGFloat = (toBlue - fromBlue) * percentage + fromBlue
        let alpha: CGFloat = (toAlpha - fromAlpha) * percentage + fromAlpha
        
        // return the fade colour
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }

    
    @IBAction func tmpMainBtnAction(_ sender: Any) {
        let dvc = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "SettingsVC")
        
        self.navigationController!.pushViewController(dvc, animated: true)
    }

}
