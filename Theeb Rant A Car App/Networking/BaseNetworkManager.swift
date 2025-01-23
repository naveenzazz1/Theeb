import Alamofire
import UIKit

// MARK: - ...  Base Network manager // downloader // paginator // alertable
class BaseNetworkManager: Downloader, Paginator, Alertable, Combining {
    
    var retryCount = 0
    
    private let url = NetworkConfigration.urlString 
    private var header: HTTPHeaders {
        get {
            return .init(headers)
        }
    }
    var paramaters: [String: Any] = [:]
    var formData = Data()
    var headers: [HTTPHeader] = []
    var subscriptions: Set<Subscriptions> = []
    var HTTPRequestRunning: Publisher<Bool> = .init()
    var request: URLRequest?
    
    
    override init() {
        super.init()
        setupObject()
    }
    func run() {
        HTTPRequestRunning.send(true)
    }
    func stop() {
        HTTPRequestRunning.send(false)
    }
}
// MARK: - ...  Functions setup
extension BaseNetworkManager {
    // MARK: - ...  refresh for new request
    func refresh() {
        self.removeSubscription()
        setupObject()
        //        paginate()
    }
    
    func cancelAllRunningRequests(){
        let session = Alamofire.Session()
        session.cancelAllRequests()
    }
    
    // MARK: - ...  setup request object
    func setupObject() {
        headers.removeAll()
        //hide()
        setupAuth()
//        headers.append(.init(name: "Language", value: Localizer.shared.currentLanguage()))
        headers.append(.init(name: "Accept", value: "application/json"))
//        let staticParamters: [String: Any] = ["jsonrpc": "2.0", "method": "call"]
//        paramaters.merge(staticParamters) { (_, new) in new }


    }
    // MARK: - ...  setup auth header
    func setupAuth() {
        headers.append(.init(name: "Authorization", value: Authentication.shared.getAuth()))
        print(headers)
    }
    // MARK: - ...  reset the object
    func resetObject() {
        self.paramaters = [:]
        setupObject()
    }
    // MARK: - ...  initailize the FULL URL
    func initURL(method: String, type: HTTPMethod, isResponsetypeRequired: Bool? = nil) -> String {
        var url = ""
        if type == .get {
            let methodFull = queryString(method: method)
            url = self.url+methodFull
        } else {
            url = self.url+method
        }
        if isResponsetypeRequired == nil || isResponsetypeRequired == true {
            url += "?Responsetype=json"
        }
       

        return url
    }
    func checkReachability() -> Bool {
        if !ReachabilityConnection.isConnectedToNetwork() {
            // show network fail
            return false
        } else {
            return true
        }
    }
}
// MARK: - ...  Handle response for request
// MARK: - ...  Handle response for request
extension BaseNetworkManager {
    func response<M: Codable>(response: DataResponse<Any, AFError>, _ model: M.Type, requestt: DataRequest) -> NetworkResponse<M>? {
        
        self.stop()
        switch response.result {
        case .success(let result):
            var statusCode: Int?
            
            if statusCode == nil {
                statusCode = response.response?.statusCode
            }
            print("statusCodeeeeeee\(statusCode ?? 0)")

            switch statusCode {
            case 200?:
                do {
                    guard let data = response.data else { return nil }
                    let model = try JSONDecoder().decode(M.self, from: data)
                 //   print(response.value ?? "")
                    return (.success(model))
                } catch DecodingError.typeMismatch(let type , let context) {
                    let error = "Type \(type) mismatch: \(context.debugDescription)/n/n codingPath: \(context.codingPath)"
                    print(error)
                    return (.failure(NetworkError.init(message: error)))
                } catch DecodingError.keyNotFound(let key, let context) {
                    let error = "Key \(key) mismatch: \(context.debugDescription)/n/n codingPath: \(context.codingPath)"
                    print(error)
                    return (.failure(NetworkError.init(message: error)))
                } catch DecodingError.valueNotFound(let value, let context) {
                    let error = "Value \(value) mismatch: \(context.debugDescription)/n/n codingPath: \(context.codingPath)"
                    print(error)
                    return (.failure(NetworkError.init(message: error)))
                } catch DecodingError.dataCorrupted(let context) {
                    let error = "\(context.debugDescription)/n/n codingPath: \(context.codingPath)"
                    return (.failure(NetworkError.init(message: error)))
                } catch {
                    return (.failure(error))
                }
            case 201?:
                do {
                    let model = try JSONDecoder().decode(M.self, from: response.data ?? Data())
                    return (.success(model))
                } catch { return (.failure(error)) }
            case 400?:
               // UIApplication.topViewController()?.stopLoading()
                CustomLoader.customLoaderObj.stopAnimating()
                let error: NetworkError = .init(message: getErrorMessage(data: response.data ?? Data()) ?? "")
                return (.failure(error))
            case 401?:
//                UD.user = nil
//                UD.userEmail = nil
//                UD.webinarData = nil
//                UD.LoginRemember = false
//                UD.isUserHasLevel = false
//                UD.accessToken = nil
//                UD.isTookPlacement = nil
               // CustomLoader.customLoaderObj.stopAnimating()
                let error: NetworkError = .init(message: getErrorMessage(data: response.data ?? Data()) ?? "")
                return (.failure(error))
             
            case 404?:
//                if retryCount < 3 {
//                    retryCount += 1
//                    print("Retry Number " + "\(retryCount)")
//                    self.beginRequest(for: requestt, model: model, withSave: false)
//                } else {
//                    retryCount = 0
//                    print("Done")
                CustomLoader.customLoaderObj.stopAnimating()
                    let error: NetworkError = .init(message: "unknown error".localized)
                    return (.failure(error))
           //     }
                
            case 422?:
                CustomLoader.customLoaderObj.stopAnimating()
                let error: NetworkError = .init(message: getErrorMessage(data: response.data ?? Data()) ?? "")
                return (.failure(error))
            case 426?:
                CustomLoader.customLoaderObj.stopAnimating()
                let error: NetworkError = .init(message: getErrorMessage(data: response.data ?? Data()) ?? "")
                return (.failure(error))
            case 500?:
                CustomLoader.customLoaderObj.stopAnimating()
                let error: NetworkError = .init(message: "unknown error".localized)
                return (.failure(error))
            case 503?:
                ()
            case .none:
                break
            case .some(let error):
                CustomLoader.customLoaderObj.stopAnimating()
                let error: NetworkError = .init(message: error.string)
                return (.failure(error))
            }
        case .failure(let error):
           
            if response.response?.statusCode == 401 {
                ()
                
            } else {
                CustomLoader.customLoaderObj.stopAnimating()
               // self.makeAlert(error.localizedDescription, closure: {})
            }
        }
        return nil
    }
}
// MARK: - ...  Begin requets
extension BaseNetworkManager {
    
    
    @discardableResult
    func beginRequest<M: Codable>(for request: DataRequest?, model: M.Type, withSave save: Bool? = true) -> NetworkFuture<M?, NetworkError>? {
        guard let request = request else {
            return nil
        }
        
        self.run()
        if save == true {
            self.request = request.convertible.urlRequest
        }
        
        return NetworkFuture { promise in
            func executeRequest() {
                request.responseJSON { [weak self] response in
                    print("Response:::\(response)")
                    if let httpBody = request.convertible.urlRequest?.httpBody {
                        let bodyString = String(data: httpBody, encoding: .utf8)
                        print("HTTP Body Parameters: \(bodyString ?? "No parameters")")
                    }
                    let parsing = self?.response(response: response, model, requestt: request)
                    switch parsing {
                    case .success(let model):
                        promise(.success(model))
                    case .failure(let error):
                        guard let error = error as? NetworkError else { return }
                        if response.response?.statusCode == 401 {
                            //CustomLoader.customLoaderObj.startAnimating()
                            Authentication.shared.refreshToken { [weak self] success in
                                if success {
                                    guard let accessToken = Authentication.shared.token else { return }
                                    let tokenWithPrefix = "Bearer \(accessToken)"
                                    
                                    // Create a mutable copy of the original request
                                    if var mutableRequest = try? request.convertible.urlRequest?.asURLRequest() {
                                        mutableRequest.setValue(tokenWithPrefix, forHTTPHeaderField: "Authorization")
                                        
                                        // Use the updated request for the network call
                                        let updatedRequest = AF.request(mutableRequest)
                                        
                                        // Fulfill the original promise with the result of the updated request
                                        updatedRequest.responseJSON { [weak self] updatedResponse in
                                            let updatedParsing = self?.response(response: updatedResponse, model, requestt: updatedRequest)
                                            switch updatedParsing {
                                            case .success(let updatedModel):
                                                promise(.success(updatedModel))
                                            case .failure(let updatedError):
                                                promise(.failure(updatedError as! NetworkError))
                                            case .none:
                                                break
                                            }
                                        }
                                    } else {
                                        promise(.failure(error))
                                    }
                                } else {
                                    promise(.failure(error))
                                }
                            }
                        } else {
                            promise(.failure(error))
                        }
                    case .none:
                        break
                    }
                }
            }
            
            // Initial request execution
            executeRequest()
        }
    }

    
//    @discardableResult
//    func beginRequest<M: Codable>(for request: DataRequest?, model: M.Type, withSave save: Bool? = true) -> NetworkFuture<M?, NetworkError>? {
//        guard let request = request else {
//            return nil
//        }
//
//        self.run()
//        if save == true {
//            self.request = request.convertible.urlRequest
//        }
//        return NetworkFuture { promise in
//            func executeRequest() {
//                request.responseJSON { [weak self] response in
//                    print("Response:::\(response)")
//                    let parsing = self?.response(response: response, model, requestt: request)
//                    switch parsing {
//                    case .success(let model):
//                        promise(.success(model))
//                    case .failure(let error):
//                        guard let error = error as? NetworkError else { return }
//                        if response.response?.statusCode == 401 {
//                            Authentication.shared.refreshToken { [weak self] success in
//                                if success {
//                                    guard let accessToken = Authentication.shared.token else {return}
//                                    let tokenWithPrefix = "Bearer \(accessToken)"
//                                    promise(.failure(error))
//                                } else {
//                                    promise(.failure(error))
//                                }
//                            }
//                        }
//                    case .none:
//                        break
//                    }
//                }
//            }
//
//            // Initial request execution
//            executeRequest()
//        }
//    }

//    func beginRequest<M: Codable>(for request: DataRequest?, model: M.Type, withSave save: Bool? = true) -> NetworkFuture<M?, NetworkError>? {
//        guard let request = request else {
//            return nil
//        }
//
//        self.run()
//        if save == true {
//            self.request = request.convertible.urlRequest
//        }
//        return NetworkFuture { promise in
//            request.responseJSON {[weak self] response in
//                print("Response:::\(response)")
//                let parsing = self?.response(response: response, model, requestt: request)
//                switch parsing {
//                case .success(let model):
//                    promise(.success(model))
//                case .failure(let error):
//                    if self?.retryCount ?? 0 < 2 {
//                        self?.retryCount += 1
//                        print("Retry Number " + "\(self?.retryCount ?? 0)")
//                        self?.beginRequest(for: request, model: model, withSave: save)
//                    } else {
//                        guard let error = error as? NetworkError else { return }
//                        promise(.failure(error))
//                    }
//                case .none:
//                    break
//                }
//            }
//        }
//    }
    func presentUploadProgress<M: Codable>(upload: UploadRequest, _ model: M.Type) -> NetworkFuture<M?, NetworkError>? {
        self.presenting()
        upload.uploadProgress(closure: { (progress) in
            print("Upload Progress: \(progress.fractionCompleted)")
//            self.progressView.setProgress(Float(progress.fractionCompleted), animated: true)
            var progress = progress.fractionCompleted
            progress *= 100
            print("\(Int(progress))"+"%")
//            self.label.text =
        })
        return self.beginRequest(for: upload, model: model)
    }
}


// MARK: - ...  Make Requets
extension BaseNetworkManager {
    // MARK: - ...  Basic request with type
    @discardableResult
    func connection<M: Codable>(_ method: String, type: HTTPMethod, _ model: M.Type, isResponsetypeRequired: Bool? = nil) -> NetworkFuture<M?, NetworkError>? {
        if !checkReachability() {
            return nil
        }
        var url = initURL(method: method, type: type, isResponsetypeRequired: isResponsetypeRequired)
        let paramters = self.paramaters
        self.resetObject()
        url = safeUrl(url: url)
        
        let request = AF.request(url, method: type, parameters: paramters, headers: self.header)
        print(url)
        print(paramters)
        
        return self.beginRequest(for: request, model: model)
    }
    
    // MARK: - ...  Advanced request for raw with json object
    @discardableResult
    func connectionRaw<M: Codable>(_ method: String, type: HTTPMethod, json: Data? = nil, _ model: M.Type, withSave save: Bool? = false) -> NetworkFuture<M?, NetworkError>? {
        if !checkReachability() {
            return nil
        }
        let url = initURL(method: method, type: type)
        print("URLLL:::>>>\(url)")
        var paramters = self.paramaters
        print("PARAMS:::>>>\(paramters)")
        
        self.resetObject()
        let manager = AF//Session(interceptor: CustomRequestRetrier(maxRetryCount: 3)) // Use a customized session with the CustomRequestRetrier
        manager.session.configuration.timeoutIntervalForRequest = 30
        manager.session.configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        var session = URLRequest(url: URL(string: safeUrl(url: url))!)
        if json != nil {
            let paramString = String(data: json ?? Data(), encoding: .utf8)
            session.httpBody = paramString?.data(using: .utf8)
        } else {
            do {
                let data = try JSONSerialization.data(withJSONObject: paramters, options: [])
                let paramString = String(data: data, encoding: String.Encoding.utf8)
                session.httpBody = paramString?.data(using: .utf8)
            } catch let error {
                print("Error : \(error.localizedDescription)")
            }
        }
         headers.append(.init(name: "Content-Type", value: "application/json"))
        headers.append(.init(name: "Accept", value: "application/json"))
        headers.append(.init(name: "Authorization", value: "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")))
        // headers.append(.init(name: "Authorization", value: "Bearer H_Ri8jk450brI3hTjYlw4ziaSm_cVeVy4TZ98pBGfY7ZabRHeNPUC8chuB8NL9vxsSsj99_ZFUvvSzWQ4ejbyoVuPLCuLpMJVEUC1yiw99KBckWS-O84WOFYYzBPQgbgN9KDVJExgf6Y2qdJOlCI39JV-YlZdNS0OZfxvPte5VOBp_7-9SGX-lSnkKbkwHMGdX7VzoDhqh4o5Wfxl7Rwgos-V3-QlbAxNCCXKs2b-pTCuJEYiyLF6JPTKc9-CqkMbAliFMbwU_CtJwGNb50BJxKvT2Zh4vKQ72kGlrQCzy8L8wx1RvBk8wLVk5tsspDWY4ad96dF77F6XOkj_eyqHNc3OUelDWV08Yu1cFRdvv-O8Mnu-6ndNlsMwqsGx2ZS"))
        
        session.httpMethod = type.rawValue
        session.allHTTPHeaderFields = header.dictionary
        session.cachePolicy = .reloadIgnoringCacheData // <<== Cache disabled
        let request = AF.request(session)
        return self.beginRequest(for: request, model: model, withSave: save)
    }
    // MARK: - ...  Advanced request for upload files & only file // type URL
    func uploadMultiFiles<M: Codable>(_ method: String , type: HTTPMethod, files: [URL], key: String,
                                      file: [String: URL?]? = nil, _ model: M.Type) -> NetworkFuture<M?, NetworkError>? {
        if !checkReachability() {
            return nil
        }
        let url = self.url+method
        let paramters = self.paramaters
        self.resetObject()
        self.run()
        let upload = AF.upload(multipartFormData: { multipartFormData in
            var counter = 0
            files.forEach({ (item) in
                multipartFormData.append(item, withName: "\(key)[\(counter)]")
                counter += 1
            })
            if file != nil {
                file?.forEach({ (fileData) in
                    if let url = fileData.value {
                        multipartFormData.append(url, withName: "\(fileData.key)")
                    }
                })
            }
            for (key, value) in paramters {
                multipartFormData.append("\(value)".data(using: .utf8) ?? Data(), withName: key)
            } //Optional for extra parameters
        },to: url, headers: header)
        
        return presentUploadProgress(upload: upload, model)
    }
    
    // MARK: - ...  Advanced request for upload files & only file // type UIImage
    func uploadMultiFiles<M: Codable>(_ method: String , type: HTTPMethod, files: [UIImage], key: String, file: [String: UIImage?]? = nil, _ model: M.Type) -> NetworkFuture<M?, NetworkError>? {
        if !checkReachability() {
            return nil
        }
        let url = self.url+method
        let paramters = self.paramaters
        self.resetObject()
        self.run()
        let upload = AF.upload(multipartFormData: { multipartFormData in
            var counter = 0
            for item in files {
                //multipartFormData.append(item, withName: "\(key)[\(counter)]")
                multipartFormData.append(item.jpegData(compressionQuality: 0.5) ?? Data(),
                                         withName: "\(key)[\(counter)]", fileName: "\(String.random(ofLength: 15)).jpg", mimeType: "image/jpeg")
                counter += 1
            }
            if file != nil {
                file?.forEach({ (fileData) in
                    if let image = fileData.value {
                        multipartFormData.append(image.jpegData(compressionQuality: 0.5) ?? Data(),
                                                 withName: "\(fileData.key)", fileName: "\(String.random(ofLength: 15)).jpg", mimeType: "image/jpeg")
                        
                    }
                })
            }
            for (key, value) in paramters {
                multipartFormData.append("\(value)".data(using: .utf8) ?? Data(), withName: key)
            } //Optional for extra parameters
        },to: url, headers: header)
        
        return presentUploadProgress(upload: upload, model)
        
    }
    // MARK: - ...  Advanced request for upload files & only file // type UIImage
    func uploadMultiFiles<M: Codable>(_ method: String , type: HTTPMethod, files: [String: UIImage]? = nil, file: [String: UIImage?]? = nil, _ model: M.Type) -> NetworkFuture<M?, NetworkError>? {
        if !checkReachability() {
            return nil
        }
        let url = self.url+method
        let paramters = self.paramaters
        self.resetObject()
        self.run()
        let upload = AF.upload(multipartFormData: { multipartFormData in
            var counter = 0
            for item in files ?? [:] {
                multipartFormData.append(item.value.jpegData(compressionQuality: 0.5) ?? Data(),
                                         withName: "\(item.key)", fileName: "\(String.random(ofLength: 15)).jpg", mimeType: "image/jpeg")
                counter += 1
            }
            if file != nil {
                file?.forEach({ (fileData) in
                    if let image = fileData.value {
                        multipartFormData.append(image.jpegData(compressionQuality: 0.5) ?? Data(),
                                                 withName: "\(fileData.key)", fileName: "\(String.random(ofLength: 15)).jpg", mimeType: "image/jpeg")
                        
                    }
                })
            }
            for (key, value) in paramters {
                multipartFormData.append("\(value)".data(using: .utf8) ?? Data(), withName: key)
            } //Optional for extra parameters
        },to: url, headers: header)
        
        return presentUploadProgress(upload: upload, model)
    }
}
        
//        // MARK: - ...  send request with retry for 401 error
//        func sendRequest<T: Codable>(_ urlConvertible: URLRequestConvertible, completion: @escaping (Result<T, Error>) -> Void) {
//
//            AF.request(urlConvertible).validate().responseDecodable(of: T.self) { response in
//
//                switch response.result {
//                case .success(let result):
//                    completion(.success(result))
//
//                case .failure(let error):
//                    if let statusCode = response.response?.statusCode, statusCode == 401, self.retryCount < self.maxRetryCount {
//                        self.retryCount += 1
//                        Authentication.shared.refreshToken { success in
//                            if success {
//                                self.sendRequest(urlConvertible, completion: completion)
//                            } else {
//                                completion(.failure(error))
//                            }
//                        }
//                    } else {
//                        completion(.failure(error))
//                    }
//                }
//            }
//        }
