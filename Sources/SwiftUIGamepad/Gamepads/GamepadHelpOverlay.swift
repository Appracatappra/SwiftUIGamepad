//
//  GamepadHelpOverlay.swift
//  ReedWriteCycle (iOS)
//
//  Created by Kevin Mullins on 11/10/22.
//

import SwiftUI
import SwiftletUtilities
import SwiftUIKit

/// Custom control to automatically displays full screen help descriptions for any gamepad control that has been mapped to the SwiftUI `View` that this control is displayed on.
///
/// When the gamepad connects to the view, use the `xxxUsage` function to define what your app is using the gamepad control for where `xxx` is the name of a gamepad control such as `buttonMenu` or `buttonB`.
///
/// For Example:
/// ```
/// let viewID = "PanoView"
///
/// var body: some View {
/// ZStack {
/// }
/// .gamepadLeftThumbstickMode(viewID: viewID, mode: .directional)
/// .onAppear {
///     connectGamepad(viewID: viewID, handler: { controller, gamepadInfo in
///         isGamepadConnected = true
///         buttonMenuUsage(viewID: viewID, "Return to the **Cover Page Menu**.")
///         buttonAUsage(viewID: viewID, "Show or hide **Gamepad Help** or hide any **Tips** currently being displayed.")
///         leftThumbstickUsage(viewID: viewID, "Look around the current location.")
///         buttonBUsage(viewID: viewID, "Show or hide the **Function Menu**.")
///         buttonXUsage(viewID: viewID, "Selects a **Menu Item** or activates a **Navigation** or **Interaction** marker.")
///        buttonYUsage(viewID: viewID, "Shows or hides the page **Transscript**.")
///     })
/// }
/// ```
/// - Remark: When working with `SwiftUIGamepad` be sure the pass in a `viewID` that is unique to the current SwiftUI `View`. Failing to provide a unique ID can result in undefined behavior where event are sent to the wrong `View` or are released before they should be.
public struct GamepadHelpOverlay: View {
    
    // MARK: - Properties
    /// The image to display behind the gamepad help screen. If empty (`""`), no image will be displayed.
    public var pageBackground:String = SwiftUIGamepad.defaultHelpBackgroundImage
    
    /// The background color for the gamepad help.
    public var backgroundColor:Color = SwiftUIGamepad.defaultHelpBackgroundColor
    
    // MARK: - Computed Properties
    /// Defines the item padding based on the device type.
    public var padding:CGFloat {
        if HardwareInformation.isPhone {
            return 20
        } else {
            return 100
        }
    }
    
    /// Gets the currently connected gamepad.
    public var gamepad: GamepadManager {
        return GamepadManager.gamepadOne
    }
    
    /// Gets the battery level as a percent for the currently connected gamepad.
    public var batteryLevel:Int {
        return Int(GamepadManager.gampadBatteryLevel * 100.0)
    }
    
    /// Gets the battery level icon for the given gamepad percent.
    public var batteryIcon:String {
        if GamepadManager.gamepadIsBatteryCharging {
            return "battery.100.bolt"
        } else if batteryLevel < 25 {
            return "battery.0"
        } else if batteryLevel > 24 && batteryLevel < 50 {
            return "battery.25"
        } else if batteryLevel > 49 && batteryLevel < 75 {
            return "battery.50"
        } else if batteryLevel > 74 && batteryLevel < 100 {
            return "battery.75"
        }
        
        return "battery.100"
    }
    
    // MARK: - Initializers
    /// Creates a new instance.
    /// - Parameters:
    ///   - pageBackground: The image to display behind the gamepad help screen. If empty (`""`), no image will be displayed.
    ///   - backgroundColor: The background color for the gamepad help.
    public init(pageBackground: String = SwiftUIGamepad.defaultHelpBackgroundImage, backgroundColor: Color = SwiftUIGamepad.defaultHelpBackgroundColor) {
        self.pageBackground = pageBackground
        self.backgroundColor = backgroundColor
    }
    
    // MARK: - Control Body
    /// The body of the control.
    public var body: some View {
        mainContents()
            .background(backgroundColor)
    }
    
    // MARK: - Functions
    @ViewBuilder private func mainContents() -> some View {
        #if os(tvOS)
        tvBody()
        #else
        if HardwareInformation.isPad {
            switch HardwareInformation.deviceOrientation {
            case .landscapeLeft, .landscapeRight:
                tvBody()
            default:
                mobileBody()
            }
        } else {
            mobileBody()
        }
        #endif
    }
    
    @ViewBuilder private func tvBody() -> some View {
        ZStack {
            if pageBackground != "" {
                if SwiftUIGamepad.imageLocation == .appBundle {
                    Image(pageBackground)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: CGFloat(HardwareInformation.screenWidth), height: CGFloat(HardwareInformation.screenHeight))
                } else {
                    let url = SwiftUIGamepad.urlTo(resource: pageBackground, withExtension: "png")
                    ScaledImageView(imageURL: url, scale: 1.0, ignoreSafeArea: true)
                }
            }
            
            HStack {
                VStack(spacing: 5.0) {
                    Text(gamepad.gampadInfo.vendorName)
                        .font(.title2)
                        .foregroundColor(Color.white)
                        .padding(.bottom)
                    
                    if SwiftUIGamepad.imageLocation == .appBundle {
                        ScaledImageView(imageName: gamepad.gampadInfo.gamepadImage, scale: 0.50)
                    } else {
                        let url = SwiftUIGamepad.urlTo(resource: gamepad.gampadInfo.gamepadImage, withExtension: "png")
                        ScaledImageView(imageURL: url, scale: 0.5, ignoreSafeArea: true)
                    }
                    
                    HStack(spacing: 5.0) {
                        Text("\(GamepadManager.gamepadProductCategory) ")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                        
                        Image(systemName: batteryIcon)
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                        
                        if batteryLevel < 0 {
                            Text("?")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                        } else {
                            Text("\(batteryLevel) %")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                        }
                        
                        if GamepadManager.gamepadSupportsHaptics {
                            Text("Supports Haptics")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                        } else {
                            Text("Does Not Supports Haptics")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                        }
                    }
                    
                    Triggers()
                    
                    Thumbsticks()
                    
                }
                VStack(spacing: 5.0) {
                    Buttons()
                    
                    PS4()
                    
                    XBox()
                    
                }
            }
            .frame(width: CGFloat(HardwareInformation.screenWidth), height: CGFloat(HardwareInformation.screenHeight))
            .ignoresSafeArea()
            .background(.clear) // Color("GamepadBackground")
        }
        
    }
    
    @ViewBuilder private func mobileBody() -> some View {
        ZStack {
            if pageBackground != "" {
                if SwiftUIGamepad.imageLocation == .appBundle {
                    Image(pageBackground)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: CGFloat(HardwareInformation.screenWidth), height: CGFloat(HardwareInformation.screenHeight))
                } else {
                    let url = SwiftUIGamepad.urlTo(resource: pageBackground, withExtension: "png")
                    ScaledImageView(imageURL: url, scale: 1.0, ignoreSafeArea: true)
                }
            }
            
            VStack {
                Text(gamepad.gampadInfo.vendorName)
                    .font(.title)
                    .foregroundColor(Color.white)
                    .padding(.bottom)
                
                ScrollView {
                    VStack {
                        if SwiftUIGamepad.imageLocation == .appBundle {
                            if HardwareInformation.isPhone {
                                ScaledImageView(imageName: gamepad.gampadInfo.gamepadImage, scale: 0.40)
                            } else {
                                ScaledImageView(imageName: gamepad.gampadInfo.gamepadImage, scale: 0.80)
                            }
                        } else {
                            let url = SwiftUIGamepad.urlTo(resource: gamepad.gampadInfo.gamepadImage, withExtension: "png")
                            if HardwareInformation.isPhone {
                                ScaledImageView(imageURL: url, scale: 0.40, ignoreSafeArea: true)
                            } else {
                                ScaledImageView(imageURL: url, scale: 0.80, ignoreSafeArea: true)
                            }
                        }
                        
                        Triggers()
                        
                        Buttons()
                        
                        Thumbsticks()
                        
                        PS4()
                        
                        XBox()
                    }
                }
                .frame(width: CGFloat(HardwareInformation.screenWidth - 4), height: CGFloat(HardwareInformation.screenHeight - HardwareInformation.tipPaddingVertical))
            }
            .ignoresSafeArea()
            .background(.clear)
            .frame(width: CGFloat(HardwareInformation.screenWidth), height: CGFloat(HardwareInformation.screenHeight))
        }
    }
    
    @ViewBuilder private func Triggers() -> some View {
        Group {
            if gamepad.leftShoulderHandler != nil {
                GamepadHelpEntry(iconName: gamepad.gampadInfo.leftShoulderImage, controlTitle: gamepad.gampadInfo.leftShoulderTitle, controlUsage: gamepad.leftShoulderUsage)
            }
            
            if gamepad.rightShoulderHandler != nil {
                GamepadHelpEntry(iconName: gamepad.gampadInfo.rightShoulderImage, controlTitle: gamepad.gampadInfo.rightShoulderTitle, controlUsage: gamepad.rightShoulderUsage)
            }
            
            if gamepad.leftTriggerHandler != nil {
                GamepadHelpEntry(iconName: gamepad.gampadInfo.leftTriggerImage, controlTitle: gamepad.gampadInfo.leftTriggerTitle, controlUsage: gamepad.leftTriggerUsage)
            }
            
            if gamepad.rightTriggerHandler != nil {
                GamepadHelpEntry(iconName: gamepad.gampadInfo.rightTriggerImage, controlTitle: gamepad.gampadInfo.rightTriggerTitle, controlUsage: gamepad.rightTriggerUsage)
            }
        }
    }
    
    @ViewBuilder private func Buttons() -> some View {
        Group {
            if gamepad.buttonMenu != nil {
                GamepadHelpEntry(iconName: gamepad.gampadInfo.buttonMenuImage, controlTitle: gamepad.gampadInfo.buttonMenuTitle, controlUsage: gamepad.buttonMenuUsage)
            }
            
            if gamepad.buttonOptions != nil {
                GamepadHelpEntry(iconName: gamepad.gampadInfo.buttonOptionsImage, controlTitle: gamepad.gampadInfo.buttonOptionsTitle, controlUsage: gamepad.buttonOptionsUsage)
            }

            if gamepad.buttonHome != nil {
                GamepadHelpEntry(iconName: gamepad.gampadInfo.buttonHomeImage, controlTitle: gamepad.gampadInfo.buttonHomeTitle, controlUsage: gamepad.buttonHomeUsage)
            }

            if gamepad.buttonA != nil {
                GamepadHelpEntry(iconName: gamepad.gampadInfo.buttonAImage, controlTitle: gamepad.gampadInfo.buttonATitle, controlUsage: gamepad.buttonAUsage)
            }
        }
            
        Group {
            if gamepad.buttonB != nil {
                GamepadHelpEntry(iconName: gamepad.gampadInfo.buttonBImage, controlTitle: gamepad.gampadInfo.buttonBTitle, controlUsage: gamepad.buttonBUsage)
            }

            if gamepad.buttonX != nil {
                GamepadHelpEntry(iconName: gamepad.gampadInfo.buttonXImage, controlTitle: gamepad.gampadInfo.buttonXTitle, controlUsage: gamepad.buttonXUsage)
            }

            if gamepad.buttonY != nil {
                GamepadHelpEntry(iconName: gamepad.gampadInfo.buttonYImage, controlTitle: gamepad.gampadInfo.buttonYTitle, controlUsage: gamepad.buttonYUsage)
            }
        }
    }
    
    @ViewBuilder private func Thumbsticks() -> some View {
        Group {
            if gamepad.dpad != nil {
                GamepadHelpEntry(iconName: gamepad.gampadInfo.dpadImage, controlTitle: gamepad.gampadInfo.dpadTitle, controlUsage: gamepad.dpadUsage)
            }
            
            if gamepad.leftThumbstick != nil {
                GamepadHelpEntry(iconName: gamepad.gampadInfo.buttonLeftThumbstickImage, controlTitle: gamepad.gampadInfo.leftThumbstickTitle, controlUsage: gamepad.leftThumbstickUsage)
            }
            
            if gamepad.rightThumbstick != nil {
                GamepadHelpEntry(iconName: gamepad.gampadInfo.buttonRightThumbstickImage, controlTitle: gamepad.gampadInfo.rightThumbstickTitle, controlUsage: gamepad.rightThumbstickUsage)
            }
            
            if gamepad.leftThumbstickButton != nil {
                GamepadHelpEntry(iconName: gamepad.gampadInfo.buttonLeftThumbstickImage, controlTitle: gamepad.gampadInfo.leftThumbstickButtonTitle, controlUsage: gamepad.leftThumbstickButtonUsage)
            }
            
            if gamepad.rightThumbstickButton != nil {
                GamepadHelpEntry(iconName: gamepad.gampadInfo.buttonRightThumbstickImage, controlTitle: gamepad.gampadInfo.rightThumbstickButtonTitle, controlUsage: gamepad.rightThumbstickButtonUsage)
            }
        }
    }
    
    @ViewBuilder private func PS4() -> some View {
        Group {
            if gamepad.touchpadButton != nil {
                GamepadHelpEntry(iconName: gamepad.gampadInfo.touchpadImage, controlTitle: gamepad.gampadInfo.touchpadTitle, controlUsage: gamepad.touchpadButtonUsage)
            }
            
            if gamepad.touchpadPrimary != nil {
                GamepadHelpEntry(iconName: gamepad.gampadInfo.touchpadImage, controlTitle: gamepad.gampadInfo.touchpadPrimaryTitle, controlUsage: gamepad.touchpadPrimaryUsage)
            }
            
            if gamepad.touchpadSecondary != nil {
                GamepadHelpEntry(iconName: gamepad.gampadInfo.touchpadImage, controlTitle: gamepad.gampadInfo.touchpadSecondaryTitle, controlUsage: gamepad.touchpadSecondaryUsage)
            }
        }
    }
    
    @ViewBuilder private func XBox() -> some View {
        Group {
            if gamepad.paddleButton1 != nil {
                GamepadHelpEntry(iconName: gamepad.gampadInfo.paddleButton1Image, controlTitle: gamepad.gampadInfo.paddleButton1Title, controlUsage: gamepad.paddleButton1Usage)
            }
            
            if gamepad.paddleButton2 != nil {
                GamepadHelpEntry(iconName: gamepad.gampadInfo.paddleButton2Image, controlTitle: gamepad.gampadInfo.paddleButton2Title, controlUsage: gamepad.paddleButton2Usage)
            }
            
            if gamepad.paddleButton3 != nil {
                GamepadHelpEntry(iconName: gamepad.gampadInfo.paddleButton3Image, controlTitle: gamepad.gampadInfo.paddleButton3Title, controlUsage: gamepad.paddleButton3Usage)
            }
            
            if gamepad.paddleButton4 != nil {
                GamepadHelpEntry(iconName: gamepad.gampadInfo.paddleButton4Image, controlTitle: gamepad.gampadInfo.paddleButton4Title, controlUsage: gamepad.paddleButton4Usage)
            }
            
            if gamepad.buttonShare != nil {
                GamepadHelpEntry(iconName: gamepad.gampadInfo.buttonShareImage, controlTitle: gamepad.gampadInfo.buttonShareTitle, controlUsage: gamepad.buttonShareUsage)
            }
        }
    }
}

#Preview("Help") {
    GamepadHelpOverlay()
}
