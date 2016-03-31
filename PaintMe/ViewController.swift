//
//  ViewController.swift
//  PaintMe
//
//  Created by Lalit on 2016-03-30.
//  Copyright © 2016 Bagga. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var canvas:UIImageView?
    @IBOutlet weak var slider:UISlider?
    var count = 0
    var red : CGFloat = 0
    var blue : CGFloat = 0
    var green :CGFloat = 0
    var alpha:CGFloat = 0
    var strokeWidth:CGFloat = 10
    var firstPoint = CGPoint.zero
    var random = false
    var eraser = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(animated: Bool) {
        
        self.slider?.addTarget(self, action: #selector(ViewController.sliderValueChange(_:)), forControlEvents: UIControlEvents.ValueChanged)
        slider?.thumbTintColor = UIColor.blueColor()
        slider?.maximumTrackTintColor = UIColor.greenColor()
        slider?.minimumTrackTintColor = UIColor.redColor()
        slider?.thumbImageForState(.Selected)
    }
    func sliderValueChange(sender:UIControlEvents){
        strokeWidth = CGFloat((slider?.value)!)
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
                CGContextSetBlendMode(context, .Clear)
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
            
        }
    }
    @IBAction func blueTapped(sender:UIButton){
        colour(57, green: 111, blue: 222, alpha: 1)
        randomAndEraserFalse()
    }
    @IBAction func redTapped(sender:UIButton){
        colour(234, green: 53, blue: 60, alpha: 1)
        randomAndEraserFalse()
    }
    @IBAction func yellowTapped(sender:UIButton){
        colour(250, green: 214, blue: 74, alpha: 1)
        randomAndEraserFalse()
    }
    @IBAction func greenTapped(sender:UIButton){
        colour(0, green: 235, blue: 129, alpha: 1)
        randomAndEraserFalse()
    }
    @IBAction func eraserTapped(sender:UIButton){
        colour(255, green:255, blue: 255, alpha: 1)
        randomAndEraserFalse()
    }
    @IBAction func randomTapped(sender:UIButton){
        random = true
    }
    @IBAction func onSettingPressed(sender:UIButton){
        performSegueWithIdentifier("SettingVC", sender: nil)
        
    }
    func mixColour(){
        colour(CGFloat(arc4random_uniform(256)), green: CGFloat(arc4random_uniform(256)), blue: CGFloat(arc4random_uniform(256)), alpha: 1)
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
    
}

