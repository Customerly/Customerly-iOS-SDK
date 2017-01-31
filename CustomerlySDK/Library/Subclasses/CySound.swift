
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
        if let bundleURL = podBundle.url(forResource: "notification", withExtension: "m4r"){
            var soundId: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(bundleURL as CFURL, &soundId)
            
            AudioServicesAddSystemSoundCompletion(soundId, nil, nil, { (soundId, clientData) -> Void in
                AudioServicesDisposeSystemSoundID(soundId)
            }, nil)
            
            AudioServicesPlaySystemSound(soundId)
        }
    }
}
