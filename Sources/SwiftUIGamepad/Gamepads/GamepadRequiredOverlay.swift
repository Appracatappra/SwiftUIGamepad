//
//  GamepadRequired.swift
//  ReedWriteCycle (iOS)
//
//  Created by Kevin Mullins on 11/16/22.
//

import SwiftUI
import SwiftletUtilities
import SwiftUIKit

/// A common full screen overlay that you can display when app app requires an MFi Extended Game Controller and one is not connected to the device.
public struct GamepadRequiredOverlay: View {
    
    // MARK: - Properties
    /// The gamepad image to display in the overlay.
    public var controllerName:String = "PS5_Controller"
    
    /// The name of the app.
    public var appName:String = "This app"
    
    /// The background color for the overlay.
    public var backgroundColor:Color = Color(fromHex: "000000BB") ?? Color.clear
    
    
    // MARK: - Initializers
    /// Creates a new instance.
    /// - Parameters:
    ///   - controllerName: The gamepad image to display in the overlay.
    ///   - appName: The name of the app.
    ///   - backgroundColor: The background color for the overlay.
    public init(controllerName: String = "PS5_Controller", appName: String = "This app", backgroundColor: Color = Color(fromHex: "000000BB") ?? Color.clear) {
        self.controllerName = controllerName
        self.appName = appName
        self.backgroundColor = backgroundColor
    }
    
    // MARK: - Control Body
    /// The body of the control.
    public var body: some View {
        ZStack {
            switch HardwareInformation.deviceOrientation {
            case .landscapeLeft, .landscapeRight:
                horizontalContents()
            default:
                verticalContents()
            }
        }
        .frame(width: CGFloat(HardwareInformation.screenWidth), height: CGFloat(HardwareInformation.screenHeight))
        .ignoresSafeArea()
        .background(Color(fromHex: "000000BB"))
    }
    
    // MARK: - Functions
    /// Renderds the vertical contents for the overlay.
    /// - Returns: The contents of the view.
    @ViewBuilder private func verticalContents() -> some View {
        VStack {
            if SwiftUIGamepad.imageLocation == .appBundle {
                ScaledImageView(imageName: controllerName, scale: 0.50)
            } else {
                let url = SwiftUIGamepad.urlTo(resource: controllerName, withExtension: "png")
                ScaledImageView(imageURL: url, scale: 0.50, ignoreSafeArea: false)
            }
            
            Text("Waiting For Extended Gamepad To Connect")
                .font(.title2)
                .foregroundColor(Color.white)
                .multilineTextAlignment(.center)
                .padding(.bottom)
            
            Text("\(appName) requires a MFI compatible Extended Gamepad to be played. Please connect a gamepad to continue playing.")
                .foregroundColor(Color.white)
                .multilineTextAlignment(.center)
                .padding(.bottom)
            
            Text("If you already have a MFI compatible Extended Gamepad connected, please ensure that it is powered on.")
                .foregroundColor(Color.white)
                .multilineTextAlignment(.center)
                .padding(.bottom)
            
            Text("It can take a few moments before a connection is established, so please standby...")
                .foregroundColor(Color.white)
                .multilineTextAlignment(.center)
                .padding(.bottom)
            
            GamepadWaitingIndicator()
                .frame(width: 100, height: 100)
        }
    }
    
    /// Renderds the horizontal contents for the overlay.
    /// - Returns: The contents of the view.
    @ViewBuilder private func horizontalContents() -> some View {
        HStack {
            Spacer()
            
            if SwiftUIGamepad.imageLocation == .appBundle {
                ScaledImageView(imageName: controllerName, scale: 0.80)
            } else {
                let url = SwiftUIGamepad.urlTo(resource: controllerName, withExtension: "png")
                ScaledImageView(imageURL: url, scale: 0.80, ignoreSafeArea: false)
            }
            
            Spacer()
            
            VStack {
                Text("Waiting For Extended Gamepad To Connect")
                    .font(.title2)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .padding(.bottom)
                
                Text("\(appName) requires a MFI compatible Extended Gamepad to be played. Please connect a gamepad to continue playing.")
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .padding(.bottom)
                
                Text("If you already have a MFI compatible Extended Gamepad connected, please ensure that it is powered on.")
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .padding(.bottom)
                
                Text("It can take a few moments before a connection is established, so please standby...")
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .padding(.bottom)
                
                GamepadWaitingIndicator()
                    .frame(width: 100, height: 100)
            }
            
            Spacer()
        }
    }
}

#Preview("Overlay") {
    GamepadRequiredOverlay()
}
