//
//  GamepadMovementDirection.swift
//  ReedWriteCycle (iOS)
//
//  Created by Kevin Mullins on 11/9/22.
//

import Foundation
import SwiftUI
import GameController

/// Takes the `xAxis` and `yAxis` of a gamepad Dpad or Thumbstick and translates them into up, down, left or right movement. If there is no movement, `none` will be returns.
public enum GamepadMovementDirection {
    // MARK: - Values
    /// The user isn't moving the Dpad or Thumbstick.
    case none
    
    /// The user is moving the Dpad or Thumbstick in the up direction.
    case up
    
    /// The user is moving the Dpad or Thumbstick in the down direction.
    case down
    
    /// The user is moving the Dpad or Thumbstick in the left direction.
    case left
    
    /// The user is moving the Dpad or Thumbstick in the right direction.
    case right
    
    // MARK: - Static Functions
    /// A convenience function that translates gamepad direction information (such as from the Dpad) into general movement directions: up, down, left, right.
    /// - Parameters:
    ///   - x: The X axis movement amount.
    ///   - y: The Y axis movement amount.
    /// - Returns: Returns the `GamepadMovementDirection` for the given axis movement amounts.
    public static func moving(x:Float, y:Float) -> GamepadMovementDirection {
        
        if x > 0 {
            return .right
        } else if x < 0 {
            return .left
        } else if y > 0 {
            return .up
        } else if y < 0 {
            return .down
        }
        
        return .none
    }
}
