//
//  Paginator.swift
//  FashonDesign
//
//  Created by mohamed abdo on 5/31/18.
//  Copyright © 2018 Atiaf. All rights reserved.
//

import Foundation
// MARK: - ...  Paginator Protocol
protocol Paginator: AnyObject {
    func paginate()
    func incresePaginate()
    func resetPaginate()
    func stopPaginate()
    func checkPaginator(respond: [Any]?)
}
// MARK: - ...  Paginator Attributes

private var paginatorFile: Int = 0
private var paginatorStopFile: Bool = false
private var paginatorLimitFile = 10
// MARK: - ...  Paginator implementation

extension Paginator {
    var paginator: Int {
        set {
            paginatorFile = newValue
        } get {
            return paginatorFile
        }
    }
    var paginatorStop: Bool {
        set {
            paginatorStopFile = newValue
        } get {
            return paginatorStopFile
        }
    }
    var paginatorLimit: Int {
        set {
            paginatorLimitFile = newValue
        } get {
            return paginatorLimitFile
        }
    }
    func paginate() {
//        ApiManager.instance.paramaters["skipCount"] = (paginator - 1) * 10
//        ApiManager.instance.paramaters["maxResultCount"] =  10
        NewNetworkManager.instance.paramaters["page"] = paginator
        NewNetworkManager.instance.paramaters["skipCount"] = (paginator - 1) * paginatorLimitFile
        NewNetworkManager.instance.paramaters["maxResultCount"] =  paginatorLimitFile
        if NewNetworkManager.instance.paramaters["custom_page"] != nil {
            NewNetworkManager.instance.paramaters["page"] = NewNetworkManager.instance.paramaters["custom_page"]
        }
    }
    func incresePaginate() {
        paginator += 1
    }
    func resetPaginate() {
        paginator = 0
        paginatorStop = false
        NewNetworkManager.instance.resetObject()
    }
    func stopPaginate() {
        paginatorStop = true
    }
    func runPaginate() {
        paginatorStop = false
    }
    func checkPaginator(respond: [Any]?) {
        if let array = respond {
            if array.count == 0 || array.count < NewNetworkManager.instance.paginatorLimit {
                self.stopPaginate()
            } else {
                self.runPaginate()
            }
        }
        print(self.paginatorStop)
    }
}
