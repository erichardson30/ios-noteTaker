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
    let timeInterval: NSTimeInterval = 0.5
    
    @IBOutlet weak var recordOutlet: UIButton!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
    @IBOutlet weak var peakLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressView2: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func save(sender: AnyObject) {
        if noteTextField.text != "" {
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
    @IBAction func touchDownRecord(sender: AnyObject) {
        let timer = NSTimer.scheduledTimerWithTimeInterval(timeInterval, target: self, selector: "updateAudioMeter:", userInfo: nil, repeats: true)
        
        timer.fire()
    }
    
    func updateAudioMeter(timer: NSTimer) {
        if audioRecorder.recording {
            let dFormat = "%02d"
            let min: Int = Int(audioRecorder.currentTime / 60)
            let sec: Int = Int(audioRecorder.currentTime % 60)
            let timeString = "\(String(format: dFormat, min)):\(String(format: dFormat, sec))"
            timeLabel.text = timeString
            
            audioRecorder.updateMeters()
            let averageAudio = audioRecorder.averagePowerForChannel(0) * -1
            let peakAudio = audioRecorder.peakPowerForChannel(0) * -1
            let progressView1Average = Int(averageAudio)
            let progressView2Peak = Int(peakAudio)
            averageLabel.text = ("\(progressView1Average)%")
            peakLabel.text = ("\(progressView2Peak)%")
            bar(progressView1Average, progressBar2: progressView2Peak)
        } else {
            progressView.setProgress(0, animated: true)
            progressView2.setProgress(0, animated: true)
            averageLabel.text = "0%"
            peakLabel.text = "0%"
        }
    }
    
    func bar(progressBar1: Int, progressBar2: Int) {
        switch progressBar1 {
        case 0...2:
            progressView.setProgress(1.00, animated: true)
        case 3...5:
            progressView.setProgress(0.80, animated: true)
        case 6...8:
            progressView.setProgress(0.74, animated: true)
        case 9...11:
            progressView.setProgress(0.70, animated: true)
        case 13...15:
            progressView.setProgress(0.65, animated: true)
        case 16...18:
            progressView.setProgress(0.64, animated: true)
        case 19...21:
            progressView.setProgress(0.63, animated: true)
        case 22...24:
            progressView.setProgress(0.62, animated: true)
        case 25...27:
            progressView.setProgress(0.60, animated: true)
        case 29...31:
            progressView.setProgress(0.55, animated: true)
        case 32...34:
            progressView.setProgress(0.51, animated: true)
        case 35...37:
            progressView.setProgress(0.48, animated: true)
        case 38...40:
            progressView.setProgress(0.45, animated: true)
        case 41...43:
            progressView.setProgress(0.42, animated: true)
        case 44...46:
            progressView.setProgress(0.39, animated: true)
        case 47...49:
            progressView.setProgress(0.36, animated: true)
        case 50...52:
            progressView.setProgress(0.33, animated: true)
        case 53...55:
            progressView.setProgress(0.25, animated: true)
        case 56...60:
            progressView.setProgress(0.24, animated: true)
        case 61...63:
            progressView.setProgress(0.23, animated: true)
        case 64...66:
            progressView.setProgress(0.22, animated: true)
        case 67...69:
            progressView.setProgress(0.21, animated: true)
        case 70...73:
            progressView.setProgress(0.20, animated: true)
        case 74...77:
            progressView.setProgress(0.18, animated: true)
        case 78...81:
            progressView.setProgress(0.17, animated: true)
        case 82...84:
            progressView.setProgress(0.15, animated: true)
        case 85...87:
            progressView.setProgress(0.13, animated: true)
        case 88...91:
            progressView.setProgress(0.10, animated: true)
        case 93...95:
            progressView.setProgress(0.05, animated: true)
        case 96...98:
            progressView.setProgress(0.03, animated: true)
        case 99...100:
            progressView.setProgress(0.00, animated: true)
        default:
            progressView.setProgress(0.20, animated: true)
        }
        
        switch progressBar2 {
        case 0...2:
            progressView2.setProgress(1.00, animated: true)
        case 3...5:
            progressView2.setProgress(0.80, animated: true)
        case 6...8:
            progressView2.setProgress(0.74, animated: true)
        case 9...11:
            progressView2.setProgress(0.70, animated: true)
        case 13...15:
            progressView2.setProgress(0.65, animated: true)
        case 16...18:
            progressView2.setProgress(0.64, animated: true)
        case 19...21:
            progressView2.setProgress(0.63, animated: true)
        case 22...24:
            progressView2.setProgress(0.62, animated: true)
        case 25...27:
            progressView2.setProgress(0.60, animated: true)
        case 29...31:
            progressView2.setProgress(0.55, animated: true)
        case 32...34:
            progressView2.setProgress(0.51, animated: true)
        case 35...37:
            progressView2.setProgress(0.48, animated: true)
        case 38...40:
            progressView2.setProgress(0.45, animated: true)
        case 41...43:
            progressView2.setProgress(0.42, animated: true)
        case 44...46:
            progressView2.setProgress(0.39, animated: true)
        case 47...49:
            progressView2.setProgress(0.36, animated: true)
        case 50...52:
            progressView2.setProgress(0.33, animated: true)
        case 53...55:
            progressView2.setProgress(0.25, animated: true)
        case 56...60:
            progressView2.setProgress(0.24, animated: true)
        case 61...63:
            progressView2.setProgress(0.23, animated: true)
        case 64...66:
            progressView2.setProgress(0.22, animated: true)
        case 67...69:
            progressView2.setProgress(0.21, animated: true)
        case 70...73:
            progressView2.setProgress(0.20, animated: true)
        case 74...77:
            progressView2.setProgress(0.18, animated: true)
        case 78...81:
            progressView2.setProgress(0.17, animated: true)
        case 82...84:
            progressView2.setProgress(0.15, animated: true)
        case 85...87:
            progressView2.setProgress(0.13, animated: true)
        case 88...91:
            progressView2.setProgress(0.10, animated: true)
        case 93...95:
            progressView2.setProgress(0.05, animated: true)
        case 96...98:
            progressView2.setProgress(0.03, animated: true)
        case 99...100:
            progressView2.setProgress(0.00, animated: true)
        default:
            progressView2.setProgress(0.20, animated: true)
        }
        return
    }
    
}