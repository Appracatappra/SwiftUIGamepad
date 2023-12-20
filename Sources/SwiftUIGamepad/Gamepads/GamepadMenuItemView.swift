//
//  GamepadMenuItem.swift
//  ReedWriteCycle (iOS)
//
//  Created by Kevin Mullins on 11/11/22.
//

import SwiftUI
import SwiftUIKit

/// View to display a `GamepadMenuItem` as a single line of text in a `GamepadMenuView`.
public struct GamepadMenuItemView: View {
    
    // MARK: - Properties
    /// The item to display.
    public var title:String = ""
    
    /// The font to display the menu item in.
    public var fontName:String = SwiftUIGamepad.gameMenuFontName
    
    /// The font size to display the menu item in.
    public var fontSize:Float = SwiftUIGamepad.gameMenuFontSize
    
    /// The gradient colors to display the menu item in.
    public var gradientColors:[Color] = SwiftUIGamepad.gameMenuGradientColors
    
    /// The gradient colors to display the selected menu item in.
    public var selectedColors:[Color] = SwiftUIGamepad.gameMenuSelectedColors
    
    /// The rotation degrees for the menu item.
    public var rotationDegrees:Double = SwiftUIGamepad.gameMenuRotationDegrees
    
    /// If `true` the menu item will be displayed with a shadow.
    public var shadowed:Bool = SwiftUIGamepad.gameMenuShadowed
    
    /// If `true`, the menu item is selected.
    public var isSelected:Bool = false
    
    // MARK: - Computed Properties
    /// Returns the requested font with the given size.
    private var font:Font {
        return Font.custom(fontName, size: CGFloat(fontSize))
    }
    
    // MARK: - Initializers
    /// Creates a new instance.
    /// - Parameters:
    ///   - title: The item to display.
    ///   - fontName: The font to display the menu item in.
    ///   - fontSize: The font size to display the menu item in.
    ///   - gradientColors: The gradient colors to display the menu item in.
    ///   - selectedColors: The gradient colors to display the selected menu item in.
    ///   - rotationDegrees: The rotation degrees for the menu item.
    ///   - shadowed: If `true` the menu item will be displayed with a shadow.
    ///   - isSelected: If `true`, the menu item is selected.
    public init(title: String = "", fontName: String = SwiftUIGamepad.gameMenuFontName, fontSize: Float = SwiftUIGamepad.gameMenuFontSize, gradientColors: [Color] = SwiftUIGamepad.gameMenuGradientColors, selectedColors: [Color] = SwiftUIGamepad.gameMenuSelectedColors, rotationDegrees: Double = SwiftUIGamepad.gameMenuRotationDegrees, shadowed: Bool = SwiftUIGamepad.gameMenuShadowed, isSelected: Bool = false) {
        self.title = title
        self.fontName = fontName
        self.fontSize = fontSize
        self.gradientColors = gradientColors
        self.selectedColors = selectedColors
        self.rotationDegrees = rotationDegrees
        self.shadowed = shadowed
        self.isSelected = isSelected
    }
    
    // MARK: - Control Body
    /// The body of the control.
    public var body: some View {
        if isSelected {
            WordArtView(title: GamepadManager.expandMacros(in: title), fontName: fontName, fontSize: fontSize, gradientColors: selectedColors, rotationDegrees: rotationDegrees, shadowed: shadowed)
        } else {
            WordArtView(title: GamepadManager.expandMacros(in: title), fontName: fontName, fontSize: fontSize, gradientColors: gradientColors, rotationDegrees: rotationDegrees, shadowed: shadowed)
        }
    }
}

#Preview("Item") {
    GamepadMenuItemView()
}
