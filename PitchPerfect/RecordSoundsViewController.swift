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

        updateRecordingState(true)
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

        updateRecordingState(false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    
    
    func updateRecordingState(isRecording: Bool){

        recordingLabel.text = isRecording ? "Recording in Progress" : "Tap mic to Record"
        stopRecordingButton.enabled = isRecording ? true : false
        recordButton.enabled =  isRecording ? false : true
        
    }

    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag:  Bool){
 
        if(flag){
            performSegueWithIdentifier("stopRecording", sender: audioRecorder.url)
        }
        else{
            print("Recording failed")
        }
    }
    /*
     // MARK: - Navigation
     

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

