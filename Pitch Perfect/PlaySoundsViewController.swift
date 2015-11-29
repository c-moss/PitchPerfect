//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Campbell Moss on 14/11/15.
//  Copyright (c) 2015 Campbell Moss. All rights reserved.
//

import UIKit
import AVFoundation

/**
 ViewController for the Play screen. Has actions for playing back the recorded audio with various effects applied.
 */
class PlaySoundsViewController: UIViewController {
        
    var receivedAudio:RecordedAudio!
    
    var audioFile:AVAudioFile!
    
    var audioEngine:AVAudioEngine!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //TODO: Delete this test code and the mp3 resource it uses
        if let filePath = NSBundle.mainBundle().pathForResource("tim", ofType: "mp3") {
            try! audioFile = AVAudioFile(forReading: NSURL(fileURLWithPath: filePath))
        } else {
            print("File not found")
        }
        
        //try! audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl)
        
        audioEngine = AVAudioEngine()
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
    
    /**
     Play the recorded audio.
     
     - parameter rate: Rate to play back the audio at
     - parameter pitch: Pitch to play back the audio at
     */
    func play(rate rate: Float?=nil, pitch: Float?=nil) {
        
        //clean up audio engine after any previous playback
        audioEngine.stop()
        audioEngine.reset()
        
        //set up player audio engine node
        let playerNode = AVAudioPlayerNode()
        audioEngine.attachNode(playerNode)
        
        //set up pitch/rate audio engine node and insert parameters
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
        playerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        try! audioEngine.start()
        
        playerNode.play()
    }
    
    @IBAction func stopPlayback(sender: UIButton) {
        audioEngine.stop()
        audioEngine.reset()
    }

}
