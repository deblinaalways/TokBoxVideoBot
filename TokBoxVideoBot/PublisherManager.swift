//
//  PublisherManager.swift
//  TokBoxVideoBot
//
//  Created by Deblina Das on 19/04/17.
//  Copyright © 2017 Deblina Das. All rights reserved.
//

import Foundation
import OpenTok

class PublisherManager: OTPublisherKit {
    
    var exampleCapturer: VideoCaptureManager?
    var exampleRenderer: VideoRenderManager?
    
    override init?(delegate: OTPublisherKitDelegate!, name: String!, audioTrack: Bool, videoTrack: Bool) {
        let settings = OTPublisherSettings()
        settings.name = name
        settings.videoTrack = videoTrack
        settings.audioTrack = audioTrack
        super.init(delegate: delegate, settings: settings)
    }
    override init?(delegate: OTPublisherKitDelegate!, name: String!) {
        let settings = OTPublisherSettings()
        settings.name = name
        super.init(delegate: delegate, settings: settings)
        exampleCapturer = VideoCaptureManager()
        exampleRenderer = VideoRenderManager()
        videoCapture = exampleCapturer!
        videoRender = exampleRenderer!
    }
    
    var view: UIView {
        get {
            return exampleRenderer!
        }
    }
}

