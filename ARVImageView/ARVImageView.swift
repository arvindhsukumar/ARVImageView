//
//  ARVImageView.swift
//  ARVImageView
//
//  Created by Arvindh Sukumar on 22/03/15.
//  Copyright (c) 2015 Arvindh Sukumar. All rights reserved.
//

import UIKit

enum ARVImageType {
    case Image
    case GIF
    case Video
}

class ARVImageView: UIView {
    var imageView: UIImageView!
    var progressView: UCZProgressView!
    var type: ARVImageType = .Image
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    
    func setup(){

        self.clipsToBounds = true
        self.imageView = UIImageView(frame: self.bounds)
        self.imageView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        self.imageView.contentMode = UIViewContentMode.ScaleAspectFill
        self.addSubview(self.imageView)
        
        self.progressView = UCZProgressView(frame: CGRectMake(0, 0, 44, 44))
        self.progressView.center = self.imageView.center
        self.progressView.indeterminate = false
        self.progressView.alpha = 0
        self.progressView.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleBottomMargin
        self.insertSubview(self.progressView, belowSubview: self.imageView)

    }
    
    func arv_setImageWithURL(url: NSURL, type: ARVImageType, success:(()->())?, failure:(()->())? ){
        let manager = SDWebImageManager.sharedManager()
        let imageExists = manager.cachedImageExistsForURL(url)

        
        if imageExists {
            self.progressView.setProgress(0, animated: false)
            self.imageView.image = manager.imageCache.imageFromDiskCacheForKey(manager.cacheKeyForURL(url))
            self.imageView.alpha = 1
            success?()
            return
        }
        
        if manager.isRunning() {

            return
        }
        
        self.imageView.alpha = 0
        self.progressView.alpha = 1
        if type == .Video {
            self.progressView.indeterminate = true
            let player = YKMediaPlayerKit(URL: url)
            player.parseWithCompletion({ (options:YKVideoTypeOptions, video:YKVideo!, error:NSError!) -> Void in
                
                if error == nil {
                    player.thumbWithCompletion({ (thumb:UIImage!, thumbError:NSError!) -> Void in
                        if thumbError == nil{
                            self.imageLoadingSucceeded(thumb,success:success?)

                            //TODO add overlay

                        }
                        else {
                            self.imageLoadingFailed(thumbError,failure:failure?)
                            return

                        }
                    })
                }
                else {
                    self.imageLoadingFailed(error,failure:failure?)
                    return
                }
            })
            
        }
        else {
            println("image")
            self.progressView.indeterminate = false
            self.progressView.setProgress(0.1, animated: true)

            
            manager.downloadImageWithURL(url, options: nil, progress: { (received:Int, expected:Int) -> Void in


                let progress: CGFloat = max(0.1,CGFloat(received)/CGFloat(expected))
                self.progressView.setProgress(progress, animated: true)

                }) { (image:UIImage!, error:NSError!, cacheType:SDImageCacheType, finished:Bool, imageURL:NSURL!) -> Void in
                    if image != nil {
                        self.imageLoadingSucceeded(image,success:success?)

                       
                    }
                    else {
                        // Handle error
                        self.imageLoadingFailed(error,failure:failure?)
                        return
                    }
            
            }
        }
    }
    
    func imageLoadingSucceeded(image:UIImage, success:(()->())?){
        self.imageView.image = image
        self.progressView.alpha = 0

        UIView.animateWithDuration(0.5, animations: { () -> Void in
            
            
            self.imageView.alpha = 1

            
            
            }, completion: { (finished:Bool) -> Void in
                self.progressView.setProgress(0, animated: false)

                success?()
               
        })

    }
    
    func imageLoadingFailed(error:NSError,failure:(()->())?){
        println(error.description)
        self.imageView.alpha = 1
        self.progressView.alpha = 0

        self.progressView.setProgress(0, animated: false)
        failure?()
    }
}
