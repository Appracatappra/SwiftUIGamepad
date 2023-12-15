//
//  GamepadManager.swift
//  ReedWriteCycle (iOS)
//
//  Created by Kevin Mullins on 11/9/22.
//

import Foundation
import SwiftUI
import GameController
import SwiftletUtilities
import LogManager

/// Provides static variable storage for a gamepad attached to a SwiftUI `View`.
open class GamepadManager {
    
    // MARK: - Enumerations
    /// Defines how the gamepad's thumbsticks behave.
    public enum ThumbstickMode {
        /// In `analog` mode the thumbstick will send a direct reading on the thumbstick's position once.
        case analog
        
        /// In `directional` mode the thumbstick will continously send how fast the user wants to move in a given direction based on the amount of pressure that the user is applying to the thumbstick.
        case directional
    }
    
    /// Defines how the gamepad's button behave.
    public enum ButtonMode {
        /// If the Dpad's mode is `stateChanged`, then the `View` will only be notified if presses or releases a direction button on the Dpad.
        case stateChanged
        
        /// If the Dpad's mode is `continous`, then the `View` will be notified as long as the user is pressing a direction button on the Dpad.
        case continous
    }
    
    /// Defines how the gamepad's triggers behave.
    public enum TriggerMode {
        /// In `analog` mode the trigger will send a direct reading on the trigger's position once.
        case analog
        
        /// In `continous` mode the trigger will send a continous pressure reading until the user releases the trigger.
        case continous
    }
    
    // MARK: - Static Properties
    /// The shared values for the first attached gamepad.
    public static var gamepadOne:GamepadManager = GamepadManager()
    
    /// Returns the first gamepad that is attached to the device.
    public static var controller:GCController? {
        let controllers = GCController.controllers()
        if controllers.count > 0 {
            return controllers[0]
        } else {
            return nil
        }
    }
    
    /// Returns the manufacturer's name for the attached gamepad.
    public static var gamepadName:String {
        if let controller {
            if let name = controller.vendorName {
                return name
            }
        }
        
        return "Gamepad"
    }
    
    /// Returns the gamepad's product category.
    public static var gamepadProductCategory:String {
        if let controller {
            return controller.productCategory
        }
        
        return "Gamepad"
    }
    
    /// Returns `true` if the gamepad supports haptics, else returns `false`.
    public static var gamepadSupportsHaptics:Bool {
        if let controller {
            return controller.haptics != nil
        }
        
        return false
    }
    
    /// Returns the gamepad's battery level.
    public static var gampadBatteryLevel:Float {
        if let controller {
            if let battery = controller.battery {
                return battery.batteryLevel
            }
        }
        
        // Return -1 if unable to get battery level
        return -1.0
    }
    
    /// Returns `true` if the gamepad is currently charging, else return `false`.
    public static var gamepadIsBatteryCharging: Bool {
        if let controller {
            if let battery = controller.battery {
                return (battery.batteryState == .charging)
            }
        }
        
        return false
    }
    
    /// If `true` this app supports using the Apple TV Remote as a mini gamepad.
    public static var supportsMicroGamepad:Bool = false
    
    /// If `true` this app supports using virtual gamepads.
    public static var supportsVirtualGamepad:Bool = false
    
    // !!!: Continous properties
    /// If `true`, the user is pressing the left shoulder button.
    private static var leftShoulderPressed: Bool = false
    
    /// The amoun of pressure the user is applying to the left shoulder button
    private static var leftShoulderPressure: Float = 0.0
    
    /// If `true`, the user is pressing the right shoulder button.
    private static var rightShoulderPressed: Bool = false
    
    /// The amoun of pressure the user is applying to the right shoulder button
    private static var rightShoulderPressure: Float = 0.0
    
    /// If `true`, the user is pressing the left trigger.
    private static var leftTriggerPressed: Bool = false
    
    /// The amoun of pressure the user is applying to the left trigger
    private static var leftTriggerPressure: Float = 0.0
    
    /// If `true`, the user is pressing the right trigger.
    private static var rightTriggerPressed: Bool = false
    
    /// The amoun of pressure the user is applying to the right trigger
    private static var rightTriggerPressure: Float = 0.0
    
    /// If `true`, the user is pressing button menu.
    private static var buttonMenuPressed: Bool = false
    
    /// If `true`, the user is pressing button options.
    private static var buttonOptionsPressed: Bool = false
    
    /// If `true`, the user is pressing button home.
    private static var buttonHomePressed: Bool = false
    
    /// If `true`, the user is pressing button A.
    private static var buttonAPressed: Bool = false
    
    /// If `true`, the user is pressing button B.
    private static var buttonBPressed: Bool = false
    
    /// If `true`, the user is pressing button X.
    private static var buttonXPressed: Bool = false
    
    /// If `true`, the user is pressing button Y.
    private static var buttonYPressed: Bool = false
    
    /// If `true` the left thumbstick in being moved by the user.
    private static var leftThumbstickMoving: Bool = false
    
    /// The amount of pressure the user is applying to the left thumbstick in the X axis.
    private static var leftThumbstickXAxis: Float = 0.0
    
    /// The amount of pressure the user is applying to the left thumbstick in the Y axis.
    private static var leftThumbstickYAxis: Float = 0.0
    
    /// If `true`, the user is pressing left thumbstick button.
    private static var leftThumbstickButtonPressed: Bool = false
    
    /// If `true` the right thumbstick in being moved by the user.
    private static var rightThumbstickMoving: Bool = false
    
    /// The amount of pressure the user is applying to the right thumbstick in the X axis.
    private static var rightThumbstickXAxis: Float = 0.0
    
    /// The amount of pressure the user is applying to the right thumbstick in the Y axis.
    private static var rightThumbstickYAxis: Float = 0.0
    
    /// If `true`, the user is pressing right thumbstick button.
    private static var rightThumbstickButtonPressed: Bool = false
    
    /// If `true` the Dpad in being pressed by the user.
    private static var dpadMoving: Bool = false
    
    /// The Dpad direction in the X axis.
    private static var dpadXAxis: Float = 0.0
    
    /// The Dpad direction in the Y axis.
    private static var dpadYAxis: Float = 0.0
    
    /// A private timer that handles any of the gamepads controls being operated in the continous mode.
    private static var eventTimer: Timer = Timer()
    
    // !!!: Control debounce handling
    /// If `true` the left shoulder button's state has changed, else returns `false`.
    private static var leftShoulderChanged: Bool = false
    
    /// If `true` the right shoulder button's state has changed, else returns `false`.
    private static var rightShoulderChanged: Bool = false
    
    /// If `true` the left trigger button's state has changed, else returns `false`.
    private static var leftTriggerChanged: Bool = false
    
    /// If `true` the right trigger button's state has changed, else returns `false`.
    private static var rightTriggerChanged: Bool = false
    
    /// If `true` the home button's state has changed, else returns `false`.
    private static var buttonHomeChanged: Bool = false
    
    /// If `true` the options button's state has changed, else returns `false`.
    private static var buttonOptionsChanged: Bool = false
    
    /// If `true` the menu button's state has changed, else returns `false`.
    private static var buttonMenuChanged: Bool = false
    
    /// If `true` the A button's state has changed, else returns `false`.
    private static var buttonAChanged: Bool = false
    
    /// If `true` the B button's state has changed, else returns `false`.
    private static var buttonBChanged: Bool = false
    
    /// If `true` the X button's state has changed, else returns `false`.
    private static var buttonXChanged: Bool = false
    
    /// If `true` the Y button's state has changed, else returns `false`.
    private static var buttonYChanged: Bool = false
    
    /// If `true` the dpad button's state has changed, else returns `false`.
    private static var dpadChanged: Bool = false
    
    /// If `true` the left thumbstick button's state has changed, else returns `false`.
    private static var leftThumbstickButtonChanged: Bool = false
    
    /// If `true` the right thumbstick button's state has changed, else returns `false`.
    private static var rightThumbstickButtonChanged: Bool = false
    
    // MARK: - Static Functions
    /// This function needs to be called on the the app first starts and becomes active. When a gamepad is connected, the `.onGamepadConnected()` event will be raised on any `View` connected to the `GamepadManager`.
    ///
    /// - Remark: **WARNING!** Don't forget to call the `stopWatchingForGamepads()` function when the app goes inactive to release event monitoring and memory that the gamepad connection is consuming.
    public static func startWatchingForGamepads() {
        
        // Start event timer
        Execute.onMain {
            GamepadManager.eventTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                if GamepadManager.leftShoulderPressed {
                    if let handler = GamepadManager.gamepadOne.leftShoulderHandler {
                        handler(true, GamepadManager.leftShoulderPressure)
                    }
                }
                
                if GamepadManager.rightShoulderPressed {
                    if let handler = GamepadManager.gamepadOne.rightShoulderHandler {
                        handler(true, GamepadManager.rightShoulderPressure)
                    }
                }
                
                if GamepadManager.leftTriggerPressed {
                    if let handler = GamepadManager.gamepadOne.leftTriggerHandler {
                        handler(true, GamepadManager.leftTriggerPressure)
                    }
                }
                
                if GamepadManager.rightTriggerPressed {
                    if let handler = GamepadManager.gamepadOne.rightTriggerHandler {
                        handler(true, GamepadManager.rightTriggerPressure)
                    }
                }
                
                if GamepadManager.buttonMenuPressed {
                    if let handler = GamepadManager.gamepadOne.buttonMenu {
                        handler(true)
                    }
                }
                
                if GamepadManager.buttonOptionsPressed {
                    if let handler = GamepadManager.gamepadOne.buttonOptions {
                        handler(true)
                    }
                }
                
                if GamepadManager.buttonHomePressed {
                    if let handler = GamepadManager.gamepadOne.buttonHome {
                        handler(true)
                    }
                }
                
                if GamepadManager.buttonAPressed {
                    if let handler = GamepadManager.gamepadOne.buttonA {
                        handler(true)
                    }
                }
                
                if GamepadManager.buttonBPressed {
                    if let handler = GamepadManager.gamepadOne.buttonB {
                        handler(true)
                    }
                }
                
                if GamepadManager.buttonXPressed {
                    if let handler = GamepadManager.gamepadOne.buttonX {
                        handler(true)
                    }
                }
                
                if GamepadManager.buttonYPressed {
                    if let handler = GamepadManager.gamepadOne.buttonY {
                        handler(true)
                    }
                }
                
                if GamepadManager.leftThumbstickMoving {
                    if let handler = GamepadManager.gamepadOne.leftThumbstick {
                        handler(GamepadManager.leftThumbstickXAxis, GamepadManager.leftThumbstickYAxis)
                    }
                }
                
                if GamepadManager.leftThumbstickButtonPressed {
                    if let handler = GamepadManager.gamepadOne.leftThumbstickButton {
                        handler(true)
                    }
                }
                
                if GamepadManager.rightThumbstickMoving {
                    if let handler = GamepadManager.gamepadOne.rightThumbstick {
                        handler(GamepadManager.rightThumbstickXAxis, GamepadManager.rightThumbstickYAxis)
                    }
                }
                
                if GamepadManager.rightThumbstickButtonPressed {
                    if let handler = GamepadManager.gamepadOne.rightThumbstickButton {
                        handler(true)
                    }
                }
                
                if GamepadManager.dpadMoving {
                    if let handler = GamepadManager.gamepadOne.dpad {
                        handler(GamepadManager.dpadXAxis, GamepadManager.dpadYAxis)
                    }
                }
            }
        }
        
        // Get the default notification center
        let notification = NotificationCenter.default
        
        // Watch for a controller connecting
        notification.addObserver(forName: .GCControllerDidConnect, object: nil, queue: .main) { note in
            if let ctrl = note.object as? GCController {
                self.controllerAdded(ctrl)
            }
        }
        
        // Watch for a controller disconnecting
        notification.addObserver(forName: .GCControllerDidDisconnect, object: nil, queue: .main) { note in
            if let ctrl = note.object as? GCController {
                self.controllerRemoved(ctrl)
            }
        }
    }
    
    /// This function needs to be called on the the app first ends or becomes inactive. When a gamepad is disconnected, the `.onGamepadDisconnected()` event will be raised on any `View` connected to the `GamepadManager`.
    /// - Parameter releaseCurrentController: If `true` the controller wll be released.
    /// - Remark: **WARNING!** Don't forget to call the `stopWatchingForGamepads()` function when the app goes inactive to release event monitoring and memory that the gamepad connection is consuming.
    public static func stopWatchingForGamepads(releaseCurrentController: Bool = false) {
        
        // Get the default notification center
        let notification = NotificationCenter.default
        
        // Stop watch for notificaitons
        notification.removeObserver(self, name: .GCControllerDidConnect, object: nil)
        notification.removeObserver(self, name: .GCControllerDidDisconnect, object: nil)
        
        // Stop event timer
        Execute.onMain {
            GamepadManager.eventTimer.invalidate()
        }
        
        // Fully release any currently connected controller?
        if releaseCurrentController {
            // Release any connected controller
            let controllers = GCController.controllers()
            if controllers.count > 0 {
                self.controllerRemoved(controllers[0])
            }
            
            // Release handler storage
            GamepadManager.gamepadOne.releaseHandlers()
        }
    }
    
    /// Handles a controller being detected by the `connectGamepad()` fucntion by wiring up events and setting the controllers information.
    /// - Parameter controller: The `GCController` that was discovered by the `connectGamepad()` function.
    public static func controllerAdded(_ controller: GCController) {
        // Get the vendor's name for the controller
        GamepadManager.gamepadOne.gampadInfo.setVendorName(from: controller.vendorName)
        GamepadManager.gamepadOne.gampadInfo.style = .unknown
        
        // Does this app support the virtual gamepad?
        if !supportsVirtualGamepad {
            if controller.vendorName == "Gamepad" && controller.productCategory == "MFi" {
                // Assume this is an unsupported virtual controller and don't add.
                return
            }
        }
        
        // Wireup gamepad based on its type
        if let gamepad = controller.extendedGamepad {
            // Set gamepad style
            GamepadManager.gamepadOne.gampadInfo.style = .extendedGamepad
            
            // Handle the left shoulder
            gamepad.leftShoulder.valueChangedHandler = {(control, pressure, isPressed) in
                if let triggerHandler = GamepadManager.gamepadOne.leftShoulderHandler {
                    switch GamepadManager.gamepadOne.leftShoulderMode {
                    case .analog:
                        if isPressed != leftShoulderChanged {
                            triggerHandler(isPressed, pressure)
                            leftShoulderChanged = isPressed
                        }
                    case .continous:
                        GamepadManager.leftShoulderPressed = isPressed
                        GamepadManager.leftShoulderPressure = pressure
                    }
                }
            }
            
            // Handle the right shoulder
            gamepad.rightShoulder.valueChangedHandler = {(control, pressure, isPressed) in
                if let triggerHandler = GamepadManager.gamepadOne.rightShoulderHandler {
                    switch GamepadManager.gamepadOne.rightShoulderMode {
                    case .analog:
                        if isPressed != rightShoulderChanged {
                            triggerHandler(isPressed, pressure)
                            rightShoulderChanged = isPressed
                        }
                    case .continous:
                        GamepadManager.rightShoulderPressed = isPressed
                        GamepadManager.rightShoulderPressure = pressure
                    }
                }
            }
            
            // Handle the left trigger
            gamepad.leftTrigger.valueChangedHandler = {(control, pressure, isPressed) in
                if let triggerHandler = GamepadManager.gamepadOne.leftTriggerHandler {
                    switch GamepadManager.gamepadOne.leftTriggerMode {
                    case .analog:
                        if isPressed != leftTriggerChanged {
                            triggerHandler(isPressed, pressure)
                            leftTriggerChanged = isPressed
                        }
                    case .continous:
                        GamepadManager.leftTriggerPressed = isPressed
                        GamepadManager.leftTriggerPressure = pressure
                    }
                }
            }
            
            // Handle the right trigger
            gamepad.rightTrigger.valueChangedHandler = {(control, pressure, isPressed) in
                if let triggerHandler = GamepadManager.gamepadOne.rightTriggerHandler {
                    switch GamepadManager.gamepadOne.rightTriggerMode {
                    case .analog:
                        if isPressed != rightTriggerChanged {
                            triggerHandler(isPressed, pressure)
                            rightTriggerChanged = isPressed
                        }
                    case .continous:
                        GamepadManager.rightTriggerPressed = isPressed
                        GamepadManager.rightTriggerPressure = pressure
                    }
                }
            }
            
            // Handle the menu button
            gamepad.buttonMenu.valueChangedHandler = {(control, pressure, isPressed) in
                if let handler = GamepadManager.gamepadOne.buttonMenu {
                    switch GamepadManager.gamepadOne.buttonMenuMode {
                    case .stateChanged:
                        if isPressed != buttonMenuChanged {
                            handler(isPressed)
                            buttonMenuChanged = isPressed
                        }
                    case .continous:
                        GamepadManager.buttonMenuPressed = isPressed
                    }
                }
            }
            
            // Handle the options button
            gamepad.buttonOptions?.valueChangedHandler = {(control, pressure, isPressed) in
                if let handler = GamepadManager.gamepadOne.buttonOptions {
                    switch GamepadManager.gamepadOne.buttonOptionsMode {
                    case .stateChanged:
                        if isPressed != buttonOptionsChanged {
                            handler(isPressed)
                            buttonOptionsChanged = isPressed
                        }
                    case .continous:
                        GamepadManager.buttonOptionsPressed = isPressed
                    }
                }
            }
            
            // Handle the home button
            gamepad.buttonHome?.valueChangedHandler = {(control, pressure, isPressed) in
                if let handler = GamepadManager.gamepadOne.buttonHome {
                    switch GamepadManager.gamepadOne.buttonHomeMode {
                    case .stateChanged:
                        if isPressed != buttonHomeChanged {
                            handler(isPressed)
                            buttonHomeChanged = isPressed
                        }
                    case .continous:
                        GamepadManager.buttonHomePressed = isPressed
                    }
                }
            }
            
            // Handle the A button
            gamepad.buttonA.valueChangedHandler = {(control, pressure, isPressed) in
                if let handler = GamepadManager.gamepadOne.buttonA {
                    switch GamepadManager.gamepadOne.buttonAMode {
                    case .stateChanged:
                        if isPressed != buttonAChanged {
                            handler(isPressed)
                            buttonAChanged = isPressed
                        }
                    case .continous:
                        GamepadManager.buttonAPressed = isPressed
                    }
                }
            }
            
            // Handle the B button
            gamepad.buttonB.valueChangedHandler = {(control, pressure, isPressed) in
                if let handler = GamepadManager.gamepadOne.buttonB {
                    switch GamepadManager.gamepadOne.buttonBMode {
                    case .stateChanged:
                        if isPressed != buttonBChanged {
                            handler(isPressed)
                            buttonBChanged = isPressed
                        }
                    case .continous:
                        GamepadManager.buttonBPressed = isPressed
                    }
                }
            }
            
            // Handle the X button
            gamepad.buttonX.valueChangedHandler = {(control, pressure, isPressed) in
                if let handler = GamepadManager.gamepadOne.buttonX {
                    switch GamepadManager.gamepadOne.buttonXMode {
                    case .stateChanged:
                        if isPressed != buttonXChanged {
                            handler(isPressed)
                            buttonXChanged = isPressed
                        }
                    case .continous:
                        GamepadManager.buttonXPressed = isPressed
                    }
                }
            }
            
            // Handle the Y button
            gamepad.buttonY.valueChangedHandler = {(control, pressure, isPressed) in
                if let handler = GamepadManager.gamepadOne.buttonY {
                    switch GamepadManager.gamepadOne.buttonYMode {
                    case .stateChanged:
                        if isPressed != buttonYChanged {
                            handler(isPressed)
                            buttonYChanged = isPressed
                        }
                    case .continous:
                        GamepadManager.buttonYPressed = isPressed
                    }
                }
            }
            
            // Handle dpad
            gamepad.dpad.valueChangedHandler = {(control, x, y) in
                if let handler = GamepadManager.gamepadOne.dpad {
                    switch GamepadManager.gamepadOne.dpadMode {
                    case .stateChanged:
                        let pressed = (x != 0.0 || y != 0.0)
                        if pressed != dpadChanged {
                            handler(x, y)
                            dpadChanged = pressed
                        }
                    case .continous:
                        dpadXAxis = x * 5.0
                        dpadYAxis = y * 5.0
                        dpadMoving = (x != 0.0) || ( y != 0.0)
                    }
                }
            }
            
            // Handle left thumbstick
            gamepad.leftThumbstick.valueChangedHandler = {(control, x, y) in
                if let handler = GamepadManager.gamepadOne.leftThumbstick {
                    switch GamepadManager.gamepadOne.leftThumbstickMode {
                    case .analog:
                        handler(x, y)
                    case .directional:
                        leftThumbstickXAxis = x * 5.0
                        leftThumbstickYAxis = y * 5.0
                        leftThumbstickMoving = (x != 0.0) || ( y != 0.0)
                    }
                }
            }
            
            // Handle right thumbstick
            gamepad.rightThumbstick.valueChangedHandler = {(control, x, y) in
                if let handler = GamepadManager.gamepadOne.rightThumbstick {
                    switch GamepadManager.gamepadOne.rightThumbstickMode {
                    case .analog:
                        handler(x, y)
                    case .directional:
                        rightThumbstickXAxis = x * 5.0
                        rightThumbstickYAxis = y * 5.0
                        rightThumbstickMoving = (x != 0.0) || ( y != 0.0)
                    }
                }
            }
            
            // Handle the left thumbstick button
            gamepad.leftThumbstickButton?.valueChangedHandler = {(control, pressure, isPressed) in
                if let handler = GamepadManager.gamepadOne.leftThumbstickButton {
                    switch GamepadManager.gamepadOne.leftThumbstickButtonMode {
                    case .stateChanged:
                        if isPressed != leftThumbstickButtonChanged {
                            handler(isPressed)
                            leftThumbstickButtonChanged = isPressed
                        }
                    case .continous:
                        GamepadManager.leftThumbstickButtonPressed = isPressed
                    }
                }
            }
            
            // Handle the right thumbstick button
            gamepad.rightThumbstickButton?.valueChangedHandler = {(control, pressure, isPressed) in
                if let handler = GamepadManager.gamepadOne.rightThumbstickButton {
                    switch GamepadManager.gamepadOne.rightThumbstickButtonMode {
                    case .stateChanged:
                        if isPressed != rightThumbstickButtonChanged {
                            handler(isPressed)
                            rightThumbstickButtonChanged = isPressed
                        }
                    case .continous:
                        GamepadManager.rightThumbstickButtonPressed = isPressed
                    }
                }
            }
            
            // Is this a dual shock controller?
            if let gamepad = gamepad as? GCDualShockGamepad {
                // Set gamepad style
                GamepadManager.gamepadOne.gampadInfo.style = .dualShockGamepad
                
                // Handle the touchpad button
                gamepad.touchpadButton.valueChangedHandler = {(control, pressure, isPressed) in
                    if let handler = GamepadManager.gamepadOne.touchpadButton {
                        handler(isPressed)
                    }
                }
                
                // Handle primary touchpad touch.
                gamepad.touchpadPrimary.valueChangedHandler = {(control, x, y) in
                    if let handler = GamepadManager.gamepadOne.touchpadPrimary {
                        handler(x, y)
                    }
                }
                
                // Handle primary touchpad touch.
                gamepad.touchpadSecondary.valueChangedHandler = {(control, x, y) in
                    if let handler = GamepadManager.gamepadOne.touchpadSecondary {
                        handler(x, y)
                    }
                }
            }
            
            // Is this an Xbox controller?
            if let gamepad = gamepad as? GCXboxGamepad {
                // Set gamepad style
                GamepadManager.gamepadOne.gampadInfo.style = .xboxGamepad
                
                // Handle the paddle button one
                gamepad.paddleButton1?.valueChangedHandler = {(control, pressure, isPressed) in
                    if let handler = GamepadManager.gamepadOne.paddleButton1 {
                        handler(isPressed)
                    }
                }
                
                // Handle the paddle button two
                gamepad.paddleButton2?.valueChangedHandler = {(control, pressure, isPressed) in
                    if let handler = GamepadManager.gamepadOne.paddleButton2 {
                        handler(isPressed)
                    }
                }
                
                // Handle the paddle button three
                gamepad.paddleButton3?.valueChangedHandler = {(control, pressure, isPressed) in
                    if let handler = GamepadManager.gamepadOne.paddleButton3 {
                        handler(isPressed)
                    }
                }
                
                // Handle the paddle button four
                gamepad.paddleButton4?.valueChangedHandler = {(control, pressure, isPressed) in
                    if let handler = GamepadManager.gamepadOne.paddleButton4 {
                        handler(isPressed)
                    }
                }
                
                // Handle the paddle button one
                gamepad.buttonShare?.valueChangedHandler = {(control, pressure, isPressed) in
                    if let handler = GamepadManager.gamepadOne.buttonShare {
                        handler(isPressed)
                    }
                }
            }
            
            // Is this a dual sense controller?
            if let gamepad = gamepad as? GCDualSenseGamepad {
                // Set gamepad style
                GamepadManager.gamepadOne.gampadInfo.style = .dualSenseGamepad
                
                // Handle the touchpad button
                gamepad.touchpadButton.valueChangedHandler = {(control, pressure, isPressed) in
                    if let handler = GamepadManager.gamepadOne.touchpadButton {
                        handler(isPressed)
                    }
                }
                
                // Handle primary touchpad touch.
                gamepad.touchpadPrimary.valueChangedHandler = {(control, x, y) in
                    if let handler = GamepadManager.gamepadOne.touchpadPrimary {
                        handler(x, y)
                    }
                }
                
                // Handle primary touchpad touch.
                gamepad.touchpadSecondary.valueChangedHandler = {(control, x, y) in
                    if let handler = GamepadManager.gamepadOne.touchpadSecondary {
                        handler(x, y)
                    }
                }
            }
            
            // Inform caller that a gamepad was connected
            for handlers in GamepadManager.gamepadOne.eventHandlers {
                if let handler = handlers.gamepadConnected {
                    handler(controller, GamepadManager.gamepadOne.gampadInfo)
                }
            }
        } else if let gamepad = controller.microGamepad {
            // Does the app support using the Apple TV Remote as a mini gamepad?
            guard GamepadManager.supportsMicroGamepad else {
                return
            }
            
            // Set gamepad style
            GamepadManager.gamepadOne.gampadInfo.style = .microGamepad
            
            // Handle dpad
            gamepad.dpad.valueChangedHandler = {(control, x, y) in
                if let handler = GamepadManager.gamepadOne.dpad {
                    handler(x, y)
                }
            }
            
            // Handle the menu button
            gamepad.buttonMenu.valueChangedHandler = {(control, pressure, isPressed) in
                if let handler = GamepadManager.gamepadOne.buttonMenu {
                    handler(isPressed)
                }
            }
            
            // Handle the A button
            gamepad.buttonA.valueChangedHandler = {(control, pressure, isPressed) in
                if let handler = GamepadManager.gamepadOne.buttonA {
                    handler(isPressed)
                }
            }
            
            // Handle the X button
            gamepad.buttonX.valueChangedHandler = {(control, pressure, isPressed) in
                if let handler = GamepadManager.gamepadOne.buttonX {
                    handler(isPressed)
                }
            }
            
            // Is this a directional gamepad?
            if gamepad is GCDirectionalGamepad {
                // Set gamepad style
                GamepadManager.gamepadOne.gampadInfo.style = .directionalGamepad
            }
            
            // Inform caller that a gamepad was connected
            for handlers in GamepadManager.gamepadOne.eventHandlers {
                if let handler = handlers.gamepadConnected {
                    handler(controller, GamepadManager.gamepadOne.gampadInfo)
                }
            }
        }
    }
    
    /// Handles a controller being disconnected and unwires all events to release memory.
    /// - Parameter controller: The `GCController` that is being released.
    public static func resetController(_ controller: GCController) {
        // Handle an extended gamepad
        if let gamepad = controller.extendedGamepad {
            // Release all of the handlers
            gamepad.leftShoulder.valueChangedHandler = nil
            gamepad.rightShoulder.valueChangedHandler = nil
            gamepad.leftTrigger.valueChangedHandler = nil
            gamepad.rightTrigger.valueChangedHandler = nil
            gamepad.buttonMenu.valueChangedHandler = nil
            gamepad.buttonOptions?.valueChangedHandler = nil
            gamepad.buttonHome?.valueChangedHandler = nil
            gamepad.buttonA.valueChangedHandler = nil
            gamepad.buttonB.valueChangedHandler = nil
            gamepad.buttonX.valueChangedHandler = nil
            gamepad.buttonY.valueChangedHandler = nil
            gamepad.dpad.valueChangedHandler = nil
            gamepad.leftThumbstick.valueChangedHandler = nil
            gamepad.rightThumbstick.valueChangedHandler = nil
            gamepad.leftThumbstickButton?.valueChangedHandler = nil
            gamepad.rightThumbstickButton?.valueChangedHandler = nil
            
            // Is this a dual shock controller?
            if let gamepad = gamepad as? GCDualShockGamepad {
                gamepad.touchpadButton.valueChangedHandler = nil
                gamepad.touchpadPrimary.valueChangedHandler = nil
                gamepad.touchpadSecondary.valueChangedHandler = nil
            }
            
            // Is this an Xbox controller?
            if let gamepad = gamepad as? GCXboxGamepad {
                gamepad.paddleButton1?.valueChangedHandler = nil
                gamepad.paddleButton2?.valueChangedHandler = nil
                gamepad.paddleButton3?.valueChangedHandler = nil
                gamepad.paddleButton4?.valueChangedHandler = nil
                gamepad.buttonShare?.valueChangedHandler = nil
            }
            
            // Is this a dual sense controller?
            if let gamepad = gamepad as? GCDualSenseGamepad {
                gamepad.touchpadButton.valueChangedHandler = nil
                gamepad.touchpadPrimary.valueChangedHandler = nil
                gamepad.touchpadSecondary.valueChangedHandler = nil
            }
        } else if let gamepad = controller.microGamepad {
            gamepad.dpad.valueChangedHandler = nil
            gamepad.buttonMenu.valueChangedHandler = nil
            gamepad.buttonA.valueChangedHandler = nil
            gamepad.buttonX.valueChangedHandler = nil
        }
        
        // Reset controller information
        GamepadManager.gamepadOne.gampadInfo.vendorName = ""
        GamepadManager.gamepadOne.gampadInfo.style = .unknown
    }
    
    /// Handles a controller being disconnected and unwires all events to release memory.
    /// - Parameter controller: The `GCController` that is being released.
    public static func controllerRemoved(_ controller: GCController){
        
        // Inform caller that a gamepad was disconnected
        for handlers in GamepadManager.gamepadOne.eventHandlers {
            if let handler = handlers.gamepadDisconnected {
                handler(controller, GamepadManager.gamepadOne.gampadInfo)
            }
        }
        
        // Reset the controller
        resetController(controller)
    }
    
    // MARK: - Properties
    /// Holds the stack of event handlers used to communicate gamepad events to the attached views.
    public var eventHandlers:[GamepadEventHandlers] = []
    
    /// Holds information about the connected gamepad such as it's style and vendor name.
    public var gampadInfo:GamePadInfo = GamePadInfo()
    
    // MARK: - Computed Properties
    /// The handler for the gamepad left shoulder button event.
    public var leftShoulderHandler: View.gamepadTriggerHandler? {
        for handler in eventHandlers {
            if handler.leftShoulderHandler != nil {
                return handler.leftShoulderHandler
            }
        }
        
        return nil
    }
    
    /// The mode that the left shoulder button operates in.
    public var leftShoulderMode: GamepadManager.TriggerMode {
        for handler in eventHandlers {
            if handler.leftShoulderHandler != nil {
                return handler.leftShoulderMode
            }
        }
        
        return .analog
    }
    
    /// The usage description for the left shoulder button.
    public var leftShoulderUsage:String {
        for handler in eventHandlers {
            if handler.leftShoulderHandler != nil {
                return handler.leftShoulderUsage
            }
        }
        
        return ""
    }
    
    /// The handler for the gamepad right shoulder button event.
    public var rightShoulderHandler: View.gamepadTriggerHandler? {
        for handler in eventHandlers {
            if handler.rightShoulderHandler != nil {
                return handler.rightShoulderHandler
            }
        }
        
        return nil
    }
    
    /// The mode that the right shoulder button opperates in.
    public var rightShoulderMode: GamepadManager.TriggerMode {
        for handler in eventHandlers {
            if handler.rightShoulderHandler != nil {
                return handler.rightShoulderMode
            }
        }
        
        return .analog
    }
    
    /// The usage description for the right shoulder button.
    public var rightShoulderUsage:String {
        for handler in eventHandlers {
            if handler.rightShoulderHandler != nil {
                return handler.rightShoulderUsage
            }
        }
        
        return ""
    }
    
    /// The handler for the gamepad left trigger event.
    public var leftTriggerHandler: View.gamepadTriggerHandler? {
        for handler in eventHandlers {
            if handler.leftTriggerHandler != nil {
                return handler.leftTriggerHandler
            }
        }
        
        return nil
    }
    
    /// The mode that the left trigger operates in.
    public var leftTriggerMode: GamepadManager.TriggerMode {
        for handler in eventHandlers {
            if handler.leftTriggerHandler != nil {
                return handler.leftTriggerMode
            }
        }
        
        return .analog
    }
    
    /// The usage description for the left trigger button.
    public var leftTriggerUsage:String {
        for handler in eventHandlers {
            if handler.leftTriggerHandler != nil {
                return handler.leftTriggerUsage
            }
        }
        
        return ""
    }
    
    /// The handler for the gamepad right trigger event.
    public var rightTriggerHandler: View.gamepadTriggerHandler? {
        for handler in eventHandlers {
            if handler.rightTriggerHandler != nil {
                return handler.rightTriggerHandler
            }
        }
        
        return nil
    }
    
    /// The mode that the right trigger operates in.
    public var rightTriggerMode: GamepadManager.TriggerMode {
        for handler in eventHandlers {
            if handler.rightTriggerHandler != nil {
                return handler.rightTriggerMode
            }
        }
        
        return .analog
    }
    
    /// The usage description for the right trigger button.
    public var rightTriggerUsage:String {
        for handler in eventHandlers {
            if handler.rightTriggerHandler != nil {
                return handler.rightTriggerUsage
            }
        }
        
        return ""
    }
    
    /// The handler for the gamepad menu button event.
    public var buttonMenu: View.gamepadButtonHandler? {
        for handler in eventHandlers {
            if handler.buttonMenu != nil {
                return handler.buttonMenu
            }
        }
        
        return nil
    }
    
    /// The mode that button menu operates in.
    public var buttonMenuMode: GamepadManager.ButtonMode {
        for handler in eventHandlers {
            if handler.buttonMenu != nil {
                return handler.buttonMenuMode
            }
        }
        
        return .stateChanged
    }
    
    /// The usage description for the menu button.
    public var buttonMenuUsage:String {
        for handler in eventHandlers {
            if handler.buttonMenu != nil {
                return handler.buttonMenuUsage
            }
        }
        
        return ""
    }
    
    /// The handler for the gamepad options button event.
    public var buttonOptions: View.gamepadButtonHandler? {
        for handler in eventHandlers {
            if handler.buttonOptions != nil {
                return handler.buttonOptions
            }
        }
        
        return nil
    }
    
    /// The mode that button options operates in.
    public var buttonOptionsMode: GamepadManager.ButtonMode {
        for handler in eventHandlers {
            if handler.buttonOptions != nil {
                return handler.buttonOptionsMode
            }
        }
        
        return .stateChanged
    }
    
    /// The usage description for the options button.
    public var buttonOptionsUsage:String {
        for handler in eventHandlers {
            if handler.buttonOptions != nil {
                return handler.buttonOptionsUsage
            }
        }
        
        return ""
    }
    
    /// The handler for the gamepad home button event.
    public var buttonHome: View.gamepadButtonHandler? {
        for handler in eventHandlers {
            if handler.buttonHome != nil {
                return handler.buttonHome
            }
        }
        
        return nil
    }
    
    /// The mode that button home operates in.
    public var buttonHomeMode: GamepadManager.ButtonMode {
        for handler in eventHandlers {
            if handler.buttonHome != nil {
                return handler.buttonHomeMode
            }
        }
        
        return .stateChanged
    }
    
    /// The usage description for the home button.
    public var buttonHomeUsage:String {
        for handler in eventHandlers {
            if handler.buttonHome != nil {
                return handler.buttonHomeUsage
            }
        }
        
        return ""
    }
    
    /// The handler for the gamepad A button event.
    public var buttonA: View.gamepadButtonHandler? {
        for handler in eventHandlers {
            if handler.buttonA != nil {
                return handler.buttonA
            }
        }
        
        return nil
    }
    
    /// The mode that button A operates in.
    public var buttonAMode: GamepadManager.ButtonMode {
        for handler in eventHandlers {
            if handler.buttonA != nil {
                return handler.buttonAMode
            }
        }
        
        return .stateChanged
    }
    
    /// The usage description for the A button.
    public var buttonAUsage:String {
        for handler in eventHandlers {
            if handler.buttonA != nil {
                return handler.buttonAUsage
            }
        }
        
        return ""
    }
    
    /// The handler for the gamepad B button event.
    public var buttonB: View.gamepadButtonHandler? {
        for handler in eventHandlers {
            if handler.buttonB != nil {
                return handler.buttonB
            }
        }
        
        return nil
    }
    
    /// The mode that button B operates in.
    public var buttonBMode: GamepadManager.ButtonMode {
        for handler in eventHandlers {
            if handler.buttonB != nil {
                return handler.buttonBMode
            }
        }
        
        return .stateChanged
    }
    
    /// The usage description for the B button.
    public var buttonBUsage:String {
        for handler in eventHandlers {
            if handler.buttonB != nil {
                return handler.buttonBUsage
            }
        }
        
        return ""
    }
    
    /// The handler for the gamepad X button event.
    public var buttonX: View.gamepadButtonHandler? {
        for handler in eventHandlers {
            if handler.buttonX != nil {
                return handler.buttonX
            }
        }
        
        return nil
    }
    
    /// The mode that button X operates in.
    public var buttonXMode: GamepadManager.ButtonMode {
        for handler in eventHandlers {
            if handler.buttonX != nil {
                return handler.buttonXMode
            }
        }
        
        return .stateChanged
    }
    
    /// The usage description for the X button.
    public var buttonXUsage:String {
        for handler in eventHandlers {
            if handler.buttonX != nil {
                return handler.buttonXUsage
            }
        }
        
        return ""
    }
    
    /// The handler for the gamepad Y button event.
    public var buttonY: View.gamepadButtonHandler? {
        for handler in eventHandlers {
            if handler.buttonY != nil {
                return handler.buttonY
            }
        }
        
        return nil
    }
    
    /// The mode that button Y operates in.
    public var buttonYMode: GamepadManager.ButtonMode {
        for handler in eventHandlers {
            if handler.buttonY != nil {
                return handler.buttonYMode
            }
        }
        
        return .stateChanged
    }
    
    /// The usage description for the Y button.
    public var buttonYUsage:String {
        for handler in eventHandlers {
            if handler.buttonY != nil {
                return handler.buttonYUsage
            }
        }
        
        return ""
    }
    
    /// The handler for the gamepad dpad event.
    public var dpad: View.gamepadDirectionHandler? {
        for handler in eventHandlers {
            if handler.dpad != nil {
                return handler.dpad
            }
        }
        
        return nil
    }
    
    /// The mode that the dpad operates in.
    public var dpadMode: GamepadManager.ButtonMode {
        for handler in eventHandlers {
            if handler.dpad != nil {
                return handler.dpadMode
            }
        }
        
        return .stateChanged
    }
    
    /// The usage description for the Dpad.
    public var dpadUsage:String {
        for handler in eventHandlers {
            if handler.dpad != nil {
                return handler.dpadUsage
            }
        }
        
        return ""
    }
    
    /// The handler for the gamepad left thumbstick event.
    public var leftThumbstick: View.gamepadDirectionHandler? {
        for handler in eventHandlers {
            if handler.leftThumbstick != nil {
                return handler.leftThumbstick
            }
        }
        
        return nil
    }
    
    /// Determines the mode of operation for the left thumbstick
    public var leftThumbstickMode: GamepadManager.ThumbstickMode {
        for handler in eventHandlers {
            if handler.leftThumbstick != nil {
                return handler.leftThumbstickMode
            }
        }
        
        return .analog
    }
    
    /// The usage description for the left thumbstick.
    public var leftThumbstickUsage:String {
        for handler in eventHandlers {
            if handler.leftThumbstick != nil {
                return handler.leftThumbstickUsage
            }
        }
        
        return ""
    }
    
    /// The handler for the gamepad right thumbstick event.
    public var rightThumbstick: View.gamepadDirectionHandler? {
        for handler in eventHandlers {
            if handler.rightThumbstick != nil {
                return handler.rightThumbstick
            }
        }
        
        return nil
    }
    
    /// Determines the mode of operation for the right thumbstick
    public var rightThumbstickMode: GamepadManager.ThumbstickMode {
        for handler in eventHandlers {
            if handler.rightThumbstick != nil {
                return handler.rightThumbstickMode
            }
        }
        
        return .analog
    }
    
    /// The usage description for the right thumbstick.
    public var rightThumbstickUsage:String {
        for handler in eventHandlers {
            if handler.rightThumbstick != nil {
                return handler.rightThumbstickUsage
            }
        }
        
        return ""
    }
    
    /// The handler for the gamepad left thumbstick button event.
    public var leftThumbstickButton: View.gamepadButtonHandler? {
        for handler in eventHandlers {
            if handler.leftThumbstickButton != nil {
                return handler.leftThumbstickButton
            }
        }
        
        return nil
    }
    
    /// The mode that the left thumbstick button operates in.
    public var leftThumbstickButtonMode: GamepadManager.ButtonMode {
        for handler in eventHandlers {
            if handler.leftThumbstickButton != nil {
                return handler.leftThumbstickButtonMode
            }
        }
        
        return .stateChanged
    }
    
    /// The usage description for the left thumbstick Button.
    public var leftThumbstickButtonUsage:String {
        for handler in eventHandlers {
            if handler.leftThumbstickButton != nil {
                return handler.leftThumbstickButtonUsage
            }
        }
        
        return ""
    }
    
    /// The handler for the gamepad right thumbstick button event.
    public var rightThumbstickButton: View.gamepadButtonHandler? {
        for handler in eventHandlers {
            if handler.rightThumbstickButton != nil {
                return handler.rightThumbstickButton
            }
        }
        
        return nil
    }
    
    /// The mode that the right thumbstick button operates in.
    public var rightThumbstickButtonMode: GamepadManager.ButtonMode {
        for handler in eventHandlers {
            if handler.rightThumbstickButton != nil {
                return handler.rightThumbstickButtonMode
            }
        }
        
        return .stateChanged
    }
    
    /// The usage description for the right thumbstick Button.
    public var rightThumbstickButtonUsage:String {
        for handler in eventHandlers {
            if handler.rightThumbstickButton != nil {
                return handler.rightThumbstickButtonUsage
            }
        }
        
        return ""
    }
    
    // !!!: Sony Dual Shock specific controls.
    /// The handler for the gamepad touchpad button event.
    public var touchpadButton: View.gamepadButtonHandler? {
        for handler in eventHandlers {
            if handler.touchpadButton != nil {
                return handler.touchpadButton
            }
        }
        
        return nil
    }
    
    /// The usage description for the touchpad Button.
    public var touchpadButtonUsage:String {
        for handler in eventHandlers {
            if handler.touchpadButton != nil {
                return handler.touchpadButtonUsage
            }
        }
        
        return ""
    }
    
    /// The handler for the gamepad touchpad one finger event.
    public var touchpadPrimary: View.gamepadDirectionHandler? {
        for handler in eventHandlers {
            if handler.touchpadPrimary != nil {
                return handler.touchpadPrimary
            }
        }
        
        return nil
    }
    
    /// The usage description for the touchpad primary.
    public var touchpadPrimaryUsage:String {
        for handler in eventHandlers {
            if handler.touchpadPrimary != nil {
                return handler.touchpadPrimaryUsage
            }
        }
        
        return ""
    }
    
    /// The handler for the gamepad touchpad two finger event.
    public var touchpadSecondary: View.gamepadDirectionHandler? {
        for handler in eventHandlers {
            if handler.touchpadSecondary != nil {
                return handler.touchpadSecondary
            }
        }
        
        return nil
    }
    
    /// The usage description for the touchpad secondary.
    public var touchpadSecondaryUsage:String {
        for handler in eventHandlers {
            if handler.touchpadSecondary != nil {
                return handler.touchpadSecondaryUsage
            }
        }
        
        return ""
    }
    
    // !!!: Xbox controller specific controls.
    /// The handler for the gamepad paddle button 1 event.
    public var paddleButton1: View.gamepadButtonHandler? {
        for handler in eventHandlers {
            if handler.paddleButton1 != nil {
                return handler.paddleButton1
            }
        }
        
        return nil
    }
    
    /// The usage description for the paddle 1 Button.
    public var paddleButton1Usage:String {
        for handler in eventHandlers {
            if handler.paddleButton1 != nil {
                return handler.paddleButton1Usage
            }
        }
        
        return ""
    }
    
    /// The handler for the gamepad paddle button 2 event.
    public var paddleButton2: View.gamepadButtonHandler? {
        for handler in eventHandlers {
            if handler.paddleButton2 != nil {
                return handler.paddleButton2
            }
        }
        
        return nil
    }
    
    /// The usage description for the paddle 2 Button.
    public var paddleButton2Usage:String {
        for handler in eventHandlers {
            if handler.paddleButton2 != nil {
                return handler.paddleButton2Usage
            }
        }
        
        return ""
    }
    
    /// The handler for the gamepad paddle button 3 event.
    public var paddleButton3: View.gamepadButtonHandler? {
        for handler in eventHandlers {
            if handler.paddleButton3 != nil {
                return handler.paddleButton3
            }
        }
        
        return nil
    }
    
    /// The usage description for the paddle 3 Button.
    public var paddleButton3Usage:String {
        for handler in eventHandlers {
            if handler.paddleButton3 != nil {
                return handler.paddleButton3Usage
            }
        }
        
        return ""
    }
    
    /// The handler for the gamepad paddle button 4 event.
    public var paddleButton4: View.gamepadButtonHandler? {
        for handler in eventHandlers {
            if handler.paddleButton4 != nil {
                return handler.paddleButton4
            }
        }
        
        return nil
    }
    
    /// The usage description for the paddle 4 Button.
    public var paddleButton4Usage:String {
        for handler in eventHandlers {
            if handler.paddleButton4 != nil {
                return handler.paddleButton4Usage
            }
        }
        
        return ""
    }
    
    /// The handler for the gamepadshare button event.
    public var buttonShare: View.gamepadButtonHandler? {
        for handler in eventHandlers {
            if handler.buttonShare != nil {
                return handler.buttonShare
            }
        }
        
        return nil
    }
    
    /// The usage description for the share Button.
    public var buttonShareUsage:String {
        for handler in eventHandlers {
            if handler.buttonShare != nil {
                return handler.buttonShareUsage
            }
        }
        
        return ""
    }
    
    // MARK: - Constructors
    /// Creates a new instance of the object.
    public init() {
        // Create the default set of handlers
        self.createHandlers(for: "Default")
    }
    
    // MARK: - Functions
    /// Creates the `GamepadEventHandlers` collection for the given view ID if it doesn't already exist.
    /// - Parameter viewID: The unique ID of the view to create the `GamepadEventHandlers`.
    public func createHandlers(for viewID:String) {
        for handlers in eventHandlers {
            if handlers.attachedViewID == viewID {
                Debug.info(subsystem: "GamepadManager", category: "createHandlers", "Fetched: \(viewID)")
                return
            }
        }
        
        // Push new handler collection onto the stack.
        let handler = GamepadEventHandlers(attachedViewID: viewID)
        eventHandlers.insert(handler, at: 0)
        Debug.info(subsystem: "GamepadManager", category: "createHandlers", "Created: \(viewID)")
    }
    
    /// Creates a new `GamepadEventHandlers`, or returns an existing, collection for the given view ID.
    /// - Parameter viewID: The unique ID of the view to create the `GamepadEventHandlers`.
    public func fetchHandlers(for viewID:String) -> GamepadEventHandlers {
        for handlers in eventHandlers {
            if handlers.attachedViewID == viewID {
                return handlers
            }
        }
        
        // Push new handler collection onto the stack.
        let handlers = GamepadEventHandlers(attachedViewID: viewID)
        eventHandlers.insert(handlers, at: 0)
        Debug.info(subsystem: "GamepadManager", category: "fetchHandlers", "Created: \(viewID)")
        return handlers
    }
    
    /// Releases the gamepad handlers for the given `View`.
    /// - Parameter viewID: The unique ID of the `View` to release the handlers for.
    public func releaseHandlers(for viewID:String) {
        
        // Scan the handler collection for the view to release
        for n in 0...eventHandlers.count - 1 {
            if eventHandlers[n].attachedViewID == viewID {
                eventHandlers[n].releaseHandlers()
                eventHandlers.remove(at: n)
                Debug.info(subsystem: "GamepadManager", category: "releaseHandlers", "Released: \(viewID)")
                return
            }
        }
    }
    
    /// Inform the `View` that the app is becoming active.
    public func appIsBecomingActive() {
        for handlers in eventHandlers {
            if let gamepadAppIsActive = handlers.gamepadAppIsActive {
                gamepadAppIsActive()
            }
        }
    }
    
    /// Inform the `View` that the app is becoming inactive.
    public func appIsBecomingInactive() {
        for handlers in eventHandlers {
            if let gamepadAppIsInactive = handlers.gamepadAppIsInactive {
                gamepadAppIsInactive()
            }
        }
    }
    
    /// Inform the `View` that the app is entering the background.
    public func appIsEnteringBackground() {
        for handlers in eventHandlers {
            if let gamepadAppInBackground = handlers.gamepadAppInBackground {
                gamepadAppInBackground()
            }
        }
    }
    
    /// Releases all memory held by any attached event handlers.
    public func releaseHandlers() {
        for handler in eventHandlers {
            handler.releaseHandlers()
        }
        eventHandlers.removeAll()
    }
}
