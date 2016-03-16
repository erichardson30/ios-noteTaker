//
//  NoteTakerViewController
//  noteTaker
//
//  Created by Richardson, Eric on 3/16/16.
//  Copyright © 2016 Richardson, Eric. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class NoteTakerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var notesArray: [Note] = []
    
    var audioPlayer = AVAudioPlayer()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let request = NSFetchRequest(entityName: "Note")
        self.notesArray = (try! context.executeFetchRequest(request)) as! [Note]
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let sound = notesArray[indexPath.row]
        cell.textLabel!.text = sound.name
        return cell;
    }
    
    func getAudioPlayerFile(file: String, type:String) -> AVAudioPlayer {
        let path = NSBundle.mainBundle().pathForResource("SampleAudio", ofType: "mp3")
        let url = NSURL.fileURLWithPath(path!)
        var audioPlayer:AVAudioPlayer?
        
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: url)
        } catch let audioPlayerError as NSError {
            print("Failed to find the file: \(audioPlayerError.localizedDescription)")
        }
        
        return audioPlayer!
    }

    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
//        audioPlayer = getAudioPlayerFile("StartRecordSound", type: "m4a")
//        audioPlayer.play()
        
        let sound = notesArray[indexPath.row]
        let baseString : String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as String
        let pathComponents = [baseString, sound.url!]
        let audioNSURL = NSURL.fileURLWithPathComponents(pathComponents)!
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback)
            self.audioPlayer = try AVAudioPlayer(contentsOfURL: audioNSURL)
        } catch let fetchError as NSError {
            print("Fetch Error : \(fetchError.localizedDescription)")
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

