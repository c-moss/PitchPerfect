//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Campbell Moss on 4/11/15.
//  Copyright (c) 2015 Campbell Moss. All rights reserved.
//

import UIKit
import AVFoundation

/**
 ViewController for the Record screen screen. Lets the user record an audio clip, then transitions to the Play screen.
 */
class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordingLabel: UILabel!

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        //set up the UI
        recordButton.enabled = true
        stopButton.hidden = true
        recordingLabel.text = NSLocalizedString("RecordingLabel_default", comment: "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /**
     IBAction that handles the record button being pressed. Starts recording audio to a .wav file.
     - parameter sender:UIButton that triggered the action
    */
    @IBAction func startRecordAudio(sender: UIButton) {
        //update the UI
        recordingLabel.text = NSLocalizedString("RecordingLabel_recording", comment: "")
        recordButton.enabled = false
        stopButton.hidden = false
        
        //set up the location and file for the recording
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let recordingName = "recording.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        //set up the audio session
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        //set up the audio recorder and start recording
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    /**
     IBAction that handles the stop button being pressed. Stops an in-progress recording.
     - parameter sender:UIButton that triggered the action
     */
    @IBAction func stopRecordAudio(sender: UIButton) {
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    /*
     AVAudioRecorderDelegate calls this when the audio recorder finishes recording.
     If the recording was successful, populate the RecorderAudio model and perform the segue.
     */
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully success: Bool) {
        if (success) {
            let recordedAudio:RecordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent)
            performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            print("Recording failed")
            //TODO: handle errors in a user-friendly way
            //update UI
            recordingLabel.text = NSLocalizedString("RecordingLabel_default", comment: "")
            stopButton.hidden = true
        }
    }
    
    /*
     Pass the model object to the destination view controller
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
}

