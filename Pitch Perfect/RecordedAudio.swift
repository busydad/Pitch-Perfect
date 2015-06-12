//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Per Dalsgaard on 11/06/15.
//  Copyright (c) 2015 Per Dalsgaard. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    
    var filePathUrl: NSURL!
    var title: String!
    
    
    init(url: NSURL!) {
        filePathUrl = url
        title = url.lastPathComponent
    }
    
    
}
