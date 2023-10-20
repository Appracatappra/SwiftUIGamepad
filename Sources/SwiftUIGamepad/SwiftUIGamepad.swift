//
//  File.swift
//
//
//  Created by Kevin Mullins on 10/19/23.
//

import Foundation

/// A utility for working with resources stored inside of this Swift Package.
open class SwiftUIGamepad {
    
    /// Defines the source of a file.
    public enum Source {
        /// The file is from the App's Bundle.
        case appBundle
        
        /// The file is from the Swift Package's Bundle.
        case packageBundle
    }
    
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
