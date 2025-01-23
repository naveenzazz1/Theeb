//
//  PublisherError.swift
//

import Foundation


// MARK: - ... PublisherError
enum PublisherError: Error {
    /**
     Network case
     - returns: An error with network value
     */
    case network
}

extension PublisherError: CustomStringConvertible {
    /**
     description
     
     - parameter description: String.
     - returns: string value for error
     */
    var description: String {
        switch self {
        case .network:
            return "network"
        }
    }
}
