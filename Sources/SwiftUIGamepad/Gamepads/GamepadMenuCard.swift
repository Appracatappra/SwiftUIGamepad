//
//  GameMenuCard.swift
//  ReedWriteCycle (iOS)
//
//  Created by Kevin Mullins on 11/14/22.
//

import SwiftUI

import SwiftUI
import SwiftletUtilities

struct GamepadMenuCard: View {
    var text:String = "This is an action that the user can take. It could be quite long and descriptive. This is an action that the user can take. It could be quite long and descriptive."
    var isSelected:Bool = false
    var fontName:String = "Arial" //ComicFonts.KomikaTight.rawValue
    var fontSize:Float = 24
    var fontColor:Color = Color.white
    var boxWidth:Float = 360
    var backgroundColor:Color = Color("HUDBackground")
    
    var font:Font {
        if fontName == "System" {
            return Font.system(size: CGFloat(fontSize))
        } else {
            return Font.custom(fontName, size: CGFloat(fontSize))
        }
    }
    
    var body: some View {
        if isSelected {
            Text(markdown: text)
                .font(font)
                .foregroundColor(fontColor)
                .multilineTextAlignment(.leading)
                .padding(.all)
                .frame(width: CGFloat(boxWidth))
                .border(Color("HUDBorderSelected"), width: 4)
                .background(Color("HUDBackgroundSelected"))
                .cornerRadius(10.0)
        } else {
            Text(markdown: text)
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
        GamepadMenuCard()
            .padding(.bottom, 10)
        
        GamepadMenuCard()
            .padding(.bottom, 10)
    }
}
