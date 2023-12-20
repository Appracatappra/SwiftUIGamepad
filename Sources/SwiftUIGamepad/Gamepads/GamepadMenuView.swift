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

/// DIsplays a selectable list of menu items in the program's UI that can be navigated and selected using a gamepad.
public struct GamepadMenuView: View {
    /// An event handler that will be called when the user selects a different menu item in the UI. The index of the item will be returned to the caller.
    public typealias selectionHandler = (Int) -> Void
    
    // MARK: - Properties
    /// The unique ID of the menu.
    /// - Remark: Ensure that each `GamepadMenu` has a unique ID in the app.
    public var id:String = "GPMenu"
    
    /// The horizontal alignment of the items in the menu.
    public var alignment:HorizontalAlignment = .center
    
    /// The data that represents the menu to display and the actions to take when a menu item is selected.
    public var menu:GamepadMenu
    
    /// The font to display menu items in.
    public var fontName:String = SwiftUIGamepad.gameMenuFontName
    
    /// The font size to display menu items in.
    public var fontSize:Float = SwiftUIGamepad.gameMenuFontSize
    
    /// The gradient colors to display menu items in.
    public var gradientColors:[Color] = SwiftUIGamepad.gameMenuGradientColors
    
    /// The gradient colors to display the selected menu item in.
    public var selectedColors:[Color] = SwiftUIGamepad.gameMenuSelectedColors
    
    /// The rotation degree to display menu items in.
    public var rotationDegrees:Double = SwiftUIGamepad.gameMenuRotationDegrees
    
    /// If `true` the menu items will be displayed with a shadow.
    public var shadowed:Bool = SwiftUIGamepad.gameMenuShadowed
    
    /// The maximum number of items to show in the menu at once.
    public var maxEntries:Int = 4
    
    /// The width to show menu items in.
    public var boxWidth:Float = 360
    
    /// The amount of padding between menu items.
    public var padding:Float = 20
    
    /// If `true`, the `GamepadMenu` will automatically release memory and access to the gamepad when an item is selected.
    public var autoPurge:Bool = true
    
    /// Defines the default sound source for the `GamepadMenu` view.
    public var soundSource:SwiftUIGamepad.Source = SwiftUIGamepad.gamepadMenuSoundSource
    
    /// Defines the default menu item selected for the `GamepadMenu` view.
    public var selectedSound:String = SwiftUIGamepad.gamepadMenuSelectedSound
    
    /// Defines the default menu item selectionchanged the `GamepadMenu` view.
    public var selectionChangedSound:String = SwiftUIGamepad.gamepadMenuSelectionChangedSound
    
    /// A handler that will be called when the user changes the menu item selection.
    public var selectionChanged:selectionHandler? = nil
    
    /// Keeps tract of the currently selected menu item.
    @State var selectedItem:Int = 0
    
    /// Keeps track of the menu item that is currently displayed a s the top item.
    @State var topItem:Int = 0
    
    // MARK: - Computed Properties
    /// Returns the last menu item index.
    private var bottomItem:Int {
        if topItem + maxEntries >= menu.activeItems.count {
            return menu.activeItems.count - 1
        } else {
            return topItem + (maxEntries - 1)
        }
    }
    
    /// If `true`, the scroll up indicator will be displayed.
    private var showUpIndicator:Bool {
        return topItem > 0
    }
    
    
    /// If `true`, the scroll down indicator will be displayed.
    private var showDownIndicator: Bool {
        return (topItem + maxEntries) < menu.activeItems.count
    }
    
    // MARK: - Initializers
    /// Creates a new instance.
    /// - Parameters:
    ///   - id: The unique ID of the menu.
    ///   - alignment: The horizontal alignment of the items in the menu.
    ///   - menu: The data that represents the menu to display and the actions to take when a menu item is selected.
    ///   - fontName: The font to display menu items in.
    ///   - fontSize: The font size to display menu items in.
    ///   - gradientColors: The gradient colors to display menu items in.
    ///   - selectedColors: The gradient colors to display the selected menu item in.
    ///   - rotationDegrees: The rotation degree to display menu items in.
    ///   - shadowed: If `true` the menu items will be displayed with a shadow.
    ///   - maxEntries: The maximum number of items to show in the menu at once.
    ///   - boxWidth: The width to show menu items in.
    ///   - padding: The amount of padding between menu items.
    ///   - autoPurge: If `true`, the `GamepadMenu` will automatically release memory and access to the gamepad when an item is selected.
    ///   - soundSource: Defines the default sound source for the `GamepadMenu` view.
    ///   - selectedSound: Defines the default sound source for the `GamepadMenu` view.
    ///   - selectionChangedSound: Defines the default menu item selected for the `GamepadMenu` view.
    ///   - selectionChanged: Defines the default menu item selectionchanged the `GamepadMenu` view.
    public init(id: String = "GPMenu", alignment: HorizontalAlignment = .center, menu: GamepadMenu, fontName: String = SwiftUIGamepad.gameMenuFontName, fontSize: Float = SwiftUIGamepad.gameMenuFontSize, gradientColors: [Color] = SwiftUIGamepad.gameMenuGradientColors, selectedColors: [Color] = SwiftUIGamepad.gameMenuSelectedColors, rotationDegrees: Double = SwiftUIGamepad.gameMenuRotationDegrees, shadowed: Bool = SwiftUIGamepad.gameMenuShadowed, maxEntries: Int = 4, boxWidth: Float = 360, padding: Float = 20, autoPurge: Bool = true, soundSource: SwiftUIGamepad.Source = SwiftUIGamepad.gamepadMenuSoundSource, selectedSound: String = SwiftUIGamepad.gamepadMenuSelectedSound, selectionChangedSound: String = SwiftUIGamepad.gamepadMenuSelectionChangedSound, selectionChanged: selectionHandler? = nil) {
        self.id = id
        self.alignment = alignment
        self.menu = menu
        self.fontName = fontName
        self.fontSize = fontSize
        self.gradientColors = gradientColors
        self.selectedColors = selectedColors
        self.rotationDegrees = rotationDegrees
        self.shadowed = shadowed
        self.maxEntries = maxEntries
        self.boxWidth = boxWidth
        self.padding = padding
        self.autoPurge = autoPurge
        self.soundSource = soundSource
        self.selectedSound = selectedSound
        self.selectionChangedSound = selectionChangedSound
        self.selectionChanged = selectionChanged
    }
    
    // MARK: - Control Body
    /// The body of the control.
    public var body: some View {
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
                    switch soundSource {
                    case .appBundle:
                        SoundManager.shared.playSoundEffect(sound: selectionChangedSound)
                    case .packageBundle:
                        SoundManager.shared.playSoundEffect(path: SwiftUIKit.pathTo(resource: selectionChangedSound))
                    }
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
                    switch soundSource {
                    case .appBundle:
                        SoundManager.shared.playSoundEffect(sound: selectionChangedSound)
                    case .packageBundle:
                        SoundManager.shared.playSoundEffect(path: SwiftUIKit.pathTo(resource: selectionChangedSound))
                    }
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
                switch soundSource {
                case .appBundle:
                    SoundManager.shared.playSoundEffect(sound: selectedSound)
                case .packageBundle:
                    SoundManager.shared.playSoundEffect(path: SwiftUIKit.pathTo(resource: selectedSound))
                }
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
    
    /// Generates the contents of the menu.
    /// - Returns: A view representing the contents of the menu.
    @ViewBuilder private func mainContent() -> some View {
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
                        GamepadMenuItemView(title: item.title, fontName: fontName, fontSize: fontSize, gradientColors: gradientColors, selectedColors: selectedColors, rotationDegrees: rotationDegrees, shadowed: shadowed, isSelected: (n == selectedItem))
                            .padding(.bottom, CGFloat(padding))
                    } else if menu.style == .cards {
                        GamepadMenuCardView(text: item.title, isSelected: (n == selectedItem), fontSize: fontSize, boxWidth: boxWidth, backgroundColor: item.backgroundColor)
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
    GamepadMenuView(menu: GamepadMenu())
}
