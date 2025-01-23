//
//  ViewModelProtocol.swift
//  Theeb Rent A Car App
//
//  Created by ahmed elshobary on 19/07/2023.
//

import Foundation
import Alamofire
// MARK: - ...  ViewModelProtocol Protocol
// All ViewModels must implement this protocol
protocol ViewModelProtocol: NSObjectProtocol {
    // All requests in view model
    var requests: [DataRequest?] { get set }
    var error: Publisher<NetworkError> { get set }
    func removeTasks()
}
// MARK: - ...  Implement requests functions
extension ViewModelProtocol {
    func removeTasks() {
        requests.forEach { (request) in
            request?.task?.cancel()
        }
    }
}

protocol ViewModelPaginate: NSObjectProtocol {
    func paginator(respnod: [Any]?)
    func canPaginate() -> Bool
    func resetPaginator()
}
// MARK: - ...  Implement pagination functions
extension ViewModelPaginate {
    // MARK: - ...  check array size
    func paginator(respnod: [Any]?) {
        NewNetworkManager.instance.checkPaginator(respond: respnod)
    }
    // MARK: - ...  Check make another call for pagination
    func canPaginate() -> Bool {
        if !(NewNetworkManager.instance.HTTPRequestRunning.publisher.value ?? false) && !NewNetworkManager.instance.paginatorStop {
            NewNetworkManager.instance.incresePaginate()
            return true
        } else {
            return false
        }
    }
    // MARK: - ...  Reset pagination Data
    func resetPaginator() {
        NewNetworkManager.instance.resetPaginate()
    }
}

