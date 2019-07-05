//
//  UIImageView+Extensions.swift
//  MindGarden
//
//  Created by Sunghee Lee on 05/07/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import Foundation

extension UIImageView {
    public func imageFromUrl(urlString: String) {
        if let url = NSURL(string: urlString) {
            let request = NSURLRequest(URL: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                if let imageData = data as NSData? {
                    self.image = UIImage(data: imageData)
                }
            }
        }
    }
}
