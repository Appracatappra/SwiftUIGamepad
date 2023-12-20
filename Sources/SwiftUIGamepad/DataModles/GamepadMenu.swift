//
//  GameMenu.swift
//  ReedWriteCycle (iOS)
//
//  Created by Kevin Mullins on 11/11/22.
//

import Foundation
import SwiftUI
import Observation

/// Data storage for a UI based menu of items that can be selected with a gamepad in an app's UI.
@Observable open class GamepadMenu {
    
    // MARK: - Enumerations
    /// Defines the menu style.
    public enum MenuStyle: Int {
        /// Display menu items in the item style.
        case items
        
        /// Display menu items in the card style.
        case cards
    }
    
    // MARK: - Properties
    /// A collection of `GameMenuItem` to display.
    public var items:[GamepadMenuItem] = []
    
    /// Defines the menu display style.
    public var style:MenuStyle = .items
    
    /// Returns a collection of only the `GameMenuItem` that are currently enabled.
    public var activeItems:[GamepadMenuItem] {
        var results:[GamepadMenuItem] = []
        
        for item in items {
            if item.enabled {
                results.append(item)
            }
        }
        
        return results
    }
    
    // MARK: - Initializers
    /// Creates a new instance.
    public init () {
        
    }
    
    /// Creates a new instance.
    /// - Parameter style: The default display style for the menu.
    public init(style: MenuStyle) {
        self.style = style
    }
    
    // MARK: - Functions
    /// Creates a new instance.
    /// - Parameters:
    ///   - title: The title of the menu item.
    ///   - enabled: If `true` the menu item is enabled.
    ///   - backgroundColor: The background color for the menu item.
    ///   - action: The action to take when a menu item is selected.
    public func addItem(title:String, enabled:Bool = true, backgroundColor:Color = SwiftUIGamepad.defaultBackgroundColor, action:GamepadMenuItem.ItemAction? = nil) {
        let id = items.count + 1
        let item = GamepadMenuItem(id: id, title: title, enabled: enabled, backgroundColor: backgroundColor, action: action)
        items.append(item)
    }
}
