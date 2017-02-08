
//
//  CySound.swift
//  Customerly
//
//  Created by Paolo Musolino on 31/01/17.
//  Copyright © 2017 Customerly. All rights reserved.
//

import AudioToolbox

class CySound: NSObject {
    
    static func playNotification(){
        if let url = CyBundle.getBundle().url(forResource: "notification", withExtension: "m4r"){
            CySound.playSoundFromFile(url: url)
            return
        }
    }
    
    static func playSoundFromFile(url: URL){
        var soundId: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(url as CFURL, &soundId)
        
        AudioServicesAddSystemSoundCompletion(soundId, nil, nil, { (soundId, clientData) -> Void in
            AudioServicesDisposeSystemSoundID(soundId)
        }, nil)
        
        AudioServicesPlaySystemSound(soundId)
    }
}
