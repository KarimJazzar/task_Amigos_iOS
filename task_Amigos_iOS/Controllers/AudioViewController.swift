//
//  AudioViewController.swift
//  task_Amigos_iOS
//
//  Created by Daniel Miolan on 1/28/22.
//

import UIKit
import AVFoundation

class AudioViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {

    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    var soundPlayer: AVAudioPlayer!
    var soundRecorder: AVAudioRecorder!
    var audioName: String = ""
    var tempAudioName: String = "audio.m4a"
    var isRecoding: Bool = false
    var isPlaying: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
             if granted {
                 self.setupRecorder()
             } else{
                 self.playBtn.isEnabled = false
                 self.recordBtn.isEnabled = false
                 self.playBtn.backgroundColor = .lightGray
                 self.recordBtn.backgroundColor = .lightGray
                 AlertHelper.showModal(view: self, type: .error, msg: "Mic access denied.")
             }
        })
        
    }
    
    @IBAction func performRecord(_ sender: UIButton) {
        isRecoding = !isRecoding
        
        if isRecoding {
            playBtn.isEnabled = false
            playBtn.backgroundColor = .lightGray
            sender.setTitle("Stop", for: .normal)
            sender.backgroundColor = .systemRed
            soundRecorder.record()
        } else {
            playBtn.isEnabled = true
            playBtn.backgroundColor = .systemBlue
            sender.setTitle("Record", for: .normal)
            sender.backgroundColor = .systemBlue
            soundRecorder.stop()
        }
    }
    
    @IBAction func performPlay(_ sender: UIButton) {
        isPlaying = !isPlaying
        
        if isPlaying {
            recordBtn.isEnabled = false
            recordBtn.backgroundColor = .lightGray
            sender.setTitle("Stop", for: .normal)
            sender.backgroundColor = .systemRed
            setupPlayer()
            soundPlayer.play()
        } else {
            recordBtn.isEnabled = true
            recordBtn.backgroundColor = .systemBlue
            sender.setTitle("Play", for: .normal)
            sender.backgroundColor = .systemBlue
            soundPlayer.pause()
        }
    }
    
    @IBAction func performSave(_ sender: Any) {
        
    }
    
    @IBAction func performDelete(_ sender: Any) {
        
    }
    
    func setAudioName(name: String) {
        audioName = name
    }
    
    private func getDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
    
    private func setupRecorder() {
        let audio = getDirectory().appendingPathComponent(tempAudioName)
        
        let settings = [
            AVFormatIDKey: kAudioFormatAppleLossless,
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
            AVEncoderBitRateKey: 320000,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey: 44100.2
        ] as [String: Any]
        
        do {
            soundRecorder = try AVAudioRecorder(url: audio, settings: settings)
            soundRecorder.delegate = self
            soundRecorder.prepareToRecord()
        } catch {
            
        }
    }
    
    private func setupPlayer() {
        let audio = getDirectory().appendingPathComponent(tempAudioName)
        
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: audio)
            soundPlayer.delegate = self
            soundPlayer.prepareToPlay()
            soundPlayer.volume = 1.0
            
            print("\(audio)")
            let data = try AVAudioPlayer(contentsOf: audio).data
            try data?.write(to: audio)
            //soundPlayer.play()
        } catch {
            
        }
    }
}
