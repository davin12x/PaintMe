//
//  ViewController.swift
//  PaintMe
//
//  Created by Lalit on 2016-03-30.
//  Copyright © 2016 Bagga. All rights reserved.
//

import UIKit
import RappleColorPicker
import AVFoundation
import GoogleMobileAds
import StoreKit

extension UIColor {
    func RGB() -> (red:CGFloat,green:CGFloat,blue:CGFloat) {
        let components = CGColorGetComponents(self.CGColor)
        let red = CGFloat(components[0])
        let green = CGFloat(components[1])
        let blue = CGFloat(components[2])
        return(red * 255 ,green * 255 ,blue * 255)
        //Returning Hexa Value
        //        return String(format: "#%02lX%02lX%02lX", lroundf(red * 255), lroundf(green * 255), lroundf(blue * 255))
    }
}
class ViewController: UIViewController,RappleColorPickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SKProductsRequestDelegate {
    @IBOutlet weak var roundButton: roundedButton!
    @IBOutlet weak var googleAd: GADBannerView!
    @IBOutlet weak var camera: UIImageView!
    @IBOutlet weak var backImage: UIImageView!
    var colourPlallate = RappleColorPicker()
    @IBOutlet weak var canvas:UIImageView?
    @IBOutlet weak var colorBar: UIStackView!
    @IBOutlet weak var toolBar: UIStackView!
    @IBOutlet weak var chooseColorButton:roundedButton?
    let imagePicker = UIImagePickerController()
    var audioPlayer:AVAudioPlayer!
    var colourer: UIColor?
    var count = 0
    var red : CGFloat = 0
    var blue : CGFloat = 0
    var green :CGFloat = 0
    var alpha:CGFloat = 0
    var strokeWidth:CGFloat = 2
    var firstPoint = CGPoint.zero
    var random = true
    var eraser = false
//    var playStatus :Bool = false
    var bottomImage :UIImage?
    var topImage :UIImage?
    var copyImage:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        print("Google Sdk Version " + GADRequest.sdkVersion())
        //dem0 id ca-app-pub-3940256099942544/2934735716
        
        //orignal id = ca-app-pub-8468951005296370/9060383646
        googleAd.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        googleAd.rootViewController = self
        googleAd.loadRequest(GADRequest())
        let path = NSBundle.mainBundle().pathForResource("Horn", ofType: "mp3")
        let soundUrl = NSURL(fileURLWithPath: path!)
        do{
            try audioPlayer = AVAudioPlayer(contentsOfURL: soundUrl)
            audioPlayer.prepareToPlay()
        }
        catch let err as NSError{
            print(err.debugDescription)
        }
         animation(false)
        
        //Camera Tapped
        let cameraTapped = UITapGestureRecognizer(target: self, action: #selector(ViewController.onCameraPressed(_:)))
        cameraTapped.numberOfTapsRequired = 1
        camera.addGestureRecognizer(cameraTapped)
        camera.userInteractionEnabled = true
        requestProduct()
        checkAndShowPurshasedItem()
        checkDeviceOrientation()
    }
    
    func playAudio(){
        audioPlayer.play()
    }
    func checkAndShowPurshasedItem(){
        let defaults = NSUserDefaults.standardUserDefaults()
        if let name = defaults.stringForKey("purchased"){
            googleAd.hidden = true
            
        }
    }
    func mergeImage(botImage:UIImage,topImage:UIImage)->UIImage{
       
        UIGraphicsBeginImageContext(self.backImage.frame.size)
        
        let areaSize = CGRect(x: 0, y: 0, width: (self.backImage.frame.size.width), height: (self.backImage.frame.size.height))
        botImage.drawInRect(areaSize)
        topImage.drawInRect(CGRectMake(0, 0, topImage.size.width, topImage.size.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
        
    }
    func requestProduct(){
        let ids:Set<String> = ["com.Bagga.PaintMe"]
        let productsRequest = SKProductsRequest(productIdentifiers: ids)
        productsRequest.delegate = self
        productsRequest.start()
    }
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        print(response.products.count)
        print(response.invalidProductIdentifiers.count)
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        print(self.canvas?.frame.size)
        checkAndShowPurshasedItem()
    }
    func colorSelected(color: UIColor) {
        chooseColorButton?.layer.backgroundColor = color.CGColor
        let rgb = color.RGB()
        colour(rgb.red, green: rgb.green, blue: rgb.blue, alpha: 1)
        RappleColorPicker.close()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let touch = touches.first{
            let point = touch.locationInView(self.canvas)
            firstPoint = point
            print(self.canvas?.frame.size)
            
        }
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let point = touch.locationInView(self.canvas)
            animation(false)
            
        }
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let point = touch.locationInView(self.canvas)
            UIGraphicsBeginImageContext(self.canvas!.frame.size)
            let context = UIGraphicsGetCurrentContext()
            let rect = CGRect(x: 0, y: 0, width: (self.canvas?.frame.size.width)!, height: (self.canvas?.frame.size.height)!)
            if random == true{
                mixColour()
            }
            if eraser == true{
                CGContextSetBlendMode(context, .Copy)
            }
            self.canvas?.image?.drawInRect(rect)
            CGContextMoveToPoint(context, self.firstPoint.x, self.firstPoint.y)
            CGContextAddLineToPoint(context,point.x, point.y)
            CGContextSetRGBStrokeColor(context, self.red,self.green, self.blue, self.alpha)
            CGContextSetLineCap(context, .Round)
            CGContextSetLineWidth(context, strokeWidth)
            CGContextStrokePath(context)
            self.canvas?.image = UIGraphicsGetImageFromCurrentImageContext()
            self.copyImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            firstPoint = point
            animation(true)
            
        }
    }
    func animation(status:Bool) -> Void {
        UIView.animateWithDuration(2) {
            print(status)
            self.toolBar.hidden = status
            self.colorBar.hidden = status
        }
    }
    @IBAction func blueTapped(sender:UIButton){
        colour(57, green: 111, blue: 222, alpha: 1)
        randomAndEraserFalse()
        playAudio()
    }
    @IBAction func redTapped(sender:UIButton){
        colour(234, green: 53, blue: 60, alpha: 1)
        randomAndEraserFalse()
        playAudio()
    }
    @IBAction func greenTapped(sender:UIButton){
        colour(0, green: 235, blue: 129, alpha: 1)
        randomAndEraserFalse()
        playAudio()
    }
    @IBAction func eraserTapped(sender:UIButton){
        colour(255, green:255, blue: 255, alpha: 0)
        eraser = true
        random = false
        playAudio()
    }
    @IBAction func randomTapped(sender:UIButton){
        random = true
        playAudio()
    }
//    @IBOutlet weak var monkey: UIImageView!
    @IBAction func onSettingPressed(sender:UIButton){
        playAudio()
        performSegueWithIdentifier("SettingVC", sender: nil)
        
    }
    @IBAction func onClearPressed(sender:UIButton){
        self.canvas?.image = nil
        playAudio()
    }
    @IBAction func chooseColourPressed(sender: AnyObject) {
        
        RappleColorPicker.openColorPallet(onViewController: self, origin: CGPointMake(50, 100), delegate: self, title : "Colors")
        randomAndEraserFalse()
        playAudio()
    }
    func mixColour(){
        colour(CGFloat(arc4random_uniform(256)), green: CGFloat(arc4random_uniform(256)), blue: CGFloat(arc4random_uniform(256)), alpha: 1)
       // playAudio()
    }
    func randomAndEraserFalse(){
        random = false
        eraser = false
    }
    func colour(red:CGFloat,green:CGFloat,blue:CGFloat,alpha:CGFloat){
        self.red = red/255
        self.green = green/255
        self.blue = blue/255
        self.alpha = alpha
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SettingVC"{
            let settingVc = segue.destinationViewController as? SettingVC
            settingVc?.drawingVC = self
            
        }
    }
    @IBAction func onPostPressed(sender:UIButton){
        playAudio()
        if let img = canvas?.image{
            var mergedImage:UIImage?
            if self.backImage.image != nil {
                mergedImage =  mergeImage(backImage.image!, topImage: img)
            }
            else{
                mergedImage = img
            }
            let activityVC = UIActivityViewController(activityItems: [mergedImage!], applicationActivities: nil)
            self.presentViewController(activityVC, animated: true, completion: nil)
        }
    }
    func onCameraPressed(sender:UITapGestureRecognizer){
        playAudio()
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.allowsEditing = false
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            //canvas?.contentMode = .ScaleAspectFill
            backImage.image = pickedImage
            
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        checkDeviceOrientation()
    }
    func checkDeviceOrientation(){
        if UIDevice.currentDevice().orientation.isLandscape{
            print("i m in landscape mode")
            // canvas?.image = nil
            canvas?.contentMode = .ScaleToFill
            canvas?.image = copyImage
            colorBar.distribution = .EqualSpacing
        }
        else{
            colorBar.distribution = .EqualSpacing
        }
    }
    
}


