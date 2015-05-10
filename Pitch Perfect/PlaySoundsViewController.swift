//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Samuel Doherty on 5/7/15.
//  Copyright (c) 2015 ColombiaIOS. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    // Outlets
    @IBOutlet weak var stopButton: UIButton!
    // Global Variables
    var audioPlayer:AVAudioPlayer!
    var recievedAudio:RecordedAudio!
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    // Setup audio player and engine on load
    override func viewDidLoad() {
        super.viewDidLoad()
        audioPlayer = AVAudioPlayer(contentsOfURL: recievedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: recievedAudio.filePathUrl,  error: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
    }
    
    // Button Actions
    @IBAction func stopPlayback(sender: UIButton) {
        stopAudioAndHide(true)
    }
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playSoundsFast(sender: UIButton) {
        playAudio(2.0)
    }
    
    @IBAction func playSoundsSlowly(sender: UIButton) {
        playAudio(0.5)
    }
    
    // Helper functions
    // Stop audio player and engine.
    func stopAudioAndHide(hide: Bool){
        audioEngine.stop()
        audioPlayer.stop()
        stopButton.hidden = hide
    }
    //Modify pitch and play recorded audio
    func playAudioWithVariablePitch(pitch: Float) {
        stopAudioAndHide(false)
        audioEngine.reset()
        
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
    
    // Modify rate and play recorded audio
    func playAudio(rate: Float) {
        stopAudioAndHide(false)
        audioEngine.reset()
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0
        audioPlayer.play()
    }


}
