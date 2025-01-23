//
//  NetworkResponse.swift
//  BaseIOS

import Foundation
// MARK: - ...  Network Response
enum NetworkResponse<T: Codable> {
    case success(T?)
    case failure(Error?)
}
