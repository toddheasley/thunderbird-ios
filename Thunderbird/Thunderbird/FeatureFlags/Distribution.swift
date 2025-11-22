//
//  Distribution.swift
//  Thunderbird
//
//  Created by Ashley Soucar on 11/6/25.
//

public enum Distribution: Sendable {
    case debug
    case appstore
    case beta
}

extension Distribution {
    public static var current: Self {
        #if RELEASE
        return .appstore
        #elseif BETA
        return .beta
        #else
        return .debug
        #endif
    }
}
