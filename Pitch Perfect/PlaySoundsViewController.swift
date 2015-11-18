//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Campbell Moss on 14/11/15.
//  Copyright (c) 2015 Campbell Moss. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet weak var stopButton: UIButton!
    
    var audioPlayer:AVAudioPlayer!
    //TODO: remove once Swift 2.0 is here
    var playError:NSError?
    
    var receivedAudio:RecordedAudio!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if var filePath = NSBundle.mainBundle().pathForResource("tim", ofType: "mp3") {
//
//        } else {
//            println("File not found")
//        }
        
        //TODO: change to Swift 2.0 error handling syntax
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: &playError)
        audioPlayer.enableRate = true
        audioPlayer.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSlow(sender: UIButton) {
        play(0.5)
    }

    @IBAction func playFast(sender: UIButton) {
        play(2.0)
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        stopButton.hidden = true
    }
    
    func play(rate: Float) {
        stopButton.hidden = false
        
        //clean up after any previous playback
        playError = nil
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        
        audioPlayer.rate = rate
        audioPlayer.play()
        if (playError != nil) {
            println(playError?.description)
        }
    }
    
    @IBAction func stopPlayback(sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0
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
