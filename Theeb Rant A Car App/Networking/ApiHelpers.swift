import CoreData
import UIKit
import Alamofire

// MARK: - ...  Functions help the network manager
extension BaseNetworkManager {
    public func slugs(_ method: NetworkConfigration.EndPoint, _ paramters: [Any] = []) -> String {
        var url = method.rawValue
        for key in paramters {
            url += "/\(key)"
        }
        return url
    }
    func safeUrl(url: String) -> String {
        let safeURL = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        return safeURL
    }
    func queryString(method: String) -> String {
        var genericUrl: String = method
        var counter = 0
        if self.paramaters.count > 0 {
            for (key, value) in self.paramaters {
                if counter == 0 {
                    genericUrl += "?"+key+"=\(value)"
                } else {
                    genericUrl += "&"+key+"=\(value)"
                }
                counter += 1
            }
        }
        return genericUrl
    }
   
    func getErrorMessage(data: Data?) -> String? {
        guard data != nil else { return "" }
        guard let error = try? JSONDecoder().decode(ErrorModel.self, from: data ?? Data()) else { return "" }
        if error.message != nil {
            print("\(error.message ?? "")")
            return error.message
        } else {
            print("Error Not Parsed")
            return "Error Not Parsed"
        }
    }
    

}
