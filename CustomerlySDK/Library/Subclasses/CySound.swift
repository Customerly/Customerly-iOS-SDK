
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
        
        let podBundle = Bundle(for: Customerly.classForCoder())
        
        if let bundleURL = podBundle.url(forResource: "CustomerlySDK", withExtension: "bundle"){
            
            if let bundle = Bundle(url: bundleURL) {
                if let url = bundle.url(forResource: "notification", withExtension: "m4r"){
                    CySound.playSoundFromFile(url: url)
                    return
                }
            }
            else {
                assertionFailure("Could not load the bundle")
            }
            
        }
        
        if let bundleURL = podBundle.url(forResource: "notification", withExtension: "m4r"){
            CySound.playSoundFromFile(url: bundleURL)
        }
        
        return
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
