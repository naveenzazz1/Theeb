import CoreData
import Alamofire
// MARK: - ...  NetworkManager
class NewNetworkManager: BaseNetworkManager {
    struct Static {
        static var instance: NewNetworkManager?
    }
    
    class var instance: NewNetworkManager {
        if Static.instance == nil {
            Static.instance = NewNetworkManager()
        }
        return Static.instance!
    }
}

// MARK: - ...  functions
extension NewNetworkManager {
    
    @discardableResult
    func request<M: Codable>(_ method: String, type: HTTPMethod, _ model: M.Type, isResponsetypeRequired: Bool? = nil) -> NetworkFuture<M?, NetworkError>? {
        super.refresh()
        return super.connection(method, type: type, model.self, isResponsetypeRequired: isResponsetypeRequired)
    }
    @discardableResult
    func request<M: Codable>(_ method: NetworkConfigration.EndPoint, type: HTTPMethod, _ model: M.Type, isResponsetypeRequired: Bool? = nil) -> NetworkFuture<M?, NetworkError>? {
        let request = self.request(method.rawValue, type: type, model)
        return request
    }
    @discardableResult
    func requestRaw<M: Codable>(_ method: String, json: Data? = nil, type: HTTPMethod, _ model: M.Type) -> NetworkFuture<M?, NetworkError>? {
        super.refresh()
        print("Request running")
        return super.connectionRaw(method, type: type, json: json, model.self, withSave: true)
        
    }
    func uploadFiles<M: Codable>(_ method: String , type: HTTPMethod, files: [URL]? = [], key: String? = "",
                                      file: [String: URL?]? = nil, _ model: M.Type) -> NetworkFuture<M?, NetworkError>? {
        super.refresh()
        return super.uploadMultiFiles(method, type: type, files: files ?? [], key: key ?? "", file: file, model)
    }
    func uploadImagesList<M: Codable>(_ method: String , type: HTTPMethod, files: [UIImage]? = [], key: String? = "",
                                       file: [String: UIImage?]? = nil, _ model: M.Type) -> NetworkFuture<M?, NetworkError>? {
        super.refresh()
        return super.uploadMultiFiles(method, type: type, files: files ?? [], key: key ?? "", file: file, model)
    }
    func uploadMultiImagesWithKey<M: Codable>(_ method: String , type: HTTPMethod, files: [String: UIImage]? = [:], key: String? = "",
                                       file: [String: UIImage?]? = nil, _ model: M.Type) -> NetworkFuture<M?, NetworkError>?  {
        super.refresh()
        return super.uploadMultiFiles(method, type: type, files: files ?? [:], file: file, model)
    }
}


