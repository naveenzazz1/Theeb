import UIKit

// MARK: - ...  Downloader delegate
protocol DownloaderDelegate: AnyObject {
    func taskComplete()
}
extension DownloaderDelegate {
    func taskComplete() {
    }
}
// MARK: - ...  Downloader class
class Downloader: NSObject, URLSessionDownloadDelegate, UIDocumentInteractionControllerDelegate {
    //** vars of task *//
    var presentProgressBar: Bool = false
    private var fileName: String? = ""
    private var downloadTask: URLSessionDownloadTask!
    private var backgroundSession: URLSession!
    /** presenting Control */
    private var presenter: UIViewController! = UIViewController()
    var progressView: UIProgressView!
    var parentView: UIView!
    var label: UILabel!
    //
    //delegation
    private weak var _delegate: DownloaderDelegate?
    var downloaderDelegate: DownloaderDelegate? {
        set {
            if newValue is UIViewController {
                _delegate = newValue
                presenter = newValue as? UIViewController
            } else {
                _delegate = newValue
                presenter = UIViewController()
            }
        } get {
            return _delegate
        }
    }
    ///
    func presenting() {
        
//        guard let window = UIApplication.keyWindow else {return}
//        progressView = UIProgressView()
//        progressView.frame = CGRect(x: self.presenter.view.width/4, y: self.presenter.view.height/2, width: self.presenter.view.width/100*50, height: 40)
//        parentView = UIView(frame: CGRect(x: 0, y: 0, width: self.presenter.view.width, height: self.presenter.view.height))
//        parentView.backgroundColor = UIColor.black.withAlphaComponent(0.50)
//        parentView.addSubview(progressView)
//        //self.presenter.view.addSubview(parentView)
//        label = UILabel()
//        label.frame = CGRect(x: 0, y: self.presenter.view.height/2+20, width: self.presenter.view.width, height: 20)
//        label.textColor = UIColor.white
//        label.textAlignment = .center
//        parentView.addSubview(label)
//        
//        if !presentProgressBar {
//            return
//        }
//        window.addSubview(parentView)
    }
    private func generateFileName(_ urlTask: String) {
        let file = URL(string: urlTask)
        guard let url = file else { return }
        self.fileName = String.random(ofLength: 20)+"."+url.pathExtension
    }
    private func initTask(_ urlTask: String) {
        let backgroundSessionConfiguration = URLSessionConfiguration.background(withIdentifier: "backgroundSession")
        backgroundSession = Foundation.URLSession(configuration: backgroundSessionConfiguration, delegate: self, delegateQueue: OperationQueue.main)
        progressView.setProgress(0.0, animated: false)
        let url = URL(string: urlTask)!
        downloadTask = backgroundSession.downloadTask(with: url)
        downloadTask.resume()
    }
    func restore() {
        if !presentProgressBar {
            return
        }
        self.parentView.removeFromSuperview()
    }
    private func showFileWithPath(file: String?) {
        guard let url = file else {return}
        print(url)
        let isFileFound: Bool? = FileManager.default.fileExists(atPath: url)
        if isFileFound == true {
            let viewer = UIDocumentInteractionController(url: URL(fileURLWithPath: url))
            viewer.delegate = self
            viewer.presentPreview(animated: true)
        }
    }
    func downloadFile(_ string: String?) {
        if downloaderDelegate == nil {
            return
        }
        guard let urlTask = string else { return }
        self.presenting()
        self.generateFileName(urlTask)
        self.initTask(urlTask)
    }
    func downloadPause() {
        if downloadTask != nil {
            downloadTask.suspend()
        }
    }
    func downloadResume() {
        if downloadTask != nil {
            downloadTask.resume()
        }
    }
    func downloadCancel() {
        if downloadTask != nil {
            downloadTask.cancel()
        }
    }
    // 1
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentDirectoryPath: String = path[0]
        let fileManager = FileManager()
        let destinationURLForFile = URL(fileURLWithPath: documentDirectoryPath.appendingFormat("/\(self.fileName ?? "file.pdf")"))
        if fileManager.fileExists(atPath: destinationURLForFile.path) {
            showFileWithPath(file: destinationURLForFile.path)
        } else {
            do {
                try fileManager.moveItem(at: location, to: destinationURLForFile)
                // show file
                showFileWithPath(file: destinationURLForFile.path)
            } catch {
                self.restore()
                print("An error occurred while moving file to destination url")
            }
        }
    }
    // 2
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        progressView.setProgress(Float(totalBytesWritten)/Float(totalBytesExpectedToWrite), animated: true)
        var progress = progressView.progress
        progress *= 100
//        label.text = progress.int.string+"%"
        
        label.text = "\(Int(progress))%"
    }
    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    didCompleteWithError error: Error?) {
        downloadTask = nil
        //progressView.setProgress(0.0, animated: true)
        if error != nil {
            self.restore()
            print(error!.localizedDescription)
        } else {
            self.restore()
            self.downloaderDelegate?.taskComplete()
            print("The task finished transferring data successfully")
        }
    }
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self.presenter
    }
}
