//
//  GamepadEventHandlers.swift
//  ReedWriteCycle
//
//  Created by Kevin Mullins on 3/23/23.
//

import Foundation
import SwiftUI
import GameController

/// This object holds the collection of event handlers and settings for a given SwiftUI `View` that allows that view to respond to the events on the gamepad.
public class GamepadEventHandlers {
    
    // MARK: - Properties
    /// The unique View ID that this collection of event handlers belongs to.
    public var attachedViewID:String = ""
    
    /// The handler for the gamepad connected event.
    public var gamepadConnected: View.gamepadStatusHandler? = nil
    
    /// The handler for the gamepad disconnected event.
    public var gamepadDisconnected: View.gamepadStatusHandler? = nil
    
    /// The handler for the gamepad app becoming active.
    public var gamepadAppIsActive: View.gamepadAppEvent? = nil
    
    /// The handler for the gamepad app becoming inactive.
    public var gamepadAppIsInactive: View.gamepadAppEvent? = nil
    
    /// The handler for the gamepad app switching to the background.
    public var gamepadAppInBackground: View.gamepadAppEvent? = nil
    
    /// The handler for the gamepad left shoulder button event.
    public var leftShoulderHandler: View.gamepadTriggerHandler? = nil
    
    /// The mode that the left shoulder button operates in.
    public var leftShoulderMode: GamepadManager.TriggerMode = .analog
    
    /// The usage description for the left shoulder button.
    public var leftShoulderUsage:String = ""
    
    /// The handler for the gamepad right shoulder button event.
    public var rightShoulderHandler: View.gamepadTriggerHandler? = nil
    
    /// The mode that the right shoulder button opperates in.
    public var rightShoulderMode: GamepadManager.TriggerMode = .analog
    
    /// The usage description for the right shoulder button.
    public var rightShoulderUsage:String = ""
    
    /// The handler for the gamepad left trigger event.
    public var leftTriggerHandler: View.gamepadTriggerHandler? = nil
    
    /// The mode that the left trigger operates in.
    public var leftTriggerMode: GamepadManager.TriggerMode = .analog
    
    /// The usage description for the left trigger button.
    public var leftTriggerUsage:String = ""
    
    /// The handler for the gamepad right trigger event.
    public var rightTriggerHandler: View.gamepadTriggerHandler? = nil
    
    /// The mode that the right trigger operates in.
    public var rightTriggerMode: GamepadManager.TriggerMode = .analog
    
    /// The usage description for the right trigger button.
    public var rightTriggerUsage:String = ""
    
    /// The handler for the gamepad menu button event.
    public var buttonMenu: View.gamepadButtonHandler? = nil
    
    /// The mode that button menu operates in.
    public var buttonMenuMode: GamepadManager.ButtonMode = .stateChanged
    
    /// The usage description for the menu button.
    public var buttonMenuUsage:String = ""
    
    /// The handler for the gamepad options button event.
    public var buttonOptions: View.gamepadButtonHandler? = nil
    
    /// The mode that button options operates in.
    public var buttonOptionsMode: GamepadManager.ButtonMode = .stateChanged
    
    /// The usage description for the options button.
    public var buttonOptionsUsage:String = ""
    
    /// The handler for the gamepad home button event.
    public var buttonHome: View.gamepadButtonHandler? = nil
    
    /// The mode that button home operates in.
    public var buttonHomeMode: GamepadManager.ButtonMode = .stateChanged
    
    /// The usage description for the home button.
    public var buttonHomeUsage:String = ""
    
    /// The handler for the gamepad A button event.
    public var buttonA: View.gamepadButtonHandler? = nil
    
    /// The mode that button A operates in.
    public var buttonAMode: GamepadManager.ButtonMode = .stateChanged
    
    /// The usage description for the A button.
    public var buttonAUsage:String = ""
    
    /// The handler for the gamepad B button event.
    public var buttonB: View.gamepadButtonHandler? = nil
    
    /// The mode that button B operates in.
    public var buttonBMode: GamepadManager.ButtonMode = .stateChanged
    
    /// The usage description for the B button.
    public var buttonBUsage:String = ""
    
    /// The handler for the gamepad X button event.
    public var buttonX: View.gamepadButtonHandler? = nil
    
    /// The mode that button X operates in.
    public var buttonXMode: GamepadManager.ButtonMode = .stateChanged
    
    /// The usage description for the X button.
    public var buttonXUsage:String = ""
    
    /// The handler for the gamepad Y button event.
    public var buttonY: View.gamepadButtonHandler? = nil
    
    /// The mode that button Y operates in.
    public var buttonYMode: GamepadManager.ButtonMode = .stateChanged
    
    /// The usage description for the Y button.
    public var buttonYUsage:String = ""
    
    /// The handler for the gamepad dpad event.
    public var dpad: View.gamepadDirectionHandler? = nil
    
    /// The mode that the dpad operates in.
    public var dpadMode: GamepadManager.ButtonMode = .stateChanged
    
    /// The usage description for the Dpad.
    public var dpadUsage:String = ""
    
    /// The handler for the gamepad left thumbstick event.
    public var leftThumbstick: View.gamepadDirectionHandler? = nil
    
    /// Determines the mode of operation for the left thumbstick
    public var leftThumbstickMode: GamepadManager.ThumbstickMode = .analog
    
    /// The usage description for the left thumbstick.
    public var leftThumbstickUsage:String = ""
    
    /// The handler for the gamepad right thumbstick event.
    public var rightThumbstick: View.gamepadDirectionHandler? = nil
    
    /// Determines the mode of operation for the right thumbstick
    public var rightThumbstickMode: GamepadManager.ThumbstickMode = .analog
    
    /// The usage description for the right thumbstick.
    public var rightThumbstickUsage:String = ""
    
    /// The handler for the gamepad left thumbstick button event.
    public var leftThumbstickButton: View.gamepadButtonHandler? = nil
    
    /// The mode that the left thumbstick button operates in.
    public var leftThumbstickButtonMode: GamepadManager.ButtonMode = .stateChanged
    
    /// The usage description for the left thumbstick Button.
    public var leftThumbstickButtonUsage:String = ""
    
    /// The handler for the gamepad right thumbstick button event.
    public var rightThumbstickButton: View.gamepadButtonHandler? = nil
    
    /// The mode that the right thumbstick button operates in.
    public var rightThumbstickButtonMode: GamepadManager.ButtonMode = .stateChanged
    
    /// The usage description for the right thumbstick Button.
    public var rightThumbstickButtonUsage:String = ""
    
    // !!!: Sony Dual Shock specific controls.
    /// The handler for the gamepad touchpad button event.
    public var touchpadButton: View.gamepadButtonHandler? = nil
    
    /// The usage description for the touchpad Button.
    public var touchpadButtonUsage:String = ""
    
    /// The handler for the gamepad touchpad one finger event.
    public var touchpadPrimary: View.gamepadDirectionHandler? = nil
    
    /// The usage description for the touchpad primary.
    public var touchpadPrimaryUsage:String = ""
    
    /// The handler for the gamepad touchpad two finger event.
    public var touchpadSecondary: View.gamepadDirectionHandler? = nil
    
    /// The usage description for the touchpad secondary.
    public var touchpadSecondaryUsage:String = ""
    
    // !!!: Xbox controller specific controls.
    /// The handler for the gamepad paddle button 1 event.
    public var paddleButton1: View.gamepadButtonHandler? = nil
    
    /// The usage description for the paddle 1 Button.
    public var paddleButton1Usage:String = ""
    
    /// The handler for the gamepad paddle button 2 event.
    public var paddleButton2: View.gamepadButtonHandler? = nil
    
    /// The usage description for the paddle 2 Button.
    public var paddleButton2Usage:String = ""
    
    /// The handler for the gamepad paddle button 3 event.
    public var paddleButton3: View.gamepadButtonHandler? = nil
    
    /// The usage description for the paddle 3 Button.
    public var paddleButton3Usage:String = ""
    
    /// The handler for the gamepad paddle button 4 event.
    public var paddleButton4: View.gamepadButtonHandler? = nil
    
    /// The usage description for the paddle 4 Button.
    public var paddleButton4Usage:String = ""
    
    /// The handler for the gamepadshare button event.
    public var buttonShare: View.gamepadButtonHandler? = nil
    
    /// The usage description for the share Button.
    public var buttonShareUsage:String = ""
    
    // MARK: - Initializers
    /// Creates a new instance.
    /// - Parameter attachedViewID: The unique ID of the view that this handler is attached to.
    init(attachedViewID: String) {
        self.attachedViewID = attachedViewID
    }
    
    // MARK: - Functions
    /// Releases all of the event handlers to free up memory.
    public func releaseHandlers() {
        gamepadConnected = nil
        gamepadDisconnected = nil
        
        gamepadAppIsActive = nil
        gamepadAppIsInactive = nil
        gamepadAppInBackground = nil
        
        leftShoulderHandler = nil
        leftShoulderUsage = ""
        
        rightShoulderHandler = nil
        rightShoulderUsage = ""
        
        leftTriggerHandler = nil
        leftTriggerUsage = ""
        
        rightTriggerHandler = nil
        rightTriggerUsage = ""
        
        buttonMenu = nil
        buttonMenuUsage = ""
        
        buttonOptions = nil
        buttonOptionsUsage = ""
        
        buttonHome = nil
        buttonHomeUsage = ""
        
        buttonA = nil
        buttonAUsage = ""
        
        buttonB = nil
        buttonBUsage = ""
        
        buttonX = nil
        buttonXUsage = ""
        
        buttonY = nil
        buttonYUsage = ""
        
        dpad = nil
        dpadUsage = ""
        
        leftThumbstick = nil
        leftThumbstickUsage = ""
        
        rightThumbstick = nil
        rightThumbstickUsage = ""
        
        leftThumbstickButton = nil
        leftThumbstickButtonUsage = ""
        
        rightThumbstickButton = nil
        rightThumbstickButtonUsage = ""
        
        touchpadButton = nil
        touchpadButtonUsage = ""
        
        touchpadPrimary = nil
        touchpadPrimaryUsage = ""
        
        touchpadSecondary = nil
        touchpadSecondaryUsage = ""
        
        paddleButton1 = nil
        paddleButton1Usage = ""
        
        paddleButton2 = nil
        paddleButton2Usage = ""
        
        paddleButton3 = nil
        paddleButton3Usage = ""
        
        paddleButton4 = nil
        paddleButton4Usage = ""
        
        buttonShare = nil
        buttonShareUsage = ""
    }
}
