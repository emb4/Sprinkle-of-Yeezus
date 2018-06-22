//
//  Defaults.swift
//  Sprinkle of Yeezus
//
//  Created by Eric Bates on 6/21/18.
//  Copyright © 2018 Eric Bates. All rights reserved.
//

import Foundation

public let Defaults = UserDefaults.standard

enum DefaultKey: String {
    
    case notificationDate
}

extension UserDefaults {
    
    public var notificationDate: Date? {
        get { return self[.notificationDate] }
        set { self[.notificationDate] = newValue }
    }
    
    // MARK: - Support
    private subscript<T>(key: DefaultKey) -> T? {
        get { return object(forKey: key.rawValue) as? T }
        set { set(newValue, forKey: key.rawValue) }
    }
}
