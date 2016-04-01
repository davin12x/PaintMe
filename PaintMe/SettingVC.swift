//
//  SettingVC.swift
//  PaintMe
//
//  Created by Lalit on 2016-03-31.
//  Copyright © 2016 Bagga. All rights reserved.
//

import UIKit

class SettingVC: UIViewController {
    @IBOutlet weak var slider:UISlider?
    var drawingVC = ViewController()
    var strokeWidth:CGFloat = 10
    var sliderValue:Float = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false
        self.slider?.addTarget(self, action: #selector(SettingVC.sliderValueChange(_:)), forControlEvents: UIControlEvents.ValueChanged)
        slider?.thumbTintColor = UIColor.blueColor()
        slider?.maximumTrackTintColor = UIColor.greenColor()
        slider?.minimumTrackTintColor = UIColor.redColor()
        slider?.thumbImageForState(.Selected)
        //Setting up slider According to current value
        slider?.value = Float(drawingVC.strokeWidth)
    }
    func sliderValueChange(sender:UIControlEvents){
        strokeWidth = CGFloat((slider?.value)!)
        //Passing Value to ViewController
        drawingVC.strokeWidth = self.strokeWidth
    }
    @IBAction func onPostPressed(sender:UIButton){
        if let img = self.drawingVC.canvas?.image{
          let activityVC = UIActivityViewController(activityItems: [img], applicationActivities: nil)
            self.presentViewController(activityVC, animated: true, completion: nil)
        }
        
        
    }
}
