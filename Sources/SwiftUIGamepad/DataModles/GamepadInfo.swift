//
//  GamepadInfo.swift
//  ReedWriteCycle (iOS)
//
//  Created by Kevin Mullins on 11/10/22.
//

import Foundation
import SwiftUI
import GameController

/// Provides information about the gamepad device that is currently connected to the device the app is running on.
open class GamePadInfo {
    
    // MARK: - Enumerations
    /// Defines the style of gamepad attached.
    public enum GamepadStyle {
        /// The gamepad style is unknown.
        case unknown
        
        /// The gamepad is a generic extended controller.
        case extendedGamepad
        
        /// The gampad is a Sony PS4/PS5 controller.
        case dualShockGamepad
        
        /// The gamepad is a Microsoft Xbox controller.
        case xboxGamepad
        
        /// The gamepad is a generic extended controller with trigger force feedback.
        case dualSenseGamepad
        
        /// The gamepad is an Apple TV Siri Remote.
        case microGamepad
        
        /// The gamepad is a second generation Apple TV Siri Remote.
        case directionalGamepad
    }
    
    // MARK: - Properties
    /// The vendor's name for the gamepad.
    public var vendorName:String = ""
    
    /// The style of gamepad attached.
    public var style:GamepadStyle = .unknown
    
    /// Returns the main gamepad image.
    public var gamepadImage:String {
        switch style {
        case .extendedGamepad:
            return "ExtendedController"
        case .dualShockGamepad:
            return "PS4_Controller"
        case .dualSenseGamepad:
            return "PS5_Controller"
        case .xboxGamepad:
            return "XB1_Controller"
        case .microGamepad:
            return "SR1_Controller"
        case .directionalGamepad:
            return "SR2_Controller"
        default:
            return "ExtendedController"
        }
    }
    
    /// Returns the left shoulder button image name.
    public var leftShoulderImage:String {
        switch style {
        case .dualShockGamepad, .dualSenseGamepad, .extendedGamepad:
            return "PS4_L1"
        case .xboxGamepad:
            return "XB1_LT"
        default:
            return "XB1_LT"
        }
    }
    
    // Returns the title for the left Shoulder Button
    public var leftShoulderTitle:String {
        return "Left Shoulder Button"
    }
    
    /// Returns the right shoulder button image name.
    public var rightShoulderImage:String {
        switch style {
        case .dualShockGamepad, .dualSenseGamepad, .extendedGamepad:
            return "PS4_R1"
        case .xboxGamepad:
            return "XB1_RT"
        default:
            return "XB1_RT"
        }
    }
    
    // Returns the title for the right Shoulder Button
    public var rightShoulderTitle:String {
        return "Right Shoulder Button"
    }
    
    /// Returns the left trigger image name.
    public var leftTriggerImage:String {
        switch style {
        case .dualShockGamepad, .dualSenseGamepad, .extendedGamepad:
            return "PS4_L2"
        case .xboxGamepad:
            return "XB1_LB"
        default:
            return "XB1_LB"
        }
    }
    
    // Returns the title for the left Trigger
    public var leftTriggerTitle:String {
        return "Left Trigger"
    }
    
    /// Returns the right trigger image name.
    public var rightTriggerImage:String {
        switch style {
        case .dualShockGamepad, .dualSenseGamepad, .extendedGamepad:
            return "PS4_R2"
        case .xboxGamepad:
            return "XB1_RB"
        default:
            return "XB1_RB"
        }
    }
    
    // Returns the title for the left Trigger
    public var rightTriggerTitle:String {
        return "Left Trigger"
    }
    
    /// Returns the menu button image name.
    public var buttonMenuImage:String {
        switch style {
        case .dualShockGamepad, .dualSenseGamepad:
            return "PS4_Options"
        case .xboxGamepad, .extendedGamepad:
            return "XB1_Menu"
        case .microGamepad:
            return "SR1_Menu"
        case .directionalGamepad:
            return "SR2_Menu"
        default:
            return "XB1_Menu"
        }
    }
    
    /// Returns the menu button  name.
    public var buttonMenuTitle:String {
        switch style {
        case .dualShockGamepad, .dualSenseGamepad:
            return "Options Button"
        case .xboxGamepad:
            return "Xbox Button"
        case .directionalGamepad:
            return "< Button"
        default:
            return "Menu Button"
        }
    }
    
    /// Returns the options button image name.
    public var buttonOptionsImage:String {
        switch style {
        case .dualShockGamepad, .dualSenseGamepad:
            return "PS4_Share"
        case .xboxGamepad:
            return "XB1_View"
        default:
            return "XB1_View"
        }
    }
    
    /// Returns the menu options name.
    public var buttonOptionsTitle:String {
        switch style {
        case .dualShockGamepad, .dualSenseGamepad:
            return "Share Button"
        case .xboxGamepad:
            return "View Button"
        default:
            return "Options Button"
        }
    }
    
    /// Returns the Home button image name.
    public var buttonHomeImage:String {
        switch style {
        case .dualShockGamepad, .dualSenseGamepad:
            return "PS4_Home"
        case .xboxGamepad:
            return "XB1_XboxButton"
        default:
            return "XB1_XboxButton"
        }
    }
    
    /// Returns the home button  name.
    public var buttonHomeTitle:String {
        switch style {
        case .dualShockGamepad, .dualSenseGamepad:
            return "PS4 Button"
        case .xboxGamepad:
            return "Xbox Button"
        default:
            return "Home Button"
        }
    }
    
    /// Returns the A button image name.
    public var buttonAImage:String {
        switch style {
        case .dualShockGamepad:
            return "PS4_Cross"
        case .dualSenseGamepad:
            return "PS5_Cross"
        case .xboxGamepad, .extendedGamepad:
            return "XB1_A"
        case .microGamepad:
            return "SR1_A"
        case .directionalGamepad:
            return "SR2_A"
        default:
            return "XB1_A"
        }
    }
    
    /// Returns the A button name.
    public var buttonATitle:String {
        switch style {
        case .dualShockGamepad, .dualSenseGamepad:
            return "Cross Button"
        default:
            return "A Button"
        }
    }
    
    /// Returns the B button image name.
    public var buttonBImage:String {
        switch style {
        case .dualShockGamepad:
            return "PS4_Circle"
        case .dualSenseGamepad:
            return "PS5_Circle"
        case .xboxGamepad, .extendedGamepad:
            return "XB1_B"
        default:
            return "XB1_B"
        }
    }
    
    /// Returns the B button name.
    public var buttonBTitle:String {
        switch style {
        case .dualShockGamepad, .dualSenseGamepad:
            return "Circle Button"
        default:
            return "B Button"
        }
    }
    
    /// Returns the X button image name.
    public var buttonXImage:String {
        switch style {
        case .dualShockGamepad:
            return "PS4_Square"
        case .dualSenseGamepad:
            return "PS5_Square"
        case .xboxGamepad, .extendedGamepad:
            return "XB1_X"
        case .microGamepad:
            return "SR1_X"
        case .directionalGamepad:
            return "SR2_X"
        default:
            return "XB1_X"
        }
    }
    
    /// Returns the X button name.
    public var buttonXTitle:String {
        switch style {
        case .dualShockGamepad, .dualSenseGamepad:
            return "Square Button"
        default:
            return "X Button"
        }
    }
    
    /// Returns the Y button image name.
    public var buttonYImage:String {
        switch style {
        case .dualShockGamepad:
            return "PS4_Triangle"
        case .dualSenseGamepad:
            return "PS5_Triangle"
        case .xboxGamepad, .extendedGamepad:
            return "XB1_Y"
        default:
            return "XB1_Y"
        }
    }
    
    /// Returns the X button name.
    public var buttonYTitle:String {
        switch style {
        case .dualShockGamepad, .dualSenseGamepad:
            return "Triangle Button"
        default:
            return "Y Button"
        }
    }
    
    /// Returns the Dpad image name.
    public var dpadImage:String {
        switch style {
        case .dualShockGamepad:
            return "PS4_DPad"
        case .dualSenseGamepad:
            return "PS5_DPad"
        case .xboxGamepad, .extendedGamepad:
            return "XB1_DPad"
        case .microGamepad:
            return "SR1_DPad"
        case .directionalGamepad:
            return "SR2_DPad"
        default:
            return "XB1_DPad"
        }
    }
    
    /// Returns the Dpad name.
    public var dpadTitle:String {
        return "DPad"
    }
    
    /// Returns the Left Thumbstick image name.
    public var buttonLeftThumbstickImage:String {
        switch style {
        case .dualShockGamepad, .dualSenseGamepad, .extendedGamepad:
            return "PS4_LeftStick"
        case .xboxGamepad:
            return "XB1_LeftStick"
        default:
            return "PS4_LeftStick"
        }
    }
    
    /// Returns the left thumbstick name.
    public var leftThumbstickTitle:String {
        return "Left Thumbstick"
    }
    
    /// Returns the left thumbstick name.
    public var leftThumbstickButtonTitle:String {
        return "Left Thumbstick Button"
    }
    
    /// Returns the Right Thumbstick image name.
    public var buttonRightThumbstickImage:String {
        switch style {
        case .dualShockGamepad, .dualSenseGamepad, .extendedGamepad:
            return "PS4_RightStick"
        case .xboxGamepad:
            return "XB1_RightStick"
        default:
            return "PS4_RightStick"
        }
    }
    
    /// Returns the right thumbstick name.
    public var rightThumbstickTitle:String {
        return "Right Thumbstick"
    }
    
    /// Returns the right thumbstick name.
    public var rightThumbstickButtonTitle:String {
        return "Right Thumbstick Button"
    }
    
    /// Returns the touchpad image name.
    public var touchpadImage:String {
        switch style {
        case .dualShockGamepad, .dualSenseGamepad:
            return "PS4_TouchPad"
        default:
            return ""
        }
    }
    
    /// Returns the touchpad image name.
    public var touchpadTitle:String {
        switch style {
        case .dualShockGamepad, .dualSenseGamepad:
            return "Touchpad Button"
        default:
            return ""
        }
    }
    
    /// Returns the touchpad image name.
    public var touchpadPrimaryTitle:String {
        switch style {
        case .dualShockGamepad, .dualSenseGamepad:
            return "Touchpad One Finger Swipe"
        default:
            return ""
        }
    }
    
    /// Returns the touchpad image name.
    public var touchpadSecondaryTitle:String {
        switch style {
        case .dualShockGamepad, .dualSenseGamepad:
            return "Touchpad Two Finger Swipe"
        default:
            return ""
        }
    }
    
    /// Returns the paddle button 1 image name.
    public var paddleButton1Image:String {
        switch style {
        case .xboxGamepad:
            return "XB1_P1"
        default:
            return ""
        }
    }
    
    /// Returns the paddle button 1 name.
    public var paddleButton1Title:String {
        switch style {
        case .xboxGamepad:
            return "Paddle 1"
        default:
            return ""
        }
    }
    
    /// Returns the paddle button 2 image name.
    public var paddleButton2Image:String {
        switch style {
        case .xboxGamepad:
            return "XB1_P2"
        default:
            return ""
        }
    }
    
    /// Returns the paddle button 2 name.
    public var paddleButton2Title:String {
        switch style {
        case .xboxGamepad:
            return "Paddle 2"
        default:
            return ""
        }
    }
    
    /// Returns the paddle button 3 image name.
    public var paddleButton3Image:String {
        switch style {
        case .xboxGamepad:
            return "XB1_P3"
        default:
            return ""
        }
    }
    
    /// Returns the paddle button 3 name.
    public var paddleButton3Title:String {
        switch style {
        case .xboxGamepad:
            return "Paddle 3"
        default:
            return ""
        }
    }
    
    /// Returns the paddle button 4 image name.
    public var paddleButton4Image:String {
        switch style {
        case .xboxGamepad:
            return "XB1_P4"
        default:
            return ""
        }
    }
    
    /// Returns the paddle button 4 name.
    public var paddleButton4Title:String {
        switch style {
        case .xboxGamepad:
            return "Paddle 4"
        default:
            return ""
        }
    }
    
    /// Returns the share button image name.
    public var buttonShareImage:String {
        switch style {
        case .xboxGamepad:
            return "XB1_Share"
        default:
            return ""
        }
    }
    
    /// Returns the share button name.
    public var buttonShareTitle:String {
        switch style {
        case .xboxGamepad:
            return "Share Button"
        default:
            return ""
        }
    }
    
    // MARK: - Functions
    /// Sets the vendor name from the given optional string value.
    /// - Parameter text: The vendor name.
    public func setVendorName(from text:String?) {
        if let text {
            vendorName = text
        } else {
            vendorName = ""
        }
    }
}
