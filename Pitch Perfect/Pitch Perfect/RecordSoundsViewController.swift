//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Leon Hojegian on 3/10/15.
//  Copyright (c) 2015 Leon Hojegian. All rights reserved.
//

import UIKit
import AVFoundation

var audioRecorder:AVAudioRecorder!
var recordedAudio:RecordedAudio!

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    @IBOutlet var recordButton: UIButton!
    
    override func viewWillAppear(animated: Bool) {
        //ensure that only certain objects are visible
        
        stopButton.hidden = true
        recordButton.enabled = true
        tapToRecord.hidden = false
    }
    
    @IBOutlet var stopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //stop recording and hide labels
    
    @IBAction func stopRecording(sender: UIButton)
    {
            recordingLabel.hidden = true;
            audioRecorder.stop()
            var audioSession = AVAudioSession.sharedInstance();
            audioSession.setActive(false, error: nil)
    }
    
    @IBOutlet var recordingLabel: UILabel!
    
    @IBOutlet var tapToRecord: UILabel!
    
    //record audio
    
    @IBAction func recordAudio(sender: UIButton) {

        println("in recordAudio")
        stopButton.hidden = false;
        if (recordingLabel.hidden) {
            tapToRecord.hidden = true;
            recordingLabel.hidden = false;
        } else {
            recordingLabel.hidden = true;
            tapToRecord.hidden = false;
        }
        recordButton.enabled = false;
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
    
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.record()
        
    }
    
    //prepare for segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as
                PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    //check to see if recording has finished
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag) {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else{
            println("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
}

