//
//  Publisher+Sender.swift

import Foundation


extension Publisher: Sender {
    func send(_ input: T) {
        publisher?.send(input)
    }
    func send(error: PublisherError) {
        publisher?.send(completion: .failure(error))
    }
}
