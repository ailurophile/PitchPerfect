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
    @IBAction func recordAudio(_ sender: AnyObject) {

        updateRecordingState(true)
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
//        let pathArray = [dirPath, recordingName]
        let path = dirPath + "/" + recordingName
        let filePath = URL(fileURLWithPath: path)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(url: filePath, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }

    @IBAction func stopRecording(_ sender: AnyObject) {

        updateRecordingState(false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    
    
    func updateRecordingState(_ isRecording: Bool){

        recordingLabel.text = isRecording ? "Recording in Progress" : "Tap mic to Record"
        stopRecordingButton.isEnabled = isRecording ? true : false
        recordButton.isEnabled =  isRecording ? false : true
        
    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag:  Bool){
 
        if(flag){
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
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
        stopRecordingButton.isEnabled = false
        // Do any additional setup after loading the view, typically from a nib.
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}

