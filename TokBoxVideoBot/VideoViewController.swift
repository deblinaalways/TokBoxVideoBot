//
//  VideoViewController.swift
//  TokBoxVideoBot
//
//  Created by Deblina Das on 19/04/17.
//  Copyright © 2017 Deblina Das. All rights reserved.
//

import Foundation
import UIKit
import OpenTok

let kApiKey = "45823132"
let kSessionId = "1_MX40NTgyMzEzMn5-MTQ5MjUzNzIxNTUxM35qejk0VHRCSE80a0VJREFuVGIveEhmNjF-fg"
let kToken = "T1==cGFydG5lcl9pZD00NTgyMzEzMiZzaWc9MmQ5ODJiZWQ0YjA1Y2Q2YjFiYmRkNWEzMDNhYTIyMzk4NTRkZWU1ZTpzZXNzaW9uX2lkPTFfTVg0ME5UZ3lNekV6TW41LU1UUTVNalV6TnpJeE5UVXhNMzVxZWprMFZIUkNTRTgwYTBWSlJFRnVWR0l2ZUVobU5qRi1mZyZjcmVhdGVfdGltZT0xNDkyNTM3ODE1Jm5vbmNlPTAuNDcyODI0NzEzNDQ5MTY4MSZyb2xlPW1vZGVyYXRvciZleHBpcmVfdGltZT0xNDkzMTQyNjE0"

//The token has been generated for Moderator.

class VideoViewController: UIViewController {
    
    @IBOutlet var subscriberView: UIView!
    @IBOutlet var publisherView: UIView!
    lazy var session: OTSession = {
        return OTSession(apiKey: kApiKey, sessionId: kSessionId, delegate: self)!
    }()
    fileprivate var publisher: PublisherManager?
    fileprivate var subscriber: OTSubscriber?
    fileprivate var subscribeToSelf = true
    let captureSession = AVCaptureSession()
    let captureQueue = DispatchQueue(label: "com.tokbox.VideoCapture", attributes: [])
    
    //MARK: Factory Method
    class func viewcontroller() -> VideoViewController {
        return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        doConnect()
    }
    
    fileprivate func doConnect() {
        var error: OTError?
        defer { processError(error) }
        session.connect(withToken: kToken, error: &error)
    }
    
    fileprivate func doPublish() {
        var error: OTError? = nil
        defer { processError(error) }
        publisher = PublisherManager(delegate: self, name: UIDevice.current.name)
        session.publish(publisher!, error: &error)
        publisher!.view.frame = publisherView.frame
        publisherView.addSubview(publisher!.view)
    }
    
    fileprivate func doSubscribe(_ stream: OTStream) {
        var error: OTError?
        defer { processError(error) }
        subscriber = OTSubscriber(stream: stream, delegate: self)
        session.subscribe(subscriber!, error: &error)
    }
    
    fileprivate func cleanupSubscriber() {
        subscriber?.view?.removeFromSuperview()
        subscriber = nil
    }
    
    fileprivate func processError(_ error: OTError?) {
        if let err = error {
            showAlert(errorStr: err.localizedDescription)
        }
    }
    
    fileprivate func showAlert(errorStr err: String) {
        DispatchQueue.main.async {
            let controller = UIAlertController(title: "Error", message: err, preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func videoEndButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - OTSession delegate callbacks
extension VideoViewController: OTSessionDelegate {
    func sessionDidConnect(_ session: OTSession) {
        print("Session connected")
        doPublish()
    }
    
    func sessionDidDisconnect(_ session: OTSession) {
        print("Session disconnected")
    }
    
    func session(_ session: OTSession, streamCreated stream: OTStream) {
        print("Session streamCreated: \(stream.streamId)")
        if subscriber == nil && !subscribeToSelf {
            doSubscribe(stream)
        }
    }
    
    func session(_ session: OTSession, streamDestroyed stream: OTStream) {
        print("Session streamDestroyed: \(stream.streamId)")
        if let subStream = subscriber?.stream, subStream.streamId == stream.streamId {
            cleanupSubscriber()
        }
    }
    
    func session(_ session: OTSession, didFailWithError error: OTError) {
        print("session Failed to connect: \(error.localizedDescription)")
    }
    
}

// MARK: - OTPublisher delegate callbacks
extension VideoViewController: OTPublisherDelegate {
    func publisher(_ publisher: OTPublisherKit, streamCreated stream: OTStream) {
        if subscriber == nil && subscribeToSelf {
            doSubscribe(stream)
        }
    }
    
    func publisher(_ publisher: OTPublisherKit, streamDestroyed stream: OTStream) {
        if let subStream = subscriber?.stream, subStream.streamId == stream.streamId {
            cleanupSubscriber()
        }
    }
    
    func publisher(_ publisher: OTPublisherKit, didFailWithError error: OTError) {
        print("Publisher failed: \(error.localizedDescription)")
    }
    
}

// MARK: - OTSubscriber delegate callbacks
extension VideoViewController: OTSubscriberDelegate {
    func subscriberDidConnect(toStream subscriberKit: OTSubscriberKit) {
        subscriber?.view?.frame = subscriberView.frame
        if let subsView = subscriber?.view {
            subscriberView.addSubview(subsView)
        }
    }
    
    func subscriber(_ subscriber: OTSubscriberKit, didFailWithError error: OTError) {
        print("Subscriber failed: \(error.localizedDescription)")
    }
    
    func subscriberVideoDataReceived(_ subscriber: OTSubscriber) {
    }
}

