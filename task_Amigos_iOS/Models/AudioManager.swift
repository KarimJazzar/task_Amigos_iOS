//
//  AudioManager.swift
//  task_Amigos_iOS
//
//  Created by user213023 on 1/22/22.
//

import Foundation
import AVFoundation

class AudioManager{
    
    private var name: String
    var player: AVAudioPlayer?
    
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
    
}
