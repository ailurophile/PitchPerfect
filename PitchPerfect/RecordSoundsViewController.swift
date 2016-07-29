//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Lisa Litchfield on 7/12/16.
//  Copyright © 2016 Lisa Litchfield. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    var audioRecorder:AVAudioRecorder!
    

/*
 // MARK: - Recording
 */
    @IBAction func recordAudio(sender: AnyObject) {
        print("record button pressed")
        updateRecordingState(.Recording)
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }

    @IBAction func stopRecording(sender: AnyObject) {
        print("stop recording button pressed")
        updateRecordingState(.NotRecording)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    enum RecordingState: Int { case Recording = 0, NotRecording }
    
    func updateRecordingState(state: RecordingState){
        switch state {
        case .Recording:
            recordingLabel.text = "Recording in Progress"
            stopRecordingButton.enabled = true
            recordButton.enabled = false
        case .NotRecording:
            recordingLabel.text = "Tap to record"
            recordButton.enabled = true
            stopRecordingButton.enabled = false
            
        }
    }

    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag:  Bool){
        print("The audio has finished recording")
        if(flag){
            performSegueWithIdentifier("stopRecording", sender: audioRecorder.url)
        }
        else{
            print("Recording failed")
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.enabled = false
        // Do any additional setup after loading the view, typically from a nib.
    }
    

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC = segue.destinationViewController as! PlaySoundsViewController
            let recordedAudioURL = sender as! NSURL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}

