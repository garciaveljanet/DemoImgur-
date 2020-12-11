//
//  AssetDownloadItem.swift
//  funi
//
import Foundation

typealias AssetDownloadItemCompletionHandler = ((_ result: RequestResult<Data>) -> Void)

enum Status: String {
    case waiting
    case downloading
    case suspended
    case canceled
}

class AssetDownloadItem {
    fileprivate let task: URLSessionDownloadTask
    var completionHandler: AssetDownloadItemCompletionHandler?
    var forceDownload = false
    var downloadPercentageComplete = 0.0
    var status = Status.waiting
    
    // MARK: - Init
    init(task: URLSessionDownloadTask) {
        self.task = task
    }
    
    // MARK: - Lifecycle
    func resume() {
        status = .downloading
        task.resume()
    }
    
    func pause() {
        status = .waiting
        forceDownload = false
        task.suspend()
    }
    
    func softCancel() {
        status = .suspended
        forceDownload = false
        task.suspend()
    }
    
    func hardCancel() {
        status = .canceled
        forceDownload = false
        task.cancel()
    }
    
    // MARK: - Meta
    var url: URL {
        return task.currentRequest!.url!
    }
    
    //MARK: - Coalesce
    func coalesce(_ additionalCompletionHandler: @escaping AssetDownloadItemCompletionHandler) {
        let initalCompletionHandler = completionHandler
        
        completionHandler = { (result) in
            if let initalCompletionClosure = initalCompletionHandler {
                initalCompletionClosure(result)
            }
            
            additionalCompletionHandler(result)
        }
    }
}
