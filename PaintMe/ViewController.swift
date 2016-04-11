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
class ViewController: UIViewController,RappleColorPickerDelegate {
    
    var colourPlallate = RappleColorPicker()
    @IBOutlet weak var canvas:UIImageView?
    @IBOutlet weak var colorBar: UIStackView!
    @IBOutlet weak var toolBar: UIStackView!
    @IBOutlet weak var chooseColorButton:roundedButton?
    
    var audioPlayer:AVAudioPlayer!
    var colourer: UIColor?
    var count = 0
    var red : CGFloat = 0
    var blue : CGFloat = 0
    var green :CGFloat = 0
    var alpha:CGFloat = 0
    var strokeWidth:CGFloat = 10
    var firstPoint = CGPoint.zero
    var random = true
    var eraser = false
    var playStatus :Bool = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let path = NSBundle.mainBundle().pathForResource("Horn", ofType: "mp3")
        let soundUrl = NSURL(fileURLWithPath: path!)
        do{
            try audioPlayer = AVAudioPlayer(contentsOfURL: soundUrl)
            audioPlayer.prepareToPlay()
            
        }
        catch let err as NSError{
            print(err.debugDescription)
        }
         animation(true)
        let tap  = UITapGestureRecognizer(target: self, action: #selector(ViewController.monkeyTapped(_:)))
        tap.numberOfTouchesRequired = 1
        monkey.addGestureRecognizer(tap)
        monkey.userInteractionEnabled = true
    }
    func playAudio(){
        audioPlayer.play()
    }
    func monkeyTapped(gesture:UITapGestureRecognizer) -> Void {
        UIView.animateWithDuration(1) {
            self.monkey.alpha = 0
            self.playStatus = true
            self.playAudio()
        }
        animation(false)
    
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    func colorSelected(color: UIColor) {
        chooseColorButton?.layer.backgroundColor = color.CGColor
        let rgb = color.RGB()
        //self.view.backgroundColor = color
        colour(rgb.red, green: rgb.green, blue: rgb.blue, alpha: 1)
        RappleColorPicker.close()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first{
            let point = touch.locationInView(self.canvas)
            firstPoint = point
            
        }
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first{
            let point = touch.locationInView(self.canvas)
            animation(false)
            
        }
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first{
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
    @IBAction func yellowTapped(sender:UIButton){
        colour(250, green: 214, blue: 74, alpha: 1)
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
    @IBOutlet weak var monkey: UIImageView!
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
            let activityVC = UIActivityViewController(activityItems: [img], applicationActivities: nil)
            self.presentViewController(activityVC, animated: true, completion: nil)
        }
        
        
        
    }
    
}


