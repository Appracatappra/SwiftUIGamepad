//
//  GamepadControlTip.swift
//  ReedWriteCycle (iOS)
//
//  Created by Kevin Mullins on 11/16/22.
//

import SwiftUI
import SwiftUIKit

/// UI control for displaying an icon of a gamepad control and a short text description of what that control does.
///
/// This control is typically used with the `GamepadInfo` of the currently attached gamepad to get the correct image for the control.
///
/// For Example:
/// ```
/// GamepadControlTip(iconName: GamepadManager.gamepadOne.gampadInfo.buttonAImage, title: "Help", scale: ScreenMetrics.controlButtonScale, enabledColor: Color("HUDForeground"))
/// ```
/// In this example `GamepadManager.gamepadOne.gampadInfo.buttonAImage` will get the correct image for the **A Button** based on which gamepad the user has connected to the device.
/// - Remark: If `SwiftUIGamepad.imageLocation` is `packageBundle` the images will be loaded from this package.
public struct GamepadControlTip: View {
    
    // MARK: - Properties
    /// The name of the control icon to show.
    public var iconName:String = ""
    
    /// The short description of what the gamepad control does.
    public var title:String = ""
    
    /// The font to display the control in.
    public var fontName:String = SwiftUIGamepad.defaultFontName
    
    /// The scale for the tip.
    public var scale:Float = 1.0
    
    /// The tip's enabled color.
    public var enabledColor:Color = SwiftUIGamepad.defaultEnabledColor
    
    /// The tip's disabled color.
    public var disabledColor:Color = SwiftUIGamepad.defaultDisabledColor
    
    /// If `true` the tip is enabled.
    public var isEnabled:Bool = true
    
    /// An optional offset from the top of the control.
    public var nudge:Float = 0.0
    
    /// The font the title will be displayed in.
    public var font:Font {
        return Font.custom(fontName, size: CGFloat(128.0 * scale))
    }
    
    /// The font color based on the enabled state of the tip.
    public var fontColor: Color {
        if isEnabled {
            return enabledColor
        } else {
            return disabledColor
        }
    }
    
    // MARK: - Initializers
    /// Creates a new instance.
    /// - Parameters:
    ///   - iconName: The name of the control icon to show.
    ///   - title: The short description of what the gamepad control does.
    ///   - fontName: The font to display the control in.
    ///   - scale: The scale for the tip.
    ///   - enabledColor: The tip's enabled color.
    ///   - disabledColor: The tip's disabled color.
    ///   - isEnabled: If `true` the tip is enabled.
    ///   - nudge: An optional offset from the top of the control.
    public init(iconName: String = "", title: String = "", fontName: String = SwiftUIGamepad.defaultFontName, scale: Float = 1.0, enabledColor: Color = SwiftUIGamepad.defaultEnabledColor, disabledColor: Color = SwiftUIGamepad.defaultDisabledColor, isEnabled: Bool = true, nudge: Float = 0.0) {
        self.iconName = iconName
        self.title = title
        self.fontName = fontName
        self.scale = scale
        self.enabledColor = enabledColor
        self.disabledColor = disabledColor
        self.isEnabled = isEnabled
        self.nudge = nudge
    }
    
    // MARK: - Control Body
    /// The body of the control.
    public var body: some View {
        HStack(alignment: .center, spacing: 10.0) {
            if iconName != "" {
                if SwiftUIGamepad.imageLocation == .appBundle {
                    ScaledImageView(imageName: iconName, scale: scale * 3, ignoreSafeArea: false)
                        .padding(.top, CGFloat(nudge))
                } else {
                    let url = SwiftUIGamepad.urlTo(resource: iconName, withExtension: "png")
                    ScaledImageView(imageURL: url, scale: scale * 3, ignoreSafeArea: false)
                        .padding(.top, CGFloat(nudge))
                }
            }
            
            Text(title)
                .font(font)
                .foregroundColor(fontColor)
                .padding(0.0)
        }
        .padding(0.0)
    }
}

#Preview("Tip") {
    GamepadControlTip(iconName: "PS4_Circle", title: "Button", scale: 0.5)
}
