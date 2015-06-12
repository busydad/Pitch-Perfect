//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Per Dalsgaard on 11/06/15.
//  Copyright (c) 2015 Per Dalsgaard. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    @IBOutlet weak var stopButton: UIButton!
    
    var audioPlayer: AVAudioPlayer!
    var audioEngine: AVAudioEngine!
    var audioFile:AVAudioFile!
    var receivedAudio:RecordedAudio!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "Play"
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
       
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }
    
    func stopAudioPlayerAndEngine() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func playAudioWithRate(rate: Float) {
        stopAudioPlayerAndEngine()
        
        stopButton.hidden = false
        
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }

    func playAudioWithPitch(pitch: Float) {
        stopAudioPlayerAndEngine()
        
        stopButton.hidden = false
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    // MARK: - IBActions
    
    @IBAction func playSlowAudio(sender: UIButton) {
        playAudioWithRate(0.5)
    }

    @IBAction func playFastAudio(sender: UIButton) {
        playAudioWithRate(1.5)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithPitch(1000);
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithPitch(-1000);
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        stopAudioPlayerAndEngine()
    }
   
    
}
