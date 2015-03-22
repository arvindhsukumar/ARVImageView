//
//  ViewController.swift
//  ARVImageView
//
//  Created by Arvindh Sukumar on 22/03/15.
//  Copyright (c) 2015 Arvindh Sukumar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: ARVImageView!
    @IBAction func loadImage(sender: AnyObject) {
        
        let url = NSURL(string: "https://www.youtube.com/watch?v=fydhbWJdnD0&spfreload=10")
        let type = ARVImageType.Video
        self.imageView.arv_setImageWithURL(NSURL(string: "https://s3.amazonaws.com/cocoacontrols_production/uploads/control_image/image/2554/circular.jpg"),type: .Image, success:nil, failure:nil)
        
        //        self.imageView.arv_setImageWithURL(url, type: type, success: {
        //
        //        })
        //        self.imageView.arv_setImageWithURL(NSURL(string: "http://guides.cocoapods.org/assets/images/pod_lib_create/travis-ci.png"))

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        SDWebImageManager.sharedManager().imageCache.clearDisk()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }

}

