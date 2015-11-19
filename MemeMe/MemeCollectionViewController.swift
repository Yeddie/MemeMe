//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Eddie Groberski on 11/8/15.
//  Copyright © 2015 Edward Groberski. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    /**
     Get list of memes from app delegate
     */
    var memes: [Meme]! {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    
     // MARK: View management
    
    
    /**
     View did load, setup flow layout
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 3.0
        let width = (view.frame.size.width - (2 * space)) / 3.0
        let height = (view.frame.size.height - (2 * space)) / 3.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(width, height)
    }
    
    
    /**
     View will appear, reload data
     */
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        collectionView!.reloadData()
        tabBarController?.tabBar.hidden = false
    }
    
    // MARK: Collection View Data Source
    
    
    /**
    Return count of memes
    */
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    
    /**
     Return cell with meme image set
     */
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // Get cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        // Get Meme
        let meme = memes[indexPath.row]
        // Set the image
        cell.memeImageView?.image = meme.memedImage
        
        return cell
    }
    
    
    /**
     Selected a cell, show detail view
     */
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath) {
        let detailMemeController = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailMemeController.meme = memes[indexPath.row]
        navigationController!.pushViewController(detailMemeController, animated: true)
    }
    
}