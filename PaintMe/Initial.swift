//
//  Initial.swift
//  PaintMe
//
//  Created by Lalit on 2016-04-13.
//  Copyright © 2016 Bagga. All rights reserved.
//

import UIKit
import AVFoundation

class Initial: UIViewController {
    var audioPlayer:AVAudioPlayer!
    override func viewDidLoad() {
        super.viewDidLoad()
        let path = NSBundle.mainBundle().pathForResource("Coin", ofType: "mp3")
        let soundUrl = NSURL(fileURLWithPath: path!)
        do{
            try audioPlayer = AVAudioPlayer(contentsOfURL: soundUrl)
            audioPlayer.prepareToPlay()
        }
        catch let err as NSError{
            print(err.debugDescription)
        }
        
    }

    @IBAction func onPlayPressed(sender:UIButton){
        audioPlayer.play()
    }
    

  

}
