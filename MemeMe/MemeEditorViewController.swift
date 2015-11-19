//
//  ViewController.swift
//  MemeMe
//
//  Created by Eddie Groberski on 10/18/15.
//  Copyright © 2015 Edward Groberski. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var toolbar: UIToolbar!
    
    var meme: Meme!
    var memedImage: UIImage!
    let topText = "TOP TEXT"
    let bottomText = "BOTTTOM TEXT"
    
    
    // MARK: View management
    
    
    /**
    View did load, set text field delegates
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMemeTextFields()
    }
    

    /**
    View will appear, set visible of camera button
    */
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    
    // MARK: Actions
    

    /**
    Camera button was pressed, show camera
    */
    @IBAction func cameraButtonPressed(sender: UIBarButtonItem) {
        presentImagePicker(true)
    }

    
    /**
    Album button was pressed, show albums
    */
    @IBAction func albumButtonPressed(sender: UIBarButtonItem) {
        presentImagePicker(false)
    }
    
    
    /**
    Cancel button was pressed, clear image and set default text
    */
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        imageView.image = nil
        topTextField.text = topText
        bottomTextField.text = bottomText
        enableShareButton()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    /**
    Share button was pressed
    */
    @IBAction func shareButtonPressed(sender: UIBarButtonItem) {
        memedImage = generateMemedImage()
        
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        presentViewController(activityViewController, animated: true, completion: nil)
        activityViewController.completionWithItemsHandler = {
            (text: String?, completed: Bool, activityItems: [AnyObject]?, err:NSError?) -> Void in
            if completed {
                self.save()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
    }
    
    
    // MARK: Keyboard methods
    
    
    /**
    Subscribe to keyboard will show and hide notifications
    */
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    /**
    Unsubscribe to keyboard will show and hide notifications
    */
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    /**
    Scroll view if using bottom text field
    */
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    
    /**
    Remove scroll if no longer using bottom text
    */
    func keyboardWillHide(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    
    /**
    Return height of the keyboard
    */
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    
    // MARK: UIImagePickerControllerDelegate
    
    
    /**
    Cancel was pressed in UIImagePickerController view
    */
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    /**
    Media was chosen, sent image of imageView
    */
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        }
        enableShareButton()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: UITextFieldDelegate
    

    /**
    Text stop being edited, resign first responder
    */
    func textFieldDidEndEditing(textField: UITextField) {
        resetDefaultMemeText(textField)
        textField.resignFirstResponder()
    }
    
    
    /**
    Done button pressed on keyboard, resign first responder
    */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        resetDefaultMemeText(textField)
        textField.resignFirstResponder()
        return true
    }
    
    /**
     Clear the text for typing
     */
    func textFieldDidBeginEditing(textField: UITextField) {
        let compareText = topTextField.isFirstResponder() ? topText: bottomText
        
        if textField.text == compareText {
            textField.text = ""
        }
    }
    
    
    // MARK: Helper methods
    
    
    /**
    Present UIImagePickerController
    - Parameter camera: Show Camera Type
    */
    func presentImagePicker(camera: Bool){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = camera ? UIImagePickerControllerSourceType.Camera: UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    /**
    Set up meme text field configuration
    */
    func setUpMemeTextFields(){
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3.0
        ]
        
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        topTextField.textAlignment = NSTextAlignment.Center
        bottomTextField.textAlignment = NSTextAlignment.Center
        
        topTextField.text = topText
        bottomTextField.text = bottomText
        
        topTextField.delegate = self
        bottomTextField.delegate = self
    }
    
    
    /**
    Reset default text
    */
    func resetDefaultMemeText(textField: UITextField) {
        if textField.text?.characters.count == 0 {
            let defaultText = topTextField.isFirstResponder() ? topText: bottomText
            textField.text = defaultText
        }
    }
    
    
    /**
    Enable share button if there is an image
    */
    func enableShareButton(){
        shareButton.enabled = imageView.image != nil ? true: false
    }
    

    /**
     Create memed image
     */
    func generateMemedImage() -> UIImage {
        toolbar.hidden = true
        navigationBar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        toolbar.hidden = false
        navigationBar.hidden = false
        
        return memedImage
    }
    
    
    /**
     Save the meme and an add to the App Delegate memes array
     */
    func save() {
        let meme = Meme(
            topText: topTextField.text!,
            bottomText: bottomTextField.text!,
            originalImage: imageView.image!,
            memedImage: memedImage)
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
}

