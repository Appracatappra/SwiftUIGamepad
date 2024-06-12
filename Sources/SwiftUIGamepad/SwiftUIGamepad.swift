//
//  File.swift
//
//
//  Created by Kevin Mullins on 10/19/23.
//
// Background Source: https://www.vecteezy.com/vector-art/7207818-futuristic-technological-grid-background-digital-futurist-cyber-space-design-cyberpunk-technology-virtual-reality-science-fiction-matrix-science-light-perspective-wallpaper-vector-illustration

import Foundation
import SwiftUI
import SwiftletUtilities

/// A utility for working with resources stored inside of this Swift Package.
open class SwiftUIGamepad {
    
    // MARK: - Enumerations
    /// Defines the source of a file.
    public enum Source {
        /// The file is from the App's Bundle.
        case appBundle
        
        /// The file is from the Swift Package's Bundle.
        case packageBundle
    }
    
    // MARK: - Static Properies
    /// The default location that this library should look for images in.
    public nonisolated(unsafe) static var imageLocation:Source = .packageBundle
    
    /// The default location that this library should look for sound effects in.
    public nonisolated(unsafe) static var soundLocation:Source = .packageBundle
    
    /// Defines the default font for UI items in the `SwiftUIGamepad` library.
    public nonisolated(unsafe) static var defaultFontName:String = "Arial"
    
    /// Defines the default background color for UI items in the `SwiftUIGamepad` library.
    public nonisolated(unsafe) static var defaultBackgroundColor:Color = Color.gray
    
    /// Defines the default enabled color for controls in the `SwiftUIGamepad` library.
    public nonisolated(unsafe) static var defaultEnabledColor:Color = Color.black
    
    /// Defines the default disabled color for controls in the `SwiftUIGamepad` library.
    public nonisolated(unsafe) static var defaultDisabledColor:Color = Color.gray
    
    /// Defines the default help font color for controls in the `SwiftUIGamepad` library.
    public nonisolated(unsafe) static var defaultHelpFontColor:Color = .white
    
    /// Defines the default help background color for controls in the `SwiftUIGamepad` library.
    public nonisolated(unsafe) static var defaultHelpBackgroundColor:Color = .black
    
    /// Defines the default help background image for controls in the `SwiftUIGamepad` library.
    public nonisolated(unsafe) static var defaultHelpBackgroundImage:String = "GridBackground"
    
    /// Defines the default font for the `GamepadMenu` view.
    public nonisolated(unsafe) static var gameMenuFontName:String = "Arial"
    
    /// Defines the default font size for the `GamepadMenu` view.
    public nonisolated(unsafe) static var gameMenuFontSize:Float = 40
    
    /// Defines the default gradient colors for the `GamepadMenu` view.
    public nonisolated(unsafe) static var gameMenuGradientColors:[Color] = [.white, .gray]
    
    /// Defines the default selected item gradient colors for the `GamepadMenu` view.
    public nonisolated(unsafe) static var gameMenuSelectedColors:[Color] = [.orange, .red]
    
    /// Defines the default rotation for the `GamepadMenu` view.
    public nonisolated(unsafe) static var gameMenuRotationDegrees:Double = 0
    
    /// Defines the default shadow state for the `GamepadMenu` view.
    public nonisolated(unsafe) static var gameMenuShadowed:Bool = true
    
    /// Defines the default sound source for the `GamepadMenu` view.
    public nonisolated(unsafe) static var gamepadMenuSoundSource:Source = .packageBundle
    
    /// Defines the default menu item selected for the `GamepadMenu` view.
    public nonisolated(unsafe) static var gamepadMenuSelectedSound:String = "mouse-click.mp3"
    
    /// Defines the default menu item selectionchanged the `GamepadMenu` view.
    public nonisolated(unsafe) static var gamepadMenuSelectionChangedSound:String = "diamond-click.mp3"
    
    /// Defines the default card font for the `GamepadMenu` view.
    public nonisolated(unsafe) static var gameMenuCardFontName:String = "Arial"
    
    /// Defines the default card font size for the `GamepadMenu` view.
    public nonisolated(unsafe) static var gameMenuCardFontSize:Float = 24
    
    /// Defines the default card font color for the `GamepadMenu` view.
    public nonisolated(unsafe) static var gameMenuCardFontColor:Color = .white
    
    /// Defines the default card background color for the `GamepadMenu` view.
    public nonisolated(unsafe) static var gameMenuCardBackground:Color = .gray
    
    /// Defines the default card background color for the `GamepadMenu` view.
    public nonisolated(unsafe) static var gameMenuCardSelectedBackground:Color = .blue
    
    /// Defines the default card font color for the `GamepadMenu` view.
    public nonisolated(unsafe) static var gameMenuCardBorderColor:Color = .white
    
    // MARK: - Static Functions
    /// Gets the path to the requested resource stored in the Swift Package's Bundle.
    /// - Parameters:
    ///   - resource: The name of the resource to locate.
    ///   - ofType: The type/extension of the resource to locate.
    /// - Returns: The path to the resource or `nil` if not found.
    public static func pathTo(resource:String?, ofType:String? = nil) -> String?  {
        let path = Bundle.module.path(forResource: resource, ofType: ofType)
        return path
    }
    
    /// Gets the url to the requested resource stored in the Swift Package's Bundle.
    /// - Parameters:
    ///   - resource: The name of the resource to locate.
    ///   - withExtension: The extension of the resource to locate.
    /// - Returns: The path to the resource or `nil` if not found.
    public static func urlTo(resource:String?, withExtension:String? = nil) -> URL? {
        let url = Bundle.module.url(forResource: resource, withExtension: withExtension)
        return url
    }
}
