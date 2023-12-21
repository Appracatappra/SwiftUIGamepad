//
//  GamepadHelpEntry.swift
//  ReedWriteCycle (iOS)
//
//  Created by Kevin Mullins on 11/10/22.
//

import SwiftUI
import SwiftletUtilities
import SwiftUIKit

/// Defines a control that will display the image, title and usage description of a gamepad button.
public struct GamepadHelpEntry: View {
    
    // MARK: - Properties
    /// The icon to display for the gamepad control.
    public var iconName:String = ""
    
    /// The title of the gamepad control.
    public var controlTitle:String = ""
    
    /// The usages of the gamepad control in the app.
    public var controlUsage:String = ""
    
    /// The font color of the help text.
    public var fontColor:Color = SwiftUIGamepad.defaultHelpFontColor
    
    // MARK: - Computed Properties
    /// The width of the help information card.
    public var cardWidth:CGFloat {
        return CGFloat(HardwareInformation.screenWidth) - 200.0
    }
    
    // MARK: - Initializers
    /// Creates a new instance.
    /// - Parameters:
    ///   - iconName: The icon to display for the gamepad control.
    ///   - controlTitle: The title of the gamepad control.
    ///   - controlUsage: The usages of the gamepad control in the app.
    ///   - fontColor: The font color of the help text.
    public init(iconName: String = "", controlTitle: String = "", controlUsage: String = "", fontColor: Color = SwiftUIGamepad.defaultHelpFontColor) {
        self.iconName = iconName
        self.controlTitle = controlTitle
        self.controlUsage = controlUsage
        self.fontColor = fontColor
    }
    
    // MARK: - Control Body
    /// The body of the control.
    public var body: some View {
        mainContents()
    }
    
    // MARK: - Functions
    /// Defines the main contents for the help card.
    /// - Returns: Returns the contents of the help card.
    @ViewBuilder private func mainContents() -> some View {
        #if os(tvOS)
        tvBody()
        #else
        mobileBody()
        #endif
    }
    
    /// Draws the help card for the Apple TV.
    /// - Returns: Returns the contents of the help card.
    @ViewBuilder private func tvBody() -> some View {
        HStack {
            if SwiftUIGamepad.imageLocation == .appBundle {
                Image(iconName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .padding(.leading)
                    .shadow(color: fontColor, radius: 10)
            } else {
                let url = SwiftUIGamepad.urlTo(resource: iconName, withExtension: "png")
                ScaledImageView(imageURL: url, scale: 0.8, ignoreSafeArea: false)
                    .frame(width: 80, height: 80)
                    .padding(.leading)
                    .shadow(color: fontColor, radius: 10)
            }
            
            VStack(alignment: .leading) {
                HStack {
                    Text(markdown: controlTitle)
                        .font(.title3)
                        .foregroundColor(fontColor)
                    
                    Spacer()
                }
                
                HStack {
                    Text(markdown: controlUsage)
                        .font(.body)
                        .foregroundColor(fontColor)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                }
            }
            .frame(width: cardWidth)
            .padding(.trailing)
        }
    }
    
    /// Draws the help card for mobile devices.
    /// - Returns: Returns the contents of the help card.
    @ViewBuilder private func mobileBody() -> some View {
        HStack {
            if SwiftUIGamepad.imageLocation == .appBundle {
                Image(iconName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .padding(.leading)
            } else {
                let url = SwiftUIGamepad.urlTo(resource: iconName, withExtension: "png")
                ScaledImageView(imageURL: url, scale: 0.8, ignoreSafeArea: false)
                    .frame(width: 80, height: 80)
                    .padding(.leading)
            }
            
            VStack(alignment: .leading) {
                HStack {
                    Text(markdown: controlTitle)
                        .font(.title2)
                        .foregroundColor(fontColor)
                    
                    Spacer()
                }
                
                HStack {
                    Text(markdown: controlUsage)
                        .foregroundColor(fontColor)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                }
            }
            .frame(width: cardWidth)
            .padding(.trailing)
        }
    }
}

#Preview("Entry") {
    GamepadHelpEntry(iconName: "PS4_Circle", controlTitle: "Button", controlUsage: "This is a sample game control")
        .background(Color.gray)
}
