//
//  GamepadMenuItem.swift
//  ReedWriteCycle (iOS)
//
//  Created by Kevin Mullins on 11/11/22.
//

import SwiftUI
import SwiftUIKit

struct GamepadMenuItem: View {
    
    var title:String = "Zaaaap!"
    var fontName:String = "Arial"
    var fontSize:Float = 40
    var gradientColors:[Color] = [.purple, .blue, .cyan, .green, .yellow, .orange, .red]
    var selectedColors:[Color] = [.orange, .red]
    var rotationDegrees:Double = 0
    var shadowed:Bool = true
    var isSelected:Bool = false
    
    var font:Font {
        return Font.custom(fontName, size: CGFloat(fontSize))
    }
    
    var body: some View {
        if isSelected {
            WordArtView(title: GamepadManager.expandMacros(in: title), fontName: fontName, fontSize: fontSize, gradientColors: selectedColors, rotationDegrees: rotationDegrees, shadowed: shadowed)
        } else {
            WordArtView(title: GamepadManager.expandMacros(in: title), fontName: fontName, fontSize: fontSize, gradientColors: gradientColors, rotationDegrees: rotationDegrees, shadowed: shadowed)
        }
    }
}

#Preview("Item") {
    GamepadMenuItem()
}
