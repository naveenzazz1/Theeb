//
//  AnyPublisher+EX.swift
//  BaseIOS
//
//

import Foundation
import Combine

extension Combine.Publisher {

    /**
     listen to ALL
     
     - parameter receiveCompletion: ((Subscribers.Completion<PublisherError>) -> Void), receiveValue: @escaping ((T) -> Void) .
     - returns: Void
     */
    public func listen(receiveCompletion: @escaping ((Subscribers.Completion<Self.Failure>) -> Void), receiveValue: @escaping ((Self.Output) -> Void)) -> AnyCancellable {
        return self.sink(receiveCompletion: receiveCompletion, receiveValue: receiveValue)
    }
    /**
     listen on value
     
     - parameter value on: ((T) -> Void)).
     - returns: Void
     */
    public func listen(on value: @escaping ((Self.Output) -> Void)) -> AnyCancellable {
        return self.sink(receiveCompletion: { _ in }, receiveValue: { output in
            value(output)
        })
    }
}

extension Combine.Publisher {
    /**
     listen to Network
     
     - parameter receiveCompletion: ((Subscribers.Completion<NetworkError>) -> Void), receiveValue: @escaping ((T) -> Void) .
     - returns: Void
     */
    func response(error: @escaping (NetworkError) -> Void, receiveValue: @escaping ((Self.Output) -> Void)) -> AnyCancellable {
        return self.sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let failed):
                if failed is NetworkError {
                    error(failed as! NetworkError)
                }
                break
            default:
                break
            }
        }, receiveValue: receiveValue)
    }
}

extension AnyCancellable {
    /**
     store in subscriptions
     
     - parameter combining on: Combining
     - returns: Void
     */
    func store(_ combining: Combining) {
        store(in: &combining.subscriptions)
    }
}

