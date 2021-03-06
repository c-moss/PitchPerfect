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
class RecordSoundsViewController: BaseViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordingLabel: UILabel!

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        //set up the UI
        recordButton.enabled = true
        stopButton.hidden = true
        pauseButton.hidden = true
        pauseButton.enabled = true
        recordingLabel.text = NSLocalizedString("RecordingLabel_default", comment: "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /**
     IBAction that handles the record button being pressed. 
     
     If there is no current recorder, starts a new recording.
     If a recorder exists, assume that it's paused and resume.
     
     - parameter sender:UIButton that triggered the action
    */
    @IBAction func startRecordAudio(sender: UIButton) {
        if (audioRecorder != nil) {  //recording paused - resume
            //update the UI
            pauseButton.enabled = true
            recordingLabel.text = NSLocalizedString("RecordingLabel_recording", comment: "")
            audioRecorder.record()
        } else {
            //update the UI
            recordingLabel.text = NSLocalizedString("RecordingLabel_recording", comment: "")
            recordButton.enabled = false
            stopButton.hidden = false
            pauseButton.hidden = false
            
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
    }
    
    /**
     IBAction that handles the pause button being pressed. Pauses the recording.
     - parameter sender:UIButton that triggered the action
     */
    @IBAction func pauseRecordAudio(sender: UIButton) {
        guard audioRecorder != nil else {
            return
        }
        if audioRecorder.recording {
            //update the UI
            recordingLabel.text = NSLocalizedString("RecordingLabel_paused", comment: "")
            recordButton.enabled = true
            audioRecorder.pause()
            pauseButton.enabled = false
        }
    }
    
    /**
     IBAction that handles the stop button being pressed. Stops an in-progress recording.
     - parameter sender:UIButton that triggered the action
     */
    @IBAction func stopRecordAudio(sender: UIButton) {
        audioRecorder.stop()
        audioRecorder = nil
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
            showAlert(NSLocalizedString("ErrorTitle", comment: ""), message: NSLocalizedString("RecordingErrorMessage", comment: ""), handler: {
                //update UI
                self.recordingLabel.text = NSLocalizedString("RecordingLabel_default", comment: "")
                self.stopButton.hidden = true
                self.pauseButton.hidden = true
                self.pauseButton.enabled = true
            })
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

