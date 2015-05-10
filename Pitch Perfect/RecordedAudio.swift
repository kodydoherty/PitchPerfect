//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Samuel Doherty on 5/7/15.
//  Copyright (c) 2015 ColombiaIOS. All rights reserved.
//

import Foundation

// A class to contain the file path and title of a recorded audio file
class RecordedAudio: NSObject {
    let filePathUrl: NSURL!
    let title: String!
    
    init(filePathUrl: NSURL!, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}