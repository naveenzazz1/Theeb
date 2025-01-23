//
//  CustomRequestRetrier.swift
//  Nobe
//
//  Created by ahmed elshobary on 30/05/2023.
//

import Alamofire

class CustomRequestRetrier: RequestInterceptor {
    private let maxRetryCount: Int
    private var retryCount: Int
    
    init(maxRetryCount: Int) {
        self.maxRetryCount = maxRetryCount
        self.retryCount = 0
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let statusCode = request.response?.statusCode else {
            completion(.doNotRetry) // Do not retry if the status code is unknown
            return
        }
        
        // Check the condition for retrying the request (e.g., based on status code or error type)
        if shouldRetry(statusCode: statusCode, error: error) && retryCount < maxRetryCount {
            retryCount += 1
            print("Retry count: \(retryCount)")
            completion(.retryWithDelay(1.0)) // Retry after 1 second
        } else {
            completion(.doNotRetry) // Do not retry
        }
    }
    
    // Rest of the class implementation...
    
    private func shouldRetry(statusCode: Int, error: Error) -> Bool {
        // Implement your own logic for determining when to retry the request
        // Return true if the request should be retried, false otherwise
        return false
    }
}
