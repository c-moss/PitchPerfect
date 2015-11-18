//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Campbell Moss on 4/11/15.
//  Copyright (c) 2015 Campbell Moss. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordingLabel: UILabel!

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        recordButton.enabled = true
        stopButton.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startRecordAudio(sender: UIButton) {
        //update UI
        recordingLabel.hidden = false
        recordButton.enabled = false
        stopButton.hidden = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let recordingName = "recording.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        //TODO: remove once Swift 2.0 is here
        var recordError:NSError?
        
        let session = AVAudioSession.sharedInstance()
        //TODO: change to Swift 2.0 error handling syntax
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: &recordError)
        
        //TODO: change to Swift 2.0 error handling syntax
        audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:], error: &recordError)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecordAudio(sender: UIButton) {
        audioRecorder.stop()
        //TODO: change to Swift 2.0 error handling syntax
        var recordError:NSError?
        let audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: &recordError)
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully success: Bool) {
        if (success) {
            var recordedAudio:RecordedAudio = RecordedAudio()
            recordedAudio.filePathUrl = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
            performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            println("Recording failed")
            
            //update UI
            recordingLabel.hidden = true
            stopButton.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
}

