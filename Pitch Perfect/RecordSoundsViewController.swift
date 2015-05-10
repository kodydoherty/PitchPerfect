//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Samuel Doherty on 4/27/15.
//  Copyright (c) 2015 ColombiaIOS. All rights reserved.
//

import UIKit
import AVFoundation
class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    //Outlets
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var tapRecordLabel: UILabel!
    
    //Global Variables
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        micButton.enabled = true
        tapRecordLabel.hidden = false
    }

    @IBAction func stopRecording(sender: UIButton) {
        recordLabel.hidden = true
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        stopButton.hidden = true
        tapRecordLabel.hidden = false
    }
    @IBAction func recordAudio(sender: UIButton) {
        stopButton.hidden = false
        recordLabel.hidden = false
        micButton.enabled = false
        tapRecordLabel.hidden = true
        
        //create file path and name for recoreded file by time stamp
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        var currentDateTime = NSDate()
        var formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        var recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        var pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        // Setup audio session
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        // Initialzie and prepare the recorder 
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true;
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        // Perform segue to second view after recording is finished
        if (flag) {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            println("Recording was not successful")
            micButton.enabled = true
            stopButton.hidden = true
    
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // before segue starts send recorded file over to the second view
        if (segue.identifier == "stopRecording") {
            let playSoundVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundVC.recievedAudio = data
        }
    }

}

