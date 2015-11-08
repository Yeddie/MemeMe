//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Eddie Groberski on 11/8/15.
//  Copyright © 2015 Edward Groberski. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController : UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var meme: Meme!
    
    /**
     View will appear, set memed image
     */
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
        self.imageView!.image = meme.memedImage
    }
    
    
    /**
     View will disappear, show tab bar
     */
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.hidden = false
    }
}