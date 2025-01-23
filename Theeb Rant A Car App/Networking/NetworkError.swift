//
//  NetworkError.swift
//  BaseIOS
//

import Foundation
// MARK: - ...  Network Response
struct NetworkError: LocalizedError {
    private let message: String
    var errors: [Errors]?
    
    init(message: String) {
        self.message = message
    }
//    init(error: ErrorModel?) {
//        self.message = error?.data?.message ?? ""
//    }
    init(error: CustomError?) {
        self.message = error?.value ?? "Unexpected error."
    }
    init(errors: [Errors]?) {
        self.errors = errors
        self.message = "\(errors?.first?.detail ?? "")"
    }
    var localizedDescription: String {
        return message
    }
    var errorDescription: String? {
        return message
    }
}

// MARK: - ...  Custom error
protocol CustomError: Error {
    var value: String { get }
}
extension CustomError where Self: RawRepresentable, Self.RawValue == String {
    var value: String {
        return rawValue
    }
}
