//
//  GamepadMenu.swift
//  ReedWriteCycle (iOS)
//
//  Created by Kevin Mullins on 11/11/22.
//

import SwiftUI
import SwiftUIKit
import SoundManager
import SwiftletUtilities

struct GamepadMenu: View {
    typealias selectionHandler = (Int) -> Void
    
    var id:String = "GPMenu"
    var alignment:HorizontalAlignment = .center
    var menu:GameMenu
    var fontName:String = "TrueCrimes"
    var fontSize:Float = 40
    var gradientColors:[Color] = [.purple, .blue, .cyan, .green, .yellow, .orange, .red]
    var selectedColors:[Color] = [.orange, .red]
    var rotationDegrees:Double = 0
    var shadowed:Bool = true
    var maxEntries:Int = 4
    var boxWidth:Float = 360
    var padding:Float = 20
    var autoPurge:Bool = true
    var selectionChanged:selectionHandler? = nil
    
    @State var selectedItem:Int = 0
    @State var topItem:Int = 0
    
    var bottomItem:Int {
        if topItem + maxEntries >= menu.activeItems.count {
            return menu.activeItems.count - 1
        } else {
            return topItem + (maxEntries - 1)
        }
    }
    
    var showUpIndicator:Bool {
        return topItem > 0
    }
    
    var showDownIndicator: Bool {
        return (topItem + maxEntries) < menu.activeItems.count
    }
    
    var body: some View {
        mainContent()
        .onAppear {
            dpadUsage(viewID: id, "Use the **Up** and **Down** arrows to select an **Item** from the **Menu**.")
            buttonXUsage(viewID: id, "Choose the **Selected Item** from the **Menu**.")
        }
        .onDisappear {
            disconnectGamepad(viewID: id)
        }
        .onGamepadDpad(viewID: id) { xAxis, yAxis in
            let direction = GamepadMovementDirection.moving(x: xAxis, y: yAxis)
            switch direction {
            case .up:
                if selectedItem > 0 && menu.activeItems.count > 0  {
                    SoundManager.shared.playSoundEffect(sound: "Click_Standard_05.mp3")
                    selectedItem -= 1
                    
                    if selectedItem < topItem {
                        topItem -= 1
                    }
                    
                    if let selectionChanged {
                        selectionChanged(selectedItem)
                    }
                }
            case .down:
                if selectedItem < menu.activeItems.count - 1 && menu.activeItems.count > 0 {
                    SoundManager.shared.playSoundEffect(sound: "Click_Standard_05.mp3")
                    selectedItem += 1
                    
                    if selectedItem > bottomItem {
                        topItem += 1
                    }
                    
                    if let selectionChanged {
                        selectionChanged(selectedItem)
                    }
                }
            default:
                break;
            }
        }
        .onGamepadButtonX(viewID: id) {ispressed in
            if ispressed && menu.activeItems.count > 0 {
                SoundManager.shared.playSoundEffect(sound: "Menu_Select_00.mp3")
                let item = menu.activeItems[selectedItem]
                
                if autoPurge {
                    // Cleans menu, reset for next use and release all storage that the
                    // menu contained
                    selectedItem = 0
                    topItem = 0
                    menu.items.removeAll()
                }
                
                if let action = item.action {
                    Execute.onMain {
                        action()
                    }
                }
            }
        }
    }
    
    @ViewBuilder func mainContent() -> some View {
        VStack(alignment: alignment, spacing: 0.0) {
            if showUpIndicator {
                switch menu.style {
                case .items:
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.linearGradient(colors: gradientColors, startPoint: .top, endPoint: .bottom))
                            .frame(width: CGFloat(boxWidth), height: 30)
                        
                        Image(systemName: "arrowtriangle.up.fill")
                            .font(.system(size: CGFloat(20)))
                            .foregroundColor(.black)
                    }
                    .padding(.bottom, CGFloat(padding))
                case .cards:
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color("HUDBackground"))
                            .frame(width: CGFloat(boxWidth), height: 30)
                        
                        Image(systemName: "arrowtriangle.up.fill")
                            .font(.system(size: CGFloat(20)))
                            .foregroundColor(Color("HUDBorder"))
                    }
                    .padding(.bottom, CGFloat(padding))
                }
            }
            
            if menu.activeItems.count > 0 {
                ForEach((topItem...bottomItem), id: \.self) { n in
                    let item = menu.activeItems[n]
                    
                    if menu.style == .items {
                        GamepadMenuItem(title: item.title, fontName: fontName, fontSize: fontSize, gradientColors: gradientColors, selectedColors: selectedColors, rotationDegrees: rotationDegrees, shadowed: shadowed, isSelected: (n == selectedItem))
                            .padding(.bottom, CGFloat(padding))
                    } else if menu.style == .cards {
                        GamepadMenuCard(text: item.title, isSelected: (n == selectedItem), fontSize: fontSize, boxWidth: boxWidth, backgroundColor: item.backgroundColor)
                            .padding(.bottom, CGFloat(padding))
                    }
                }
            }
            
            if showDownIndicator {
                switch menu.style {
                case .items:
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.linearGradient(colors: gradientColors, startPoint: .top, endPoint: .bottom))
                            .frame(width: CGFloat(boxWidth), height: 30)
                        
                        Image(systemName: "arrowtriangle.down.fill")
                            .font(.system(size: CGFloat(20)))
                            .foregroundColor(.black)
                    }
                case .cards:
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color("HUDBackground"))
                            .frame(width: CGFloat(boxWidth), height: 30)
                        
                        Image(systemName: "arrowtriangle.down.fill")
                            .font(.system(size: CGFloat(20)))
                            .foregroundColor(Color("HUDBorder"))
                    }
                }
            }
        }
    }
}

#Preview("Menu") {
    GamepadMenu(menu: GameMenu())
}
