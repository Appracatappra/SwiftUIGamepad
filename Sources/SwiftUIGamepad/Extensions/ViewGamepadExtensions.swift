//
//  ViewGamepadExtensions.swift
//  ReedWriteCycle (iOS)
//
//  Created by Kevin Mullins on 11/9/22.
//
//  Connect/Disconnect: https://bignerdranch.com/blog/tvos-games-part-1-using-the-game-controller-framework/
//  Using Controllers: https://medium.com/@Antoniowski/implementing-game-controller-for-your-ios-or-mac-app-361d97b07ab7
//  Apple Documentation:

import Foundation
import SwiftUI
import GameController

/// Extends the Swift UI View with the ability to respond to a single gamepad that is attached to the device.
///
/// For example, let's take a look at the `body` of an About View:
///
/// ```
/// @State var showGamepadHelp:Bool = false
/// @State var isGamepadConnected:Bool = false
///
///  var body: some View {
///     mainContents()
///     .onAppear {
///         connectGamepad(viewID: "About", handler: { controller, gamepadInfo in
///             isGamepadConnected = true
///             buttonMenuUsage(viewID: "About", "Return to the **Cover Page Menu**.")
///             buttonAUsage(viewID: "About", "Show or hide **Gamepad Help**.")
///         })
///     }
///     .onDisappear {
///         disconnectGamepad(viewID: "About")
///     }
///     .onRotate { newOrientation in
///         Execute.onMain {
///             orientation = newOrientation
///         }
///     }
///     .onGampadAppBecomingActive(viewID: "About") {
///         reconnectGamepad()
///     }
///     .onGamepadDisconnected(viewID: "About") { controller, gamepadInfo in
///         isGamepadConnected = false
///     }
///     .onGamepadButtonMenu(viewID: "About") { isPressed in
///         if isPressed {
///             // Return to main menu ...
///         }
///     }
///     .onGamepadButtonA(viewID: "About") { isPressed in
///         if isPressed {
///             showGamepadHelp = !showGamepadHelp
///         }
///     }
///     .onGamepadLeftShoulder(viewID: "About") { isPressed, value in
///         if isPressed {
///             // Return to main menu ...
///         }
///     }
/// }
/// ```
///
/// - Remark: For `SwiftUIGamepad` to function, you **must** add the `GamepadManager` events to the app's `.onChange` event. See the **Where To Set The Style Changes and Wire-Up Gamepad Support** documentation.
extension View {
    // MARK: - Type Aliases
    /// Defines a handler for gamepad status events such as a gamepad connecting or disconnecting from the device the app is running on.
    public typealias gamepadStatusHandler = (GCController, GamePadInfo) -> Void
    
    /// Defines a handler for trigger based gamepad events.
    public typealias gamepadTriggerHandler = (Bool, Float) -> Void
    
    /// Defines a handler for button based gamepad events.
    public typealias gamepadButtonHandler = (Bool) -> Void
    
    /// Defines a handler for direction based gamepad events.
    public typealias gamepadDirectionHandler = (Float, Float) -> Void
    
    /// Defines a handler for gamepad app events such as the app becoming active or entering the background.
    public typealias gamepadAppEvent = () -> Void
    
    // MARK: - Functions
    /// This function needs to be called on the `onAppear()` event for any `View` that you want to start handling gamepad events in.
    ///
    /// For any `View` that you want to respond to gamepad events, you need to call the `connectGamepad()` function when the view loads. For example:
    ///
    /// ```swift
    /// var body: some View {
    ///     Zstack {
    ///       ...
    ///     }
    ///     .onAppear {
    ///       connectGamepad(viewID: "MyView", handler: { controller, gamepadInfo in ...})
    ///     }
    /// }
    /// ```
    /// > To properly respond to the gamepad connected event, you **MUST** define the `gamepadViewIdentifier` event before handling the `onAppear` event.
    ///
    /// When a gamepad is connected, the `.onGamepadConnected()` event will be raised on the `View`. From this point on, you can use events like `.onGamepadLeftShoulder()` and `onGamepadButtonA()` to respond to the user interacting with the gamepad.
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter handler: The action to take when this event occurs.
    /// - Remark: **WARNING!** Don't forget to call the `disconnectGamepad()` function in the `onDisappear()` event for the same `View` to release event monitoring and memory that the gamepad connection is consuming.
    public func connectGamepad(viewID:String = "Default", handler:@escaping gamepadStatusHandler) {
        
        // Save connection handler
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).gamepadConnected = handler
        
        // If a gamepad is already connected attach to it
        let controllers = GCController.controllers()
        if controllers.count > 0 {
            GamepadManager.controllerAdded(controllers[0])
        }
    }
    
    /// This function needs to be called when the app becomes active after it has been inactive.
    ///
    /// For any `View` that you want to respond to gamepad events, you need to call the `reconnectGamepad()` function when the view reloads. For example:
    ///
    /// ```swift
    /// var body: some View {
    ///     Zstack {
    ///       ...
    ///     }
    ///     .onAppear {
    ///       reconnectGamepad()
    ///     }
    /// }
    /// ```
    public func reconnectGamepad() {
        // If a gamepad is already connected attach to it
        let controllers = GCController.controllers()
        if controllers.count > 0 {
            GamepadManager.controllerAdded(controllers[0])
        }
    }
    
    /// This function needs to be called on the `onDisappear()` event for any `View` that you previously started handling gamepad events in.
    ///
    /// For any `View` that you previously started monitoring gamepad events in by calling `connectGamepad()` function,  you need to call the `disconnectGamepad()` function in the `onDisappear()` event . For example:
    ///
    /// ```swift
    /// var body: some View {
    ///     Zstack {
    ///       ...
    ///     }
    ///     .onDisappear {
    ///       disconnectGamepad(viewID: "MyView")
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Remark: **WARNING!** Don't forget to call the `disconnectGamepad()` function in the `onDisappear()` event for the same `View` to release event monitoring and memory that the gamepad connection is consuming.
    public func disconnectGamepad(viewID:String){
        
        // Release any handlers for this view
        GamepadManager.gamepadOne.releaseHandlers(for: viewID)
        
    }
    
    /// This function needs to be called on the `onDisappear()` event for any `View` that you previously started handling gamepad events in.
    ///
    /// For any `View` that you previously started monitoring gamepad events in by calling `connectGamepad()` function,  you need to call the `disconnectGamepad()` function in the `onDisappear()` event . For example:
    ///
    /// ```swift
    /// var body: some View {
    ///     Zstack {
    ///       ...
    ///     }
    ///     .supportsMicorGamepad(false)
    /// }
    /// ```
    ///
    /// - Remark: **WARNING!** Don't forget to call the `disconnectGamepad()` function in the `onDisappear()` event for the same `View` to release event monitoring and memory that the gamepad connection is consuming.
    public func supportsMicroGamepad(_ value:Bool) -> some View {
        GamepadManager.supportsMicroGamepad = value
        
        return self
    }
    
    // !!!: Gamepad control modes
    /// Defines the mode of operation for the gamepad's left shoulder button in the current `View`.
    ///
    /// For example:
    ///
    /// ```swift
    /// var body: some View {
    ///     Zstack {
    ///       ...
    ///     }
    ///     .gamepadLeftShoulderMode(mode: .continous)
     /// }
    /// ```
    ///
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter mode: The requested mode of operation. The default mode is `analog`.
    /// - Returns: Returns self.
    /// - Remark: In `analog` mode the trigger will send a direct reading on the trigger's position once. In `continous` mode the trigger will send a continous pressure reading until the user releases the trigger.
    public func gamepadLeftShoulderMode(viewID:String = "Default", mode: GamepadManager.TriggerMode) -> some View {
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).leftShoulderMode = mode
        
        return self
    }
    
    /// Defines the mode of operation for the gamepad's right shoulder button in the current `View`.
    ///
    /// For example:
    ///
    /// ```swift
    /// var body: some View {
    ///     Zstack {
    ///       ...
    ///     }
    ///     .gamepadRightShoulderMode(mode: .continous)
    /// }
    /// ```
    ///
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter mode: The requested mode of operation. The default mode is `analog`.
    /// - Returns: Returns self.
    /// - Remark: In `analog` mode the trigger will send a direct reading on the trigger's position once. In `continous` mode the trigger will send a continous pressure reading until the user releases the trigger.
    public func gamepadRightShoulderMode(viewID:String = "Default", mode: GamepadManager.TriggerMode) -> some View {
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).rightShoulderMode = mode
        
        return self
    }
    
    /// Defines the mode of operation for the gamepad's left trigger in the current `View`.
    ///
    /// For example:
    ///
    /// ```swift
    /// var body: some View {
    ///     Zstack {
    ///       ...
    ///     }
    ///     .gamepadLeftTriggerMode(mode: .continous)
    /// }
    /// ```
    ///
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter mode: The requested mode of operation. The default mode is `analog`.
    /// - Returns: Returns self.
    /// - Remark: In `analog` mode the trigger will send a direct reading on the trigger's position once. In `continous` mode the trigger will send a continous pressure reading until the user releases the trigger.
    public func gamepadLeftTriggerMode(viewID:String = "Default", mode: GamepadManager.TriggerMode) -> some View {
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).leftTriggerMode = mode
        
        return self
    }
    
    /// Defines the mode of operation for the gamepad's right trigger in the current `View`.
    ///
    /// For example:
    ///
    /// ```swift
    /// var body: some View {
    ///     Zstack {
    ///       ...
    ///     }
    ///     .gamepadRightTriggerMode(mode: .continous)
    /// }
    /// ```
    ///
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter mode: The requested mode of operation. The default mode is `analog`.
    /// - Returns: Returns self.
    /// - Remark: In `analog` mode the trigger will send a direct reading on the trigger's position once. In `continous` mode the trigger will send a continous pressure reading until the user releases the trigger.
    public func gamepadRightTriggerMode(viewID:String = "Default", mode: GamepadManager.TriggerMode) -> some View {
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).rightTriggerMode = mode
        
        return self
    }
    
    /// Defines the mode of operation for gamepad button menu in the current `View`.
    ///
    /// For example:
    ///
    /// ```swift
    /// var body: some View {
    ///     Zstack {
    ///       ...
    ///     }
    ///     .gamepadButtonMenuMode(mode: .continous)
    /// }
    /// ```
    ///
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter mode: The requested mode of operation. The default mode is `stateChanged`.
    /// - Returns: Returns self.
    /// - Remark: If the button's mode is `stateChanged`, then the `View` will only be notified if presses or releases a the button. If the button's mode is `continous`, then the `View` will be notified as long as the user is pressing the button.
    public func gamepadButtonMenuMode(viewID:String = "Default", mode: GamepadManager.ButtonMode) -> some View {
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).buttonMenuMode = mode
        
        return self
    }
    
    /// Defines the mode of operation for gamepad button options in the current `View`.
    ///
    /// For example:
    ///
    /// ```swift
    /// var body: some View {
    ///     Zstack {
    ///       ...
    ///     }
    ///     .gamepadButtonOptionsMode(mode: .continous)
    /// }
    /// ```
    ///
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter mode: The requested mode of operation. The default mode is `stateChanged`.
    /// - Returns: Returns self.
    /// - Remark: If the button's mode is `stateChanged`, then the `View` will only be notified if presses or releases a the button. If the button's mode is `continous`, then the `View` will be notified as long as the user is pressing the button.
    public func gamepadButtonOptionsMode(viewID:String = "Default", mode: GamepadManager.ButtonMode) -> some View {
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).buttonOptionsMode = mode
        
        return self
    }
    
    /// Defines the mode of operation for gamepad button home in the current `View`.
    ///
    /// For example:
    ///
    /// ```swift
    /// var body: some View {
    ///     Zstack {
    ///       ...
    ///     }
    ///     .gamepadButtonHomeMode(mode: .continous)
    /// }
    /// ```
    ///
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter mode: The requested mode of operation. The default mode is `stateChanged`.
    /// - Returns: Returns self.
    /// - Remark: If the button's mode is `stateChanged`, then the `View` will only be notified if presses or releases a the button. If the button's mode is `continous`, then the `View` will be notified as long as the user is pressing the button.
    public func gamepadButtonHomeAMode(viewID:String = "Default", mode: GamepadManager.ButtonMode) -> some View {
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).buttonHomeMode = mode
        
        return self
    }
    
    /// Defines the mode of operation for gamepad button A in the current `View`.
    ///
    /// For example:
    ///
    /// ```swift
    /// var body: some View {
    ///     Zstack {
    ///       ...
    ///     }
    ///     .gamepadButtonAMode(mode: .continous)
    /// }
    /// ```
    ///
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter mode: The requested mode of operation. The default mode is `stateChanged`.
    /// - Returns: Returns self.
    /// - Remark: If the button's mode is `stateChanged`, then the `View` will only be notified if presses or releases a the button. If the button's mode is `continous`, then the `View` will be notified as long as the user is pressing the button.
    public func gamepadButtonAMode(viewID:String = "Default", mode: GamepadManager.ButtonMode) -> some View {
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).buttonAMode = mode
        
        return self
    }
    
    /// Defines the mode of operation for gamepad button B in the current `View`.
    ///
    /// For example:
    ///
    /// ```swift
    /// var body: some View {
    ///     Zstack {
    ///       ...
    ///     }
    ///     .gamepadButtonBMode(mode: .continous)
    /// }
    /// ```
    ///
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter mode: The requested mode of operation. The default mode is `stateChanged`.
    /// - Returns: Returns self.
    /// - Remark: If the button's mode is `stateChanged`, then the `View` will only be notified if presses or releases a the button. If the button's mode is `continous`, then the `View` will be notified as long as the user is pressing the button.
    public func gamepadButtonBMode(viewID:String = "Default", mode: GamepadManager.ButtonMode) -> some View {
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).buttonBMode = mode
        
        return self
    }
    
    /// Defines the mode of operation for gamepad button X in the current `View`.
    ///
    /// For example:
    ///
    /// ```swift
    /// var body: some View {
    ///     Zstack {
    ///       ...
    ///     }
    ///     .gamepadButtonXMode(mode: .continous)
    /// }
    /// ```
    ///
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter mode: The requested mode of operation. The default mode is `stateChanged`.
    /// - Returns: Returns self.
    /// - Remark: If the button's mode is `stateChanged`, then the `View` will only be notified if presses or releases a the button. If the button's mode is `continous`, then the `View` will be notified as long as the user is pressing the button.
    public func gamepadButtonXMode(viewID:String = "Default", mode: GamepadManager.ButtonMode) -> some View {
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).buttonXMode = mode
        
        return self
    }
    
    /// Defines the mode of operation for gamepad button Y in the current `View`.
    ///
    /// For example:
    ///
    /// ```swift
    /// var body: some View {
    ///     Zstack {
    ///       ...
    ///     }
    ///     .gamepadButtonYMode(mode: .continous)
    /// }
    /// ```
    ///
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter mode: The requested mode of operation. The default mode is `stateChanged`.
    /// - Returns: Returns self.
    /// - Remark: If the button's mode is `stateChanged`, then the `View` will only be notified if presses or releases a the button. If the button's mode is `continous`, then the `View` will be notified as long as the user is pressing the button.
    public func gamepadButtonYMode(viewID:String = "Default", mode: GamepadManager.ButtonMode) -> some View {
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).buttonYMode = mode
        
        return self
    }
    
    /// Defines the mode of operation for the gamepad's Dpad in the current `View`.
    ///
    /// For example:
    ///
    /// ```swift
    /// var body: some View {
    ///     Zstack {
    ///       ...
    ///     }
    ///     .gamepadDpadMode(mode: .continous)
    /// }
    /// ```
    ///
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter mode: The requested mode of operation. The default mode is `stateChanged`.
    /// - Returns: Returns self.
    /// - Remark: If the Dpad's mode is `stateChanged`, then the `View` will only be notified if presses or releases a direction button on the Dpad. If the Dpad's mode is `continous`, then the `View` will be notified as long as the user is pressing a direction button on the Dpad.
    public func gamepadDpadMode(viewID:String = "Default", mode: GamepadManager.ButtonMode) -> some View {
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).dpadMode = mode
        
        return self
    }
    
    /// Defines the mode of operation for the gamepad's left thumbstick in the current `View`.
    ///
    /// For example:
    ///
    /// ```swift
    /// var body: some View {
    ///     Zstack {
    ///       ...
    ///     }
    ///     .gamepadLeftThumbstickMode(mode: .directional)
    /// }
    /// ```
    ///
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter mode: The requested mode of operation. The default mode is `analog`.
    /// - Returns: Returns self.
    /// - Remark: In `analog` mode the thumbstick will send a direct reading on the thumbstick's position once. In `directional` mode the thumbstick will continously send how fast the user wants to move in a given direction based on the amount of pressure that the user is applying to the thumbstick.
    public func gamepadLeftThumbstickMode(viewID:String = "Default", mode: GamepadManager.ThumbstickMode) -> some View {
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).leftThumbstickMode = mode
        
        return self
    }
    
    /// Defines the mode of operation for gamepad left thumbstick button in the current `View`.
    ///
    /// For example:
    ///
    /// ```swift
    /// var body: some View {
    ///     Zstack {
    ///       ...
    ///     }
    ///     .gamepadLeftThumbstickButtonMode(mode: .continous)
    /// }
    /// ```
    ///
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter mode: The requested mode of operation. The default mode is `stateChanged`.
    /// - Returns: Returns self.
    /// - Remark: If the button's mode is `stateChanged`, then the `View` will only be notified if presses or releases a the button. If the button's mode is `continous`, then the `View` will be notified as long as the user is pressing the button.
    public func gamepadLeftThumbstickButtonMode(viewID:String = "Default", mode: GamepadManager.ButtonMode) -> some View {
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).leftThumbstickButtonMode = mode
        
        return self
    }
    
    /// Defines the mode of operation for gamepad right thumbstick button in the current `View`.
    ///
    /// For example:
    ///
    /// ```swift
    /// var body: some View {
    ///     Zstack {
    ///       ...
    ///     }
    ///     .gamepadRightThumbstickButtonMode(mode: .continous)
    /// }
    /// ```
    ///
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter mode: The requested mode of operation. The default mode is `stateChanged`.
    /// - Returns: Returns self.
    /// - Remark: If the button's mode is `stateChanged`, then the `View` will only be notified if presses or releases a the button. If the button's mode is `continous`, then the `View` will be notified as long as the user is pressing the button.
    public func gamepadRightThumbstickButtonMode(viewID:String = "Default", mode: GamepadManager.ButtonMode) -> some View {
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).rightThumbstickButtonMode = mode
        
        return self
    }
    
    /// Defines the mode of operation for the gamepad's right thumbstick in the current `View`.
    ///
    /// For example:
    ///
    /// ```swift
    /// var body: some View {
    ///     Zstack {
    ///       ...
    ///     }
    ///     .gamepadRightThumbstickMode(mode: .directional)
    /// }
    /// ```
    ///
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter mode: The requested mode of operation. The default mode is `analog`.
    /// - Returns: Returns self.
    /// - Remark: In `analog` mode the thumbstick will send a direct reading on the thumbstick's position once. In `directional` mode the thumbstick will continously send how fast the user wants to move in a given direction based on the amount of pressure that the user is applying to the thumbstick.
    public func gamepadRightThumbstickMode(viewID:String = "Default", mode: GamepadManager.ThumbstickMode) -> some View {
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).rightThumbstickMode = mode
        
        return self
    }
    
    // !!!: General gamepad event handlers
    /// Allows the `View` to handle a gamepad being connected to the device the app is running on.
    ///
    /// Once the gamepad is connected, the `onGamepadConnected` event will be raised with the `GCController` and the `GamepadInfo` for the attached controller. For example:
    ///
    /// ```swift
    /// var body: some View {
    ///     Zstack {
    ///       ...
    ///     }
    ///     .onGamepadConnected { controller, gamepadInfo in
    ///       ...
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter handler: The handler for the connected event.
    /// - Returns: Returns self.
    ///@discardableResult public func onGamepadConnected(_ handler:@escaping gamepadStatusHandler) -> some View {
    ///
    ///    GamepadManager.gamepadOne.gamepadConnected = handler
        
    ///    return self
    ///}
    
    /// Allows the `View` to handle a gamepad being disconnected from the device the app is running on.
    ///
    /// Once the gamepad is disconnected, the `onGamepadDisconnected` event will be raised with the `GCController` and the `GamepadInfo` for the controller. For example:
    ///
    /// ```swift
    /// var body: some View {
    ///     Zstack {
    ///       ...
    ///     }
    ///     .onGamepadDisconnected { controller, gamepadInfo in
    ///       ...
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter handler: The handler for the disconected event.
    /// - Returns: Returns self.
    @discardableResult public func onGamepadDisconnected(viewID:String = "Default", _ handler:@escaping gamepadStatusHandler) -> some View {
        
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).gamepadDisconnected = handler
        
        return self
    }
    
    /// Allows the `View` to handle the app becoming active.
    ///
    /// For example:
    ///
    /// ```swift
    /// var body: some View {
    ///     Zstack {
    ///       ...
    ///     }
    ///     .onGampadAppBecomingActive {
    ///       reconnectGamepad()
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter handler: The handler for the active event.
    /// - Returns: Returns self.
    @discardableResult public func onGampadAppBecomingActive(viewID:String = "Default", _ handler:@escaping gamepadAppEvent) -> some View {
        
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).gamepadAppIsActive = handler
        
        return self
    }
    
    /// Allows the `View` to handle the app becoming inactive.
    ///
    /// For example:
    ///
    /// ```swift
    /// var body: some View {
    ///     Zstack {
    ///       ...
    ///     }
    ///     .onGampadAppBecomingInactive {
    ///       ...
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter handler: The handler for the active event.
    /// - Returns: Returns self.
    @discardableResult public func onGampadAppBecomingInactive(viewID:String = "Default", _ handler:@escaping gamepadAppEvent) -> some View {
        
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).gamepadAppIsInactive = handler
        
        return self
    }
    
    /// Allows the `View` to handle the app entering the background.
    ///
    /// For example:
    ///
    /// ```swift
    /// var body: some View {
    ///     Zstack {
    ///       ...
    ///     }
    ///     .onGampadAppEnteringBackground {
    ///       ...
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter handler: The handler for the active event.
    /// - Returns: Returns self.
    @discardableResult public func onGampadAppEnteringBackground(viewID:String = "Default", _ handler:@escaping gamepadAppEvent) -> some View {
        
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).gamepadAppInBackground = handler
        
        return self
    }
    
    /// Allows the `View` to handle the user pressing the left shoulder button on the gamepad.
    ///
    /// When the user presses the left shoulder button, the `onGamepadLeftShoulder` event will be raised with the `isPressed` and the `pressure` states for the controller. For example:
    ///
    /// ```swift
    /// var body: some View {
    ///     Zstack {
    ///       ...
    ///     }
    ///     .onGamepadLeftShoulder { isPressed, pressure in
    ///       ...
    ///     }
    /// }
    /// ```
    /// > If the user presses the button the `isPressed` property is `true` and the `pressure` property will be between a minimum of 0.0 and a maximum of 1.0. If the button is not being pressed, the `isPressed` property is `false` and the `pressure` poperty will be 0.0.
    ///
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter handler: The handler for the left shoulder button pressed event.
    /// - Returns: Returns self.
    /// - Remark: This event will only be raised for the following game controllers: Extended Gamepad, Dual Shock Gamepad, XBox Gamepad, Dual Sense Gamepad.
    @discardableResult public func onGamepadLeftShoulder(viewID:String = "Default", _ handler:@escaping gamepadTriggerHandler) -> some View {
        
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).leftShoulderHandler = handler
        
        return self
    }
    
    /// Allows the `View` to handle the user pressing the right shoulder button on the gamepad.
    ///
    /// When the user presses the right shoulder button, the `onGamepadRightShoulder` event will be raised with the `isPressed` and the `pressure` states for the controller. For example:
    ///
    /// ```swift
    /// var body: some View {
    ///     Zstack {
    ///       ...
    ///     }
    ///     .onGamepadRightShoulder { isPressed, pressure in
    ///       ...
    ///     }
    /// }
    /// ```
    /// > If the user presses the button the `isPressed` property is `true` and the `pressure` property will be between a minimum of 0.0 and a maximum of 1.0. If the button is not being pressed, the `isPressed` property is `false` and the `pressure` poperty will be 0.0.
    ///
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter handler: The handler for the right shoulder button pressed event.
    /// - Returns: Returns self.
    /// - Remark: This event will only be raised for the following game controllers: Extended Gamepad, Dual Shock Gamepad, XBox Gamepad, Dual Sense Gamepad.
    @discardableResult public func onGamepadRightShoulder(viewID:String = "Default", _ handler:@escaping gamepadTriggerHandler) -> some View {
        
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).rightShoulderHandler = handler
        
        return self
    }
    
    /// Allows the `View` to handle the user pulling the left trigger on the gamepad.
    ///
    /// When the user pulls the left trigger, the `onGamepadLeftTrigger` event will be raised with the `isPressed` and the `pressure` states for the controller. For example:
    ///
    /// ```swift
    /// var body: some View {
    ///     Zstack {
    ///       ...
    ///     }
    ///     .onGamepadLeftTrigger { isPressed, pressure in
    ///       ...
    ///     }
    /// }
    /// ```
    /// > If the user pulls the trigger the `isPressed` property is `true` and the `pressure` property will be between a minimum of 0.0 and a maximum of 1.0. If the trigger is not being pulled, the `isPressed` property is `false` and the `pressure` poperty will be 0.0.
    ///
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter handler: The handler for the left trigger pulled event.
    /// - Returns: Returns self.
    /// - Remark: This event will only be raised for the following game controllers: Extended Gamepad, Dual Shock Gamepad, XBox Gamepad, Dual Sense Gamepad.
    @discardableResult public func onGamepadLeftTrigger(viewID:String = "Default", _ handler:@escaping gamepadTriggerHandler) -> some View {
        
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).leftTriggerHandler = handler
        
        return self
    }
    
    /// Allows the `View` to handle the user pulling the right trigger on the gamepad.
    ///
    /// When the user pulls the right trigger, the `onGamepadLeftTrigger` event will be raised with the `isPressed` and the `pressure` states for the controller. For example:
    ///
    /// ```swift
    /// var body: some View {
    ///     Zstack {
    ///       ...
    ///     }
    ///     .onGamepadRightTrigger { isPressed, pressure in
    ///       ...
    ///     }
    /// }
    /// ```
    /// > If the user pulls the trigger the `isPressed` property is `true` and the `pressure` property will be between a minimum of 0.0 and a maximum of 1.0. If the trigger is not being pulled, the `isPressed` property is `false` and the `pressure` poperty will be 0.0.
    ///
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter handler: The handler for the right trigger pulled event.
    /// - Returns: Returns self.
    /// - Remark: This event will only be raised for the following game controllers: Extended Gamepad, Dual Shock Gamepad, XBox Gamepad, Dual Sense Gamepad.
    @discardableResult public func onGamepadRightTrigger(viewID:String = "Default", _ handler:@escaping gamepadTriggerHandler) -> some View {
        
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).rightTriggerHandler = handler
        
        return self
    }
    
    /// Allows the `View` to handle the user pressing the Menu button on the gamepad.
    ///
    /// When the user pushes the Menu button, the `onGamepadButtonMenu` event will be raised with the `isPressed` state for the controller. For example:
    ///
    /// ```swift
    /// var body: some View {
    ///     Zstack {
    ///       ...
    ///     }
    ///     .onGamepadButtonMenu { isPressed in
    ///       ...
    ///     }
    /// }
    /// ```
    /// > If the user presses the button, the `isPressed` property is `true`, else if the user is not pressing the button, the `isPressed` property is `false`.
    ///
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter handler: The handler for the Menu button pressed event.
    /// - Returns: Returns self.
    /// - Remark: This event will only be raised for the following game controllers: Extended Gamepad, Dual Shock Gamepad, XBox Gamepad, Dual Sense Gamepad, Micro Gamepad, Directional Gamepad.
    @discardableResult public func onGamepadButtonMenu(viewID:String = "Default", _ handler:@escaping gamepadButtonHandler) -> some View {
        
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).buttonMenu = handler
        
        return self
    }
    
    /// Allows the `View` to handle the user pressing the Option button on the gamepad.
    ///
    /// When the user pushes the Option button, the `onGamepadButtonOptions` event will be raised with the `isPressed` state for the controller. For example:
    ///
    /// ```swift
    /// var body: some View {
    ///     Zstack {
    ///       ...
    ///     }
    ///     .onGamepadButtonOptions { isPressed in
    ///       ...
    ///     }
    /// }
    /// ```
    /// > If the user presses the button, the `isPressed` property is `true`, else if the user is not pressing the button, the `isPressed` property is `false`.
    ///
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter handler: The handler for the Option button pressed event.
    /// - Returns: Returns self.
    /// - Remark: This event will only be raised for the following game controllers: Extended Gamepad, Dual Shock Gamepad, XBox Gamepad, Dual Sense Gamepad.
    @discardableResult public func onGamepadButtonOptions(viewID:String = "Default", _ handler:@escaping gamepadButtonHandler) -> some View {
        
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).buttonOptions = handler
        
        return self
    }
    
    /// Allows the `View` to handle the user pressing the Home button on the gamepad.
    ///
    /// When the user pushes the Home button, the `onGamepadButtonHome` event will be raised with the `isPressed` state for the controller. For example:
    ///
    /// ```swift
    /// var body: some View {
    ///     Zstack {
    ///       ...
    ///     }
    ///     .onGamepadButtonHome { isPressed in
    ///       ...
    ///     }
    /// }
    /// ```
    /// > If the user presses the button, the `isPressed` property is `true`, else if the user is not pressing the button, the `isPressed` property is `false`.
    ///
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter handler: The handler for the Home button pressed event.
    /// - Returns: Returns self.
    /// - Remark: This event will only be raised for the following game controllers: Extended Gamepad, Dual Shock Gamepad, XBox Gamepad, Dual Sense Gamepad.
    @discardableResult public func onGamepadButtonHome(viewID:String = "Default", _ handler:@escaping gamepadButtonHandler) -> some View {
        
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).buttonHome = handler
        
        return self
    }
    
    /// Allows the `View` to handle the user pressing the A button on the gamepad. This will be the X button on a Sony Dual Shock or Dual Sense controller.
    ///
    /// When the user pushes the A button, the `onGamepadButtonA` event will be raised with the `isPressed` state for the controller. For example:
    ///
    /// ```swift
    /// var body: some View {
    ///     Zstack {
    ///       ...
    ///     }
    ///     .onGamepadButtonA { isPressed in
    ///       ...
    ///     }
    /// }
    /// ```
    /// > If the user presses the button, the `isPressed` property is `true`, else if the user is not pressing the button, the `isPressed` property is `false`.
    ///
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter handler: The handler for the A button pressed event.
    /// - Returns: Returns self.
    /// - Remark: This event will only be raised for the following game controllers: Extended Gamepad, Dual Shock Gamepad, XBox Gamepad, Dual Sense Gamepad, Micro Gamepad, Directional Gamepad.
    @discardableResult public func onGamepadButtonA(viewID:String = "Default", _ handler:@escaping gamepadButtonHandler) -> some View {
        
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).buttonA = handler
        
        return self
    }
    
    /// Allows the `View` to handle the user pressing the B button on the gamepad. This will be the Circle button on a Sony Dual Shock or Dual Sense controller.
    ///
    /// When the user pushes the B button, the `onGamepadButtonB` event will be raised with the `isPressed` state for the controller. For example:
    ///
    /// ```swift
    /// var body: some View {
    ///     Zstack {
    ///       ...
    ///     }
    ///     .onGamepadButtonB { isPressed in
    ///       ...
    ///     }
    /// }
    /// ```
    /// > If the user presses the button, the `isPressed` property is `true`, else if the user is not pressing the button, the `isPressed` property is `false`.
    ///
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter handler: The handler for the B button pressed event.
    /// - Returns: Returns self.
    /// - Remark: This event will only be raised for the following game controllers: Extended Gamepad, Dual Shock Gamepad, XBox Gamepad, Dual Sense Gamepad.
    @discardableResult public func onGamepadButtonB(viewID:String = "Default", _ handler:@escaping gamepadButtonHandler) -> some View {
        
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).buttonB = handler
        
        return self
    }
    
    /// Allows the `View` to handle the user pressing the X button on the gamepad. This will be the Square button on a Sony Dual Shock or Dual Sense controller.
    ///
    /// When the user pushes the X button, the `onGamepadButtonX` event will be raised with the `isPressed` state for the controller. For example:
    ///
    /// ```swift
    /// var body: some View {
    ///     Zstack {
    ///       ...
    ///     }
    ///     .onGamepadButtonX { isPressed in
    ///       ...
    ///     }
    /// }
    /// ```
    /// > If the user presses the button, the `isPressed` property is `true`, else if the user is not pressing the button, the `isPressed` property is `false`.
    ///
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter handler: The handler for the X button pressed event.
    /// - Returns: Returns self.
    /// - Remark: This event will only be raised for the following game controllers: Extended Gamepad, Dual Shock Gamepad, XBox Gamepad, Dual Sense Gamepad, Micro Gamepad, Directional Gamepad.
    @discardableResult public func onGamepadButtonX(viewID:String = "Default", _ handler:@escaping gamepadButtonHandler) -> some View {
        
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).buttonX = handler
        
        return self
    }
    
    /// Allows the `View` to handle the user pressing the Y button on the gamepad. This will be the Triangle button on a Sony Dual Shock or Dual Sense controller.
    ///
    /// When the user pushes the Y button, the `onGamepadButtonY` event will be raised with the `isPressed` state for the controller. For example:
    ///
    /// ```swift
    /// var body: some View {
    ///     Zstack {
    ///       ...
    ///     }
    ///     .onGamepadButtonY { isPressed in
    ///       ...
    ///     }
    /// }
    /// ```
    /// > If the user presses the button, the `isPressed` property is `true`, else if the user is not pressing the button, the `isPressed` property is `false`.
    ///
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter handler: The handler for the Y button pressed event.
    /// - Returns: Returns self.
    /// - Remark: This event will only be raised for the following game controllers: Extended Gamepad, Dual Shock Gamepad, XBox Gamepad, Dual Sense Gamepad.
    @discardableResult public func onGamepadButtonY(viewID:String = "Default", _ handler:@escaping gamepadButtonHandler) -> some View {
        
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).buttonY = handler
        
        return self
    }
    
    /// Allows the `View` to handle the user presses a button on the Dpad on the gamepad.
    ///
    /// When the user pushes a button on the Dpad, the `onDpad` event will be raised with the `xAxis` and `yAxis` states for the controller. For example:
    ///
    /// ```swift
    /// var body: some View {
    ///     Zstack {
    ///       ...
    ///     }
    ///     .onDpad { xAxis, yAxis in
    ///       ...
    ///     }
    /// }
    /// ```
    /// > When the user presses a button on the Dpad the `xAxis` and `yAxis` values will be between -1.0 and 1.0. If a button is not being pressed, the `xAxis` and `yAxis` values will return 0.0. You can optionally translate these values into up, down, left and right directions using the `GamepadMovementDirection.moving(x,y)` static function.
    ///
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter handler: The handler for a button on the Dpad pressed event.
    /// - Returns: Returns self.
    /// - Remark: This event will only be raised for the following game controllers: Extended Gamepad, Dual Shock Gamepad, XBox Gamepad, Dual Sense Gamepad, Micro Gamepad, Directional Gamepad.
    @discardableResult public func onGamepadDpad(viewID:String = "Default", _ handler:@escaping gamepadDirectionHandler) -> some View {
        
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).dpad = handler
        
        return self
    }
    
    /// Allows the `View` to handle the user moves the left thumbstick on the gamepad.
    ///
    /// When the user moves the left thumbstick, the `onLeftThumbstick` event will be raised with the `xAxis` and `yAxis` states for the controller. For example:
    ///
    /// ```swift
    /// var body: some View {
    ///     Zstack {
    ///       ...
    ///     }
     ///     .onLeftThumbstick { xAxis, yAxis in
    ///       ...
    ///     }
    /// }
    /// ```
    /// > When the user moves the thumbsitck, the `xAxis` and `yAxis` values will be between -1.0 and 1.0. If the thumbstick is not being moved, the `xAxis` and `yAxis` values will return 0.0. You can optionally translate these values into up, down, left and right directions using the `GamepadMovementDirection.moving(x,y)` static function.
    ///
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter handler: The handler for the left thumbstick moved event.
    /// - Returns: Returns self.
    /// - Remark: This event will only be raised for the following game controllers: Extended Gamepad, Dual Shock Gamepad, XBox Gamepad, Dual Sense Gamepad.
    @discardableResult public func onGamepadLeftThumbstick(viewID:String = "Default", _ handler:@escaping gamepadDirectionHandler) -> some View {
        
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).leftThumbstick = handler
        
        return self
    }
    
    /// Allows the `View` to handle the user moves the right thumbstick on the gamepad.
    ///
    /// When the user moves the right thumbstick, the `onRightThumbstick` event will be raised with the `xAxis` and `yAxis` states for the controller. For example:
    ///
    /// ```swift
    /// var body: some View {
    ///     Zstack {
    ///       ...
    ///     }
    ///     .onRightThumbstick { xAxis, yAxis in
    ///       ...
    ///     }
    /// }
    /// ```
    /// > When the user moves the thumbsitck, the `xAxis` and `yAxis` values will be between -1.0 and 1.0. If the thumbstick is not being moved, the `xAxis` and `yAxis` values will return 0.0. You can optionally translate these values into up, down, left and right directions using the `GamepadMovementDirection.moving(x,y)` static function.
    ///
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter handler: The handler for the right thumbstick moved event.
    /// - Returns: Returns self.
    /// - Remark: This event will only be raised for the following game controllers: Extended Gamepad, Dual Shock Gamepad, XBox Gamepad, Dual Sense Gamepad.
    @discardableResult public func onGamepadRightThumbstick(viewID:String = "Default", _ handler:@escaping gamepadDirectionHandler) -> some View {
        
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).rightThumbstick = handler
        
        return self
    }
    
    /// Allows the `View` to handle the user pressing the left thumbstick button on the gamepad.
    ///
    /// When the user pushes the left thumbstick button, the `onGamepadLeftThumbstickButton` event will be raised with the `isPressed` state for the controller. For example:
    ///
    /// ```swift
    /// var body: some View {
    ///     Zstack {
    ///       ...
    ///     }
    ///     .onGamepadLeftThumbstickButton { isPressed in
    ///       ...
    ///     }
    /// }
    /// ```
    /// > If the user presses the button, the `isPressed` property is `true`, else if the user is not pressing the button, the `isPressed` property is `false`.
    ///
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter handler: The handler for the left thumbstick button pressed event.
    /// - Returns: Returns self.
    /// - Remark: This event will only be raised for the following game controllers: Extended Gamepad, Dual Shock Gamepad, XBox Gamepad, Dual Sense Gamepad.
    @discardableResult public func onGamepadLeftThumbstickButton(viewID:String = "Default", _ handler:@escaping gamepadButtonHandler) -> some View {
        
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).leftThumbstickButton = handler
        
        return self
    }
    
    /// Allows the `View` to handle the user pressing the right thumbstick button on the gamepad.
    ///
    /// When the user pushes the right thumbstick button, the `onGamepadRightThumbstickButton` event will be raised with the `isPressed` state for the controller. For example:
    ///
    /// ```swift
    /// var body: some View {
    ///     Zstack {
    ///       ...
    ///     }
    ///     .onGamepadRightThumbstickButton { isPressed in
    ///       ...
    ///     }
    /// }
    /// ```
    /// > If the user presses the button, the `isPressed` property is `true`, else if the user is not pressing the button, the `isPressed` property is `false`.
    ///
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter handler: The handler for the right thumbstick button pressed event.
    /// - Returns: Returns self.
    /// - Remark: This event will only be raised for the following game controllers: Extended Gamepad, Dual Shock Gamepad, XBox Gamepad, Dual Sense Gamepad.
    @discardableResult public func onGamepadRightThumbstickButton(viewID:String = "Default", _ handler:@escaping gamepadButtonHandler) -> some View {
        
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).rightThumbstickButton = handler
        
        return self
    }
    
    // !!!: Sony Dual Shock specific events
    /// Allows the `View` to handle the user pressing the touchpad button on a Sony Dual Shock or Dual Sense gamepad.
    ///
    /// When the user pushes the touchpad button, the `onGamepadTouchpadButton` event will be raised with the `isPressed` state for the controller. For example:
    ///
    /// ```swift
    /// var body: some View {
    ///     Zstack {
    ///       ...
    ///     }
    ///     .onGamepadTouchpadButton { isPressed in
    ///       ...
    ///     }
    /// }
    /// ```
    /// > If the user presses the button, the `isPressed` property is `true`, else if the user is not pressing the button, the `isPressed` property is `false`.
    ///
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter handler: The handler for the touchpad button pressed event.
    /// - Returns: Returns self.
    /// - Remark: This event will only be raised for the following game controllers: Dual Shock Gamepad, Dual Sense Gamepad.
    @discardableResult public func onGamepadTouchpadButton(viewID:String = "Default", _ handler:@escaping gamepadButtonHandler) -> some View {
        
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).touchpadButton = handler
        
        return self
    }
    
    /// Allows the `View` to handle the user swiping with one finger on the touchpad of a Sony Dual Shock or Dual Sense gamepad.
    ///
    /// When the user swipes the thumbpad with one finger, the `onTouchpadPrimary` event will be raised with the `xAxis` and `yAxis` states for the controller. For example:
    ///
    /// ```swift
    /// var body: some View {
    ///     Zstack {
    ///       ...
    ///     }
    ///     .onTouchpadPrimary { xAxis, yAxis in
    ///       ...
    ///     }
    /// }
    /// ```
    /// > When the user swipes the touchpad, the `xAxis` and `yAxis` values will be between -1.0 and 1.0. If the thumbstick is not being swiped, the `xAxis` and `yAxis` values will return 0.0. You can optionally translate these values into up, down, left and right directions using the `GamepadMovementDirection.moving(x,y)` static function.
    ///
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter handler: The handler for swiping with one finger on the touchpad event.
    /// - Returns: Returns self.
    /// - Remark: This event will only be raised for the following game controllers: Dual Shock Gamepad, Dual Sense Gamepad.
    @discardableResult public func onTouchpadPrimary(viewID:String = "Default", _ handler:@escaping gamepadDirectionHandler) -> some View {
        
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).touchpadPrimary = handler
        
        return self
    }
    
    /// Allows the `View` to handle the user swiping with two fingers on the touchpad of a Sony Dual Shock or Dual Sense gamepad.
    ///
    /// When the user swipes the thumbpad with two fingers, the `onTouchpadSecondary` event will be raised with the `xAxis` and `yAxis` states for the controller. For example:
    ///
    /// ```swift
    /// var body: some View {
    ///     Zstack {
    ///       ...
    ///     }
    ///     .onTouchpadSecondary { xAxis, yAxis in
    ///       ...
    ///     }
    /// }
    /// ```
    /// > When the user swipes the touchpad, the `xAxis` and `yAxis` values will be between -1.0 and 1.0. If the thumbstick is not being swiped, the `xAxis` and `yAxis` values will return 0.0. You can optionally translate these values into up, down, left and right directions using the `GamepadMovementDirection.moving(x,y)` static function.
    ///
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter handler: The handler for swiping with two fingers on the touchpad event.
    /// - Returns: Returns self.
    /// - Remark: This event will only be raised for the following game controllers: Dual Shock Gamepad, Dual Sense Gamepad.
    @discardableResult public func onTouchpadSecondary(viewID:String = "Default", _ handler:@escaping gamepadDirectionHandler) -> some View {
        
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).touchpadSecondary = handler
        
        return self
    }
    
    // !!!: Xbox controller specific events
    /// Allows the `View` to handle the user pressing paddle button 1 on an Xbox  gamepad.
    ///
    /// When the user pushes the paddle button 1, the `onPaddleButtonOne` event will be raised with the `isPressed` state for the controller. For example:
    ///
    /// ```swift
    /// var body: some View {
    ///     Zstack {
    ///       ...
    ///     }
    ///     .onPaddleButtonOne { isPressed in
    ///       ...
    ///     }
    /// }
    /// ```
    /// > If the user presses the button, the `isPressed` property is `true`, else if the user is not pressing the button, the `isPressed` property is `false`.
    ///
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter handler: The handler for the paddle button 1 pressed event.
    /// - Returns: Returns self.
    /// - Remark: This event will only be raised for the following game controllers: XBox Gamepad.
    @discardableResult public func onPaddleButtonOne(viewID:String = "Default", _ handler:@escaping gamepadButtonHandler) -> some View {
        
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).paddleButton1 = handler
        
        return self
    }
    
    /// Allows the `View` to handle the user pressing paddle button 2 on an Xbox  gamepad.
    ///
    /// When the user pushes the paddle button 2, the `onPaddleButtonTwo` event will be raised with the `isPressed` state for the controller. For example:
    ///
    /// ```swift
    /// var body: some View {
    ///     Zstack {
    ///       ...
    ///     }
    ///     .onPaddleButtonTwo { isPressed in
    ///       ...
    ///     }
    /// }
    /// ```
    /// > If the user presses the button, the `isPressed` property is `true`, else if the user is not pressing the button, the `isPressed` property is `false`.
    ///
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter handler: The handler for the paddle button 2 pressed event.
    /// - Returns: Returns self.
    /// - Remark: This event will only be raised for the following game controllers: XBox Gamepad.
    @discardableResult public func onPaddleButtonTwo(viewID:String = "Default", _ handler:@escaping gamepadButtonHandler) -> some View {
        
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).paddleButton2 = handler
        
        return self
    }
    
    /// Allows the `View` to handle the user pressing paddle button 3 on an Xbox  gamepad.
    ///
    /// When the user pushes the paddle button 3, the `onPaddleButtonThree` event will be raised with the `isPressed` state for the controller. For example:
    ///
    /// ```swift
    /// var body: some View {
    ///     Zstack {
    ///       ...
    ///     }
    ///     .onPaddleButtonThree { isPressed in
    ///       ...
    ///     }
    /// }
    /// ```
    /// > If the user presses the button, the `isPressed` property is `true`, else if the user is not pressing the button, the `isPressed` property is `false`.
    ///
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter handler: The handler for the paddle button 3 pressed event.
    /// - Returns: Returns self.
    /// - Remark: This event will only be raised for the following game controllers: XBox Gamepad.
    @discardableResult public func onPaddleButtonThree(viewID:String = "Default", _ handler:@escaping gamepadButtonHandler) -> some View {
        
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).paddleButton3 = handler
        
        return self
    }
    
    /// Allows the `View` to handle the user pressing paddle button 4 on an Xbox  gamepad.
    ///
    /// When the user pushes the paddle button 4, the `onPaddleButtonFour` event will be raised with the `isPressed` state for the controller. For example:
    ///
    /// ```swift
    /// var body: some View {
    ///     Zstack {
    ///       ...
    ///     }
    ///     .onPaddleButtonFour { isPressed in
    ///       ...
    ///     }
    /// }
    /// ```
    /// > If the user presses the button, the `isPressed` property is `true`, else if the user is not pressing the button, the `isPressed` property is `false`.
    ///
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter handler: The handler for the paddle button 4 pressed event.
    /// - Returns: Returns self.
    /// - Remark: This event will only be raised for the following game controllers: XBox Gamepad.
    @discardableResult public func onPaddleButtonFour(viewID:String = "Default", _ handler:@escaping gamepadButtonHandler) -> some View {
        
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).paddleButton4 = handler
        
        return self
    }
    
    /// Allows the `View` to handle the user pressing the share button on an Xbox  gamepad.
    ///
    /// When the user pushes the share button, the `onButtonShare` event will be raised with the `isPressed` state for the controller. For example:
    ///
    /// ```swift
    /// var body: some View {
    ///     Zstack {
    ///       ...
    ///     }
    ///     .onButtonShare { isPressed in
    ///       ...
    ///     }
    /// }
    /// ```
    /// > If the user presses the button, the `isPressed` property is `true`, else if the user is not pressing the button, the `isPressed` property is `false`.
    ///
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter handler: The handler for the share button pressed event.
    /// - Returns: Returns self.
    /// - Remark: This event will only be raised for the following game controllers: XBox Gamepad.
    @discardableResult public func onButtonShare(viewID:String = "Default", _ handler:@escaping gamepadButtonHandler) -> some View {
        
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).buttonShare = handler
        
        return self
    }
    
    // !!!: Control Usage Definitions
    /// Sets the usage description for the left shoulder button
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter usage: The usage description.
    public func leftShoulderUsage(viewID:String = "Default", _ usage:String) {
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).leftShoulderUsage = usage
    }
    
    /// Sets the usage description for the right shoulder button
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter usage: The usage description.
    public func rightShoulderUsage(viewID:String = "Default", _ usage:String) {
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).rightShoulderUsage = usage
    }
    
    /// Sets the usage description for the left trigger button
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter usage: The usage description.
    public func leftTriggerUsage(viewID:String = "Default", _ usage:String) {
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).leftTriggerUsage = usage
    }
    
    /// Sets the usage description for the right trigger button
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter usage: The usage description.
    public func rightTriggerUsage(viewID:String = "Default", _ usage:String) {
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).rightTriggerUsage = usage
    }
    
    /// Sets the usage description for the menu button
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter usage: The usage description.
    public func buttonMenuUsage(viewID:String = "Default", _ usage:String) {
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).buttonMenuUsage = usage
    }
    
    /// Sets the usage description for the options button
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter usage: The usage description.
    public func buttonOptionsUsage(viewID:String = "Default", _ usage:String) {
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).buttonOptionsUsage = usage
    }
    
    /// Sets the usage description for the home button
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter usage: The usage description.
    public func buttonHomeUsage(viewID:String = "Default", _ usage:String) {
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).buttonHomeUsage = usage
    }
    
    /// Sets the usage description for the A button
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter usage: The usage description.
    public func buttonAUsage(viewID:String = "Default", _ usage:String) {
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).buttonAUsage = usage
    }
    
    /// Sets the usage description for the B button
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter usage: The usage description.
    public func buttonBUsage(viewID:String = "Default", _ usage:String) {
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).buttonBUsage = usage
    }
    
    /// Sets the usage description for the X button
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter usage: The usage description.
    public func buttonXUsage(viewID:String = "Default", _ usage:String) {
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).buttonXUsage = usage
    }
    
    /// Sets the usage description for the Y button
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter usage: The usage description.
    public func buttonYUsage(viewID:String = "Default", _ usage:String) {
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).buttonYUsage = usage
    }
    
    /// Sets the usage description for the DPad
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter usage: The usage description.
    public func dpadUsage(viewID:String = "Default", _ usage:String) {
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).dpadUsage = usage
    }
    
    /// Sets the usage description for the left thumbstick
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter usage: The usage description.
    public func leftThumbstickUsage(viewID:String = "Default", _ usage:String) {
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).leftThumbstickUsage = usage
    }
    
    /// Sets the usage description for the right thumbstick
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter usage: The usage description.
    public func rightThumbstickUsage(viewID:String = "Default", _ usage:String) {
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).rightThumbstickUsage = usage
    }
    
    /// Sets the usage description for the left thumbstick Button
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter usage: The usage description.
    public func leftThumbstickButtonUsage(viewID:String = "Default", _ usage:String) {
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).leftThumbstickButtonUsage = usage
    }
    
    /// Sets the usage description for the right thumbstick Button
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter usage: The usage description.
    public func rightThumbstickButtonUsage(viewID:String = "Default", _ usage:String) {
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).rightThumbstickButtonUsage = usage
    }
    
    /// Sets the usage description for the touchpad Button
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter usage: The usage description.
    public func touchpadButtonUsage(viewID:String = "Default", _ usage:String) {
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).touchpadButtonUsage = usage
    }
    
    /// Sets the usage description for the touchpad primary
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter usage: The usage description.
    public func touchpadPrimaryUsage(viewID:String = "Default", _ usage:String) {
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).touchpadPrimaryUsage = usage
    }
    
    /// Sets the usage description for the touchpad secondary
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter usage: The usage description.
    public func touchpadSecondaryUsage(viewID:String = "Default", _ usage:String) {
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).touchpadSecondaryUsage = usage
    }
    
    /// Sets the usage description for the paddle button 1.
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter usage: The usage description.
    public func paddleButtonOneUsage(viewID:String = "Default", _ usage:String) {
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).paddleButton1Usage = usage
    }
    
    /// Sets the usage description for the paddle button 2.
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter usage: The usage description.
    public func paddleButtonTwoUsage(viewID:String = "Default", _ usage:String) {
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).paddleButton2Usage = usage
    }
    
    /// Sets the usage description for the paddle button 3.
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter usage: The usage description.
    public func paddleButtonThreeUsage(viewID:String = "Default", _ usage:String) {
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).paddleButton3Usage = usage
    }
    
    /// Sets the usage description for the paddle button 4.
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter usage: The usage description.
    public func paddleButtonFourUsage(viewID:String = "Default", _ usage:String) {
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).paddleButton1Usage = usage
    }
    
    /// Sets the usage description for the share button.
    /// - Parameter viewID: The unique ID of the view this property is being defined for.
    /// - Parameter usage: The usage description.
    public func buttonShareUsage(viewID:String = "Default", _ usage:String) {
        GamepadManager.gamepadOne.fetchHandlers(for: viewID).buttonShareUsage = usage
    }
}
