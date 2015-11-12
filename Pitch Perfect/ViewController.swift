//
//  ViewController.swift
//  Pitch Perfect
//
//  Created by Campbell Moss on 4/11/15.
//  Copyright (c) 2015 Campbell Moss. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var recordingLabel: UILabel!

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
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
        //TODO: Record user's voice
        println("in recordAudio")
        recordingLabel.hidden = false
        recordButton.enabled = false
        stopButton.hidden = false
    }
    
    @IBAction func stopRecordAudio(sender: UIButton) {
        recordingLabel.hidden = true
        stopButton.hidden = true
    }
}

