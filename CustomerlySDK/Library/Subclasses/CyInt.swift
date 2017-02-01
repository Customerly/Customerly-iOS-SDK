//
//  CyInt.swift
//  Customerly
//
//  Created by Paolo Musolino on 01/02/17.
//  Copyright © 2017 Customerly. All rights reserved.
//

import UIKit

extension UInt32 {
    init?(hexString: String) {
        let scanner = Scanner(string: hexString)
        var hexInt = UInt32.min
        let success = scanner.scanHexInt32(&hexInt)
        if success {
            self = hexInt
        } else {
            return nil
        }
    }
}
