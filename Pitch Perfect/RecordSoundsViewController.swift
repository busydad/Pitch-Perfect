//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Per Dalsgaard on 09/06/15.
//  Copyright (c) 2015 Per Dalsgaard. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordingInProgressLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        recordingInProgressLabel.text = "Tap to record"
        stopButton.hidden = true
    }
    
    // MARK: - IBActions

    @IBAction func recordAudio(sender: UIButton) {
        if audioRecorder == nil {
            // Record button pressed for the first time
            recordingInProgressLabel.text = "Recording… Tap to pause recording"
            stopButton.hidden = false
            
            // Set filepath
            let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
            let recordingName = "my_audio.wav"
            let pathArray = [dirPath, recordingName]
            let filePath = NSURL.fileURLWithPathComponents(pathArray)
            
            var session = AVAudioSession.sharedInstance()
            session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
            
            // Instantiate and initialize audioRecorder
            audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
            audioRecorder.prepareToRecord()
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            audioRecorder.record()
            } else {
                // Record button not pressed for the first time
                if audioRecorder.recording {
                    audioRecorder.pause()
                    recordingInProgressLabel.text = "Paused… Tap to resume recording"
                } else {
                    audioRecorder.record()
                    recordingInProgressLabel.text = "Recording… Tap to pause recording"
                }
            }
    }

    @IBAction func stopAudio(sender: UIButton) {
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil);
    }
    
    // MARK: - AVAudioRecorderDelegate
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if flag {
            let recordedAudio = RecordedAudio(url: recorder.url)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stopRecording" {
            let playSoundVC = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundVC.receivedAudio = data
            audioRecorder = nil;
        }
    }

    
}

