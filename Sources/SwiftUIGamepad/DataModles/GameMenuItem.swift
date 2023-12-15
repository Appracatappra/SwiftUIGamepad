//
//  GameMenuItem.swift
//  ReedWriteCycle (iOS)
//
//  Created by Kevin Mullins on 11/11/22.
//

import Foundation
import SwiftUI
import Observation

/// Defines a item that will be displayed in a gamepad driven menu.
@Observable open class GameMenuItem: Identifiable {
    /// Defines a type of action that will be taken when a `GameMenuItem` is selected by the user.
    public typealias ItemAction = () -> Void
    
    // MARK: - Properties
    /// The unique ID of the `GameMenuItem`.
    public var id:Int = 0
    
    /// The title to display in the UI.
    public var title:String = ""
    
    /// The action to take when the item is selected.
    public var action:ItemAction? = nil
    
    /// If `true` the item is enabled and can be selected.
    public var enabled:Bool = true
    
    /// The background color of the `GameMenuItem`.
    public var backgroundColor:Color = SwiftUIGamepad.defaultBackgroundColor
    
    // MARK: - Initializers
    /// Creates a new instance.
    public init() {
        
    }
    
    /// Creates a new instance.
    /// - Parameters:
    ///   - id: The unique ID of the `GameMenuItem`.
    ///   - title: The title to display in the UI.
    ///   - enabled: If `true` the item is enabled and can be selected.
    ///   - backgroundColor: The background color of the `GameMenuItem`.
    ///   - action: The action to take when the item is selected.
    public init(id:Int, title:String, enabled:Bool = true, backgroundColor:Color = Color("HUDBackground"), action:ItemAction? = nil) {
        self.id = id
        self.title = title
        self.action = action
        self.enabled = enabled
        self.backgroundColor = backgroundColor
    }
}
