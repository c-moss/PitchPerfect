//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Campbell Moss on 14/11/15.
//  Copyright (c) 2015 Campbell Moss. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    @IBOutlet weak var stopButton: UIButton!
    
    var receivedAudio:RecordedAudio!
    
    var audioFile:AVAudioFile!
    
    var audioEngine:AVAudioEngine!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let filePath = NSBundle.mainBundle().pathForResource("tim", ofType: "mp3") {
//            try! audioFile = AVAudioFile(forReading: NSURL(fileURLWithPath: filePath))
//        } else {
//            print("File not found")
//        }
        
        try! audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl)
        
        audioEngine = AVAudioEngine()
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSlow(sender: UIButton) {
        play(rate: 0.5)
    }

    @IBAction func playFast(sender: UIButton) {
        play(rate: 2.0)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        play(pitch:1000)
    }
    
    @IBAction func playDarthAudio(sender: UIButton) {
        play(pitch:-1000)
    }
    
    func play(rate rate: Float?=nil, pitch: Float?=nil) {
        stopButton.hidden = false
        
        //clean up after any previous playback
        audioEngine.stop()
        audioEngine.reset()
        
        //set up player node
        let playerNode = AVAudioPlayerNode()
        audioEngine.attachNode(playerNode)
        
        //set up pitch/rate node and insert parameters
        let pitchRateNode = AVAudioUnitTimePitch()
        if let uRate = rate {
            pitchRateNode.rate = uRate
        }
        if let uPitch = pitch {
            pitchRateNode.pitch = uPitch
        }
        audioEngine.attachNode(pitchRateNode)
        
        //connect nodes
        audioEngine.connect(playerNode, to: pitchRateNode, format: audioFile.processingFormat)
        audioEngine.connect(pitchRateNode, to: audioEngine.outputNode, format: audioFile.processingFormat)
        
        //schedule file for playback in player node
        playerNode.scheduleFile(audioFile, atTime: nil, completionHandler: {
            //TODO: completionHandler doesn't get called exactly at the end of playback - figure out why
            self.stopButton.hidden = true
        })
        
        try! audioEngine.start()
        
        playerNode.play()
    }
    
    @IBAction func stopPlayback(sender: UIButton) {
        audioEngine.stop()
        audioEngine.reset()
        stopButton.hidden = true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
