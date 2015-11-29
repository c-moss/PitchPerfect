//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Campbell Moss on 17/11/15.
//  Copyright (c) 2015 Campbell Moss. All rights reserved.
//

import Foundation

/**
 Model object that represents a recorded audio clip
 */
class RecordedAudio: NSObject{
    
    //Full file path of the audio clip on the filesystem
    var filePathUrl: NSURL!
    
    //Title of the recorded audio clip
    var title: String!
    
    init(filePathUrl: NSURL!, title: String!) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}