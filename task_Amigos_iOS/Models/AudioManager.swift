//
//  AudioManager.swift
//  task_Amigos_iOS
//
//  Created by user213023 on 1/22/22.
//

import Foundation
import AVFoundation

class AudioManager: AVAudioRecorderDelegate, AVAudioPlayerDelegate{
    func isEqual(_ object: Any?) -> Bool {
        <#code#>
    }
    
    var hash: Int
    
    var superclass: AnyClass?
    
    func `self`() -> Self {
        <#code#>
    }
    
    func perform(_ aSelector: Selector!) -> Unmanaged<AnyObject>! {
        <#code#>
    }
    
    func perform(_ aSelector: Selector!, with object: Any!) -> Unmanaged<AnyObject>! {
        <#code#>
    }
    
    func perform(_ aSelector: Selector!, with object1: Any!, with object2: Any!) -> Unmanaged<AnyObject>! {
        <#code#>
    }
    
    func isProxy() -> Bool {
        <#code#>
    }
    
    func isKind(of aClass: AnyClass) -> Bool {
        <#code#>
    }
    
    func isMember(of aClass: AnyClass) -> Bool {
        <#code#>
    }
    
    func conforms(to aProtocol: Protocol) -> Bool {
        <#code#>
    }
    
    func responds(to aSelector: Selector!) -> Bool {
        <#code#>
    }
    
    var description: String
    
    
    var name: String
    var player: AVAudioPlayer?
    var recorder: AVAudioRecorder!
    var aplayer: AVAudioPlayer!
    var recordingSession: AVAudioSession!
    
    init(name: String) {
        self.name = name
    }
    //Setter
    public func setName(name: String) -> Void {
        self.name = name
    }
    //Getter
    public func getName() -> String {
        return name
    }
    
    
    
    func record(){
        
    }
    
    func save(){
        
    }
    
    func playAudio(_name: String){
        if let player = player, player.isPlaying{
            //stop playback
            player.stop()
        }
        else{
            //set up player, and play
            let urlString = Bundle.main.path(forResource: name, ofType: ".mp3")
            do{
                try AVAudioSession.sharedInstance().setMode(.default)
                try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
                
                guard let urlString = urlString else{
                    return
                }
                player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlString))
                guard let player = player else{
                    return
                }
                player.play()
            }
            catch {
                print("Something went wrong")
            }
        }
        
    }
    
    func setupRecorder(){
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        
        let audioFilename = documentsDirectory.appendingPathComponent("audioFile.m4a")
        
        let settings = [AVFormatIDKey: Int(kAudioFormatAppleLossless),
             AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
                  AVEncoderBitRateKey: 320000,
                AVNumberOfChannelsKey: 2,
                      AVSampleRateKey: 44100.0] as [String: Any]
        
        var error: NSError?
        
        do{
            recorder = try AVAudioRecorder(url: audioFilename, settings: settings)
        } catch{
            recorder = nil
        }
        
        if let err = error{
            print("AVAudioRecorder error: \(err.localizedDescription)")
        } else{
            recorder.delegate = self
            recorder.prepareToRecord()
        }
        
    }
    
    func preparePlayer(){
        do{
            aplayer = try AVAudioPlayer(contentsOf: getFileURL())
            aplayer.delegate = self
            aplayer.volume = 1.0
        } catch{
            if let err = error as Error?{
                print("AVAudioPlayer error: \(err.localizedDescription)")
                aplayer = nil
            }
        }
    }
    
    func getFileURL() -> URL{
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as URL
        let soundURL = documentDirectory.appendingPathComponent("audioFile.m4a")
        return soundURL
    }
    
}
