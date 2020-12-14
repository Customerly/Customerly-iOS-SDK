
//
//  CySound.swift
//  Customerly

import AudioToolbox

open class CySound: NSObject {
    
    public static func playNotification(){
        if let url = CyBundle.getBundle().url(forResource: "notification", withExtension: "m4r"){
            CySound.playSoundFromFile(url: url)
            return
        }
    }
    
    public static func playSoundFromFile(url: URL){
        var soundId: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(url as CFURL, &soundId)
        
        AudioServicesAddSystemSoundCompletion(soundId, nil, nil, { (soundId, clientData) -> Void in
            AudioServicesDisposeSystemSoundID(soundId)
        }, nil)
        
        AudioServicesPlaySystemSound(soundId)
    }
}
