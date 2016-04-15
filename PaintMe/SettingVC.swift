//
//  SettingVC.swift
//  PaintMe
//
//  Created by Lalit on 2016-03-31.
//  Copyright © 2016 Bagga. All rights reserved.
//

import UIKit
import StoreKit
import AVFoundation

class SettingVC: UIViewController,SKProductsRequestDelegate,SKPaymentTransactionObserver {
    @IBOutlet weak var slider:UISlider?
    @IBOutlet weak var hideAd: UIButton?
    var drawingVC = ViewController()
    var strokeWidth:CGFloat = 2
    var sliderValue:Float = 1
    var products = [SKProduct]()
    var audioPlayer :AVAudioPlayer!
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
        requestProduct()
        checkAndShowPurshasedItem()
        
        //Sound
        let path = NSBundle.mainBundle().pathForResource("buttonClick", ofType: "mp3")
        let soundUrl = NSURL(fileURLWithPath: path!)
        do{
            try audioPlayer = AVAudioPlayer(contentsOfURL: soundUrl)
            audioPlayer.prepareToPlay()
        }
        catch let err as NSError{
            print(err.debugDescription)
        }
    }
    
    func sliderValueChange(sender:UIControlEvents){
        strokeWidth = CGFloat((slider?.value)!)
        //Passing Value to ViewController
        drawingVC.strokeWidth = self.strokeWidth
    }
    override func viewDidAppear(animated: Bool) {
        checkAndShowPurshasedItem()
    }
    func requestProduct(){
        let ids:Set<String> = ["com.Bagga.PaintMe"]
        let productsRequest = SKProductsRequest(productIdentifiers: ids)
        productsRequest.delegate = self
        productsRequest.start()
    }
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        self.products = response.products
    }
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("This is button pressed")
        for transaction in transactions{
            switch transaction.transactionState {
            case .Purchased:
                print("purchased")
                hideAdd()
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                break
            case.Purchasing:
                print("purchasing")
                break
            case.Failed:
                print("failed")
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                break
            case.Restored:
                hideAdd()
                print("Restored")
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                break
            case.Deferred:
                print("Defered")
                break
                
            }
        }
    }
    
    @IBAction func onHideAddPressed(sender: AnyObject) {
        for product in self.products{
            SKPaymentQueue.defaultQueue().addTransactionObserver(self)
            let payment = SKPayment(product: product)
            SKPaymentQueue.defaultQueue().addPayment(payment)
            playAudio()
        }
    }
    @IBAction func onRestorePressed(sender:UIButton){
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
        playAudio()
        
    }
    func hideAdd(){
        let deafults = NSUserDefaults.standardUserDefaults()
        deafults.setBool(true, forKey: "purchased")
        drawingVC.googleAd.hidden = true
        drawingVC.checkAndShowPurshasedItem()
        hideButton(true)
        
    }
    //To hide the hideAD button
    func hideButton(value:Bool){
        hideAd!.hidden = value
    }
    func checkAndShowPurshasedItem(){
        let defaults = NSUserDefaults.standardUserDefaults()
        if let name = defaults.stringForKey("purchased"){
            hideButton(true)
            
        }
    }
    func playAudio(){
        audioPlayer.play()
    }
    
}
