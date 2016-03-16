//
//  RecordViewController.swift
//  noteTaker
//
//  Created by Richardson, Eric on 3/16/16.
//  Copyright © 2016 Richardson, Eric. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class RecordViewController: UIViewController {
    
    required init?(coder aDecoder: NSCoder) {
        let baseString : String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as String
        self.audioURL = NSUUID().UUIDString + ".m4a"
        let pathComponents = [baseString, self.audioURL]
        let audioNSURL = NSURL.fileURLWithPathComponents(pathComponents)!
        let session = AVAudioSession.sharedInstance()
        
        let recordSettings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000.0,
            AVNumberOfChannelsKey: 2 as NSNumber,
            AVEncoderAudioQualityKey: AVAudioQuality.High.rawValue
        ]
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            self.audioRecorder = try AVAudioRecorder(URL: audioNSURL, settings: recordSettings)
        } catch let initError as NSError {
            print("Whoops: \(initError.localizedDescription)")
        }
        
        self.audioRecorder.meteringEnabled = true
        self.audioRecorder.prepareToRecord()
        
        super.init(coder: aDecoder)
    }
    
    var audioRecorder: AVAudioRecorder!
    var audioURL: String
    
    @IBOutlet weak var recordOutlet: UIButton!
    @IBOutlet weak var noteTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func save(sender: AnyObject) {
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let note = NSEntityDescription.insertNewObjectForEntityForName("Note", inManagedObjectContext: context) as! Note
        note.name = noteTextField.text!
        note.url = audioURL
        
        do {
            try context.save()
        } catch let saveError as NSError {
            print("Error saving : \(saveError.localizedDescription)")
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func record(sender: AnyObject) {
        if audioRecorder.recording {
            audioRecorder.stop()
        } else {
            let session = AVAudioSession.sharedInstance()
            do {
                try session.setActive(true)
                audioRecorder.record()
            } catch let recordError as NSError {
                print("Recording error: \(recordError.localizedDescription)")
            }
            
        }
    }
    
}