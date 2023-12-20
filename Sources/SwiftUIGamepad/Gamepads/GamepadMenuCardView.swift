//
//  GameMenuCard.swift
//  ReedWriteCycle (iOS)
//
//  Created by Kevin Mullins on 11/14/22.
//

import SwiftUI
import SwiftletUtilities

/// View to display a `GamepadMenuItem`  as a card in a `GamepadMenuView`.
public struct GamepadMenuCardView: View {
    
    // MARK: - Properties
    /// The body of the menu item card.
    public var text:String = ""
    
    /// If `true`, the card is selected.
    public var isSelected:Bool = false
    
    /// The font to display the card body in.
    public var fontName:String = SwiftUIGamepad.gameMenuCardFontName
    
    /// The font size to display the card body in.
    public var fontSize:Float = SwiftUIGamepad.gameMenuCardFontSize
    
    /// The font color to display the card body in.
    public var fontColor:Color = SwiftUIGamepad.gameMenuCardFontColor
    
    /// The width of the card in the UI.
    public var boxWidth:Float = 360
    
    /// The background color of the card.
    public var backgroundColor:Color = SwiftUIGamepad.gameMenuCardBackground
    
    // MARK: - Computed Properties
    /// Returns the requested font with the given size.
    private var font:Font {
        if fontName == "System" {
            return Font.system(size: CGFloat(fontSize))
        } else {
            return Font.custom(fontName, size: CGFloat(fontSize))
        }
    }
    
    // MARK: - Initializers
    /// Creates a new instance.
    /// - Parameters:
    ///   - text: The body of the menu item card.
    ///   - isSelected: If `true`, the card is selected.
    ///   - fontName: The font to display the card body in.
    ///   - fontSize: The font size to display the card body in.
    ///   - fontColor: The font color to display the card body in.
    ///   - boxWidth: The width of the card in the UI.
    ///   - backgroundColor: The background color of the card.
    public init(text: String = "", isSelected: Bool = false, fontName: String = SwiftUIGamepad.gameMenuCardFontName, fontSize: Float = SwiftUIGamepad.gameMenuCardFontSize, fontColor: Color = SwiftUIGamepad.gameMenuCardFontColor, boxWidth: Float = 360, backgroundColor: Color = SwiftUIGamepad.gameMenuCardBackground) {
        self.text = text
        self.isSelected = isSelected
        self.fontName = fontName
        self.fontSize = fontSize
        self.fontColor = fontColor
        self.boxWidth = boxWidth
        self.backgroundColor = backgroundColor
    }
    
    // MARK: - Control Body
    /// The body of the control.
    public var body: some View {
        if isSelected {
            Text(markdown: GamepadManager.expandMacros(in: text))
                .font(font)
                .foregroundColor(fontColor)
                .multilineTextAlignment(.leading)
                .padding(.all)
                .frame(width: CGFloat(boxWidth))
                .border(Color("HUDBorderSelected"), width: 4)
                .background(Color("HUDBackgroundSelected"))
                .cornerRadius(10.0)
        } else {
            Text(markdown: GamepadManager.expandMacros(in: text))
                .font(font)
                .foregroundColor(fontColor)
                .multilineTextAlignment(.leading)
                .padding(.all)
                .frame(width: CGFloat(boxWidth))
                .border(Color("HUDBorder"), width: 4)
                .background(backgroundColor)
                .cornerRadius(10.0)
        }
    }
}

#Preview("Cards") {
    VStack {
        GamepadMenuCardView()
            .padding(.bottom, 10)
        
        GamepadMenuCardView()
            .padding(.bottom, 10)
    }
}
