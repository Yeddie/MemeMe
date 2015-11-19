//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Eddie Groberski on 11/8/15.
//  Copyright © 2015 Edward Groberski. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController: UITableViewController {
    
    
    /**
     Get list of memes from app delegate
     */
    var memes: [Meme]! {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    
    // MARK: View Management
    
    
    /**
    View will appear, reload data
    */
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    // MARK: Table View Data Source
    
    
    /**
    Return count of memes
    */
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    
    /**
     Return cell with meme image and text set
     */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell")!
        let meme = memes[indexPath.row]
        
        let topText = meme.topText
        let bottomText = meme.bottomText
        
        // Set the name and image
        cell.textLabel?.text = "\(topText)...\(bottomText)"
        cell.imageView?.image = meme.memedImage
    
        return cell
    }
    
    
    /**
     Selected a cell, show detail view
     */
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailMemeController = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailMemeController.meme = memes[indexPath.row]
        navigationController!.pushViewController(detailMemeController, animated: true)
    }
    
    
    /**
     Cell can be edited
     */
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true;
    }
    
    
    /**
     Set cell editing style to delete
     */
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete;
    }
    
    
    /**
     Remove meme from app delegate array if user swipes to delete
     */
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            let object = UIApplication.sharedApplication().delegate
            let appDelegate = object as! AppDelegate
            appDelegate.memes.removeAtIndex(indexPath.row)
            tableView.reloadData()
        }
    }
}