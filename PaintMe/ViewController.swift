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
    var count = 0
    var firstPoint = CGPoint.zero
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
            print(point)
            
        }
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first{
            let point = touch.locationInView(self.canvas)
            
        
         UIGraphicsBeginImageContext(self.canvas!.frame.size)
            let context = UIGraphicsGetCurrentContext()
        let rect = CGRect(x: 0, y: 0, width: (self.canvas?.frame.size.width)!, height: (self.canvas?.frame.size.height)!)
        self.canvas?.image?.drawInRect(rect)
        CGContextMoveToPoint(context, self.firstPoint.x, self.firstPoint.y)
        CGContextAddLineToPoint(context,point.x, point.y)
        CGContextStrokePath(context)
        self.canvas?.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
            firstPoint = point
        
    }
        
        
    }


}

