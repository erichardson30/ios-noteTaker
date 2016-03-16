//
//  NoteTakerViewController
//  noteTaker
//
//  Created by Richardson, Eric on 3/16/16.
//  Copyright © 2016 Richardson, Eric. All rights reserved.
//

import UIKit
import AVFoundation

class NoteTakerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var audioPlayer = AVAudioPlayer()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel!.text = "The Notes"
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
        audioPlayer = getAudioPlayerFile("StartRecordSound", type: "m4a")
        audioPlayer.play()
    }
}

