//
//  File.swift
//  
//
//  Created by Kevin Mullins on 12/15/23.
//

import Foundation
import SwiftletUtilities

/// Gamepad specific extensions to the `HardwareInfomation` class.
extension HardwareInformation {
    /// Returns the padding that is used on the Tips pages based on the given device.
    public static var tipPaddingVertical:Int {
        switch HardwareInformation.screenHeight {
        case 667, 736:
            return 200
        default:
            return 300
        }
    }
}
