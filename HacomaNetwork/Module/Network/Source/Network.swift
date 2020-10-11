//
//  Network.swift
//  Network
//
//  Created by hacoma on 2020/10/11.
//

import Foundation

public struct Network {
    
    public static var userAgent: (() -> String)?
    public static var timeoutInterval: TimeInterval = 60
}
