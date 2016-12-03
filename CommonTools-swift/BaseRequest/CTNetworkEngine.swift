//
//  CTNetworkEngine.swift
//  Pods
//
//  Created by zhy on 9/5/16.
//  Copyright © 2016 OCT. All rights reserved.
//

import Foundation
import AFNetworking


public let CTNetworkingEngineTypeCommon:Int32 = 0
public let CTNetworkingEngineTypeUpload:Int32 = 1
public let CTNetworkingEngineTypeDownload:Int32 = 2

public typealias successBlock = (Any?) -> Void
public typealias failBlock = (Any?) -> Void
public typealias CTUploadProgress = (Int64, Int64) -> Void
public typealias CTDownloadProgress = (Int64, Int64) -> Void

open class CTNetworkEngine: NSObject {
    open var timeoutInterval: TimeInterval?
    
    open var HOST: String?
    
    lazy var operationManager: AFHTTPRequestOperationManager = {
        return AFHTTPRequestOperationManager()
    }()
    
    
    static let instance = CTNetworkEngine()
    
    open func httpRequest(_ type: String?, URLString: String?, parameters: NSDictionary?, files: NSArray?, filesData: Data?, fileUploadKey: NSString?, savedFilePath: NSString?, requestType:NSNumber?, success: successBlock?, fail: failBlock?, uploadProgress: CTUploadProgress?, downloadProgress: CTDownloadProgress?) -> Operation {
        
        var fixedURLString = URLString
        if !(fixedURLString!.hasPrefix("http://") || fixedURLString!.hasPrefix("https://")) && HOST != nil
        {
            fixedURLString = HOST! + fixedURLString!
        }
        
        operationManager.requestSerializer.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData;
        operationManager.requestSerializer.timeoutInterval = (timeoutInterval != nil) ? timeoutInterval! : 10
        operationManager.responseSerializer.acceptableContentTypes = NSSet.init(objects: "text/plain", "text/html", "video/mp4", "application/json", "application/octet-stream") as Set<NSObject>
        var operation: Operation = Operation.init()
        if fixedURLString == nil {
            return operation
        }
        switch requestType!.int32Value {
        case CTNetworkingEngineTypeCommon:
            operation = commonHttpRequest(type, URLString: fixedURLString, parameters: parameters, success: success, fail: fail)
        case CTNetworkingEngineTypeUpload:
            operation = uploadRequest(fixedURLString, parameters: parameters, files: files, filesData: filesData, fileUploadKey: fileUploadKey, success: success, fail: fail, uploadProgress: uploadProgress)
        case CTNetworkingEngineTypeDownload:
//            operation = downloadRequest(fixedURLString, parameters: parameters, savedFilePath: savedFilePath, success: success, fail: fail, downloadProgress: downloadProgress)
            break
        default: break
        }
        return operation
    }
    
    fileprivate func commonHttpRequest(_ type: String?, URLString: String?, parameters: NSDictionary?, success: successBlock?, fail: failBlock?) -> Operation {
        var requestOperation: AFHTTPRequestOperation = AFHTTPRequestOperation.init()
        if (type == "GET") {
            requestOperation = operationManager.get(URLString! as String, parameters: parameters!, success: { (operation: AFHTTPRequestOperation?, responseObject: Any?) in
                var returnObject: Any?
                do {
                    try returnObject = JSONSerialization.jsonObject(with: operation!.responseData, options: JSONSerialization.ReadingOptions.mutableContainers)
                } catch {}
                success?(returnObject)
                }, failure: { (operation: AFHTTPRequestOperation?, error: Error?) in
                    fail?(error as AnyObject)
            })
        } else if (type == "POST") {
            requestOperation = operationManager.post(URLString! as String, parameters: parameters, success: { (operation: AFHTTPRequestOperation?, responseObject: Any?) in
                var returnObject: Any?
                do {
                    try returnObject = JSONSerialization.jsonObject(with: operation!.responseData, options: JSONSerialization.ReadingOptions.mutableContainers)
                } catch {}
                success?(returnObject)
                }, failure: { (operation: AFHTTPRequestOperation?, error: Error?) in
                    fail?(error)
            })
        }
        return requestOperation
    }
    
    fileprivate func uploadRequest(_ URLString: String?, parameters: NSDictionary?, files: NSArray?, filesData: Data?, fileUploadKey: NSString?, success: successBlock?, fail: failBlock?, uploadProgress: CTUploadProgress?) -> Operation {
        var requestOperation: AFHTTPRequestOperation = AFHTTPRequestOperation.init()
        if (files?.count)! > 0 || filesData != nil {
            requestOperation = operationManager.post(URLString, parameters: parameters!, constructingBodyWith: { (formData: AFMultipartFormData?) in
                if (files?.count)! > 0 {
                    for filePath in files! {
                        if !FileManager.default.fileExists(atPath: filePath as! String) {
                            continue
                        }
                        
                        let fileData: Data? = try? Data.init(contentsOf: URL(fileURLWithPath: filePath as! String))
                        let nameStr: String = (fileUploadKey != nil) ? fileUploadKey! as String : "files"
                        formData!.appendPart(withFileData: fileData, name: nameStr, fileName: (filePath as! NSString).lastPathComponent, mimeType: "application/octet-stream")
                    }
                } else if filesData != nil {
                    let nameStr: String = (fileUploadKey != nil) ? fileUploadKey! as String : "files"
                    formData!.appendPart(withFileData: filesData!, name: nameStr, fileName: "file", mimeType: "application/octet-stream")
                }
                
                }, success: { (operation: AFHTTPRequestOperation?, responseObject: Any?) in
                    var returnObject: Any?
                    do {
                        try returnObject = JSONSerialization.jsonObject(with: operation!.responseData, options: JSONSerialization.ReadingOptions.mutableContainers)
                    } catch {}
                    success?(returnObject)
                }, failure: { (operation: AFHTTPRequestOperation?, error: Error?) in
                    fail?(error)
            })
            requestOperation.setUploadProgressBlock({ (bytesWritten: UInt, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) in
                uploadProgress?(totalBytesWritten, totalBytesExpectedToWrite)
            })
        }
        return requestOperation
    }
//    fileprivate func downloadRequest(_ URLString: NSString?, parameters: NSDictionary?, savedFilePath: NSString?, success: successBlock?, fail: failBlock?, downloadProgress: CTDownloadProgress?) -> Operation {
//        var requestOperation: AFHTTPRequestOperation = AFHTTPRequestOperation.init()
//        var destinationFilePath: String
//        let fileManager: FileManager = FileManager.default
//        
//        
//        
//        if savedFilePath != nil {
//            destinationFilePath = savedFilePath as! String
//            
//            if fileManager.fileExists(atPath: destinationFilePath) {
//                var attributes: NSDictionary
//                do {
//                    try attributes = fileManager.attributesOfItem(atPath: destinationFilePath) as NSDictionary
//                    let theFileSize = attributes.object(forKey: FileAttributeKey.size)
//                    if (theFileSize as AnyObject).int32Value == 0 {
//                        do {
//                            try fileManager.removeItem(atPath: destinationFilePath)
//                        } catch {}
//                    }
//                } catch {}
//            }
//            
//            if fileManager.fileExists(atPath: destinationFilePath) {
//                let resultDict = ["errorCode":"-1", "savedFilePath":destinationFilePath]
//                success?(resultDict as Any?)
//                return requestOperation
//            }
//        } else {
//            let pathsArray = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
//            destinationFilePath = pathsArray.first! + "/CTCaches/" + URLString!.lastPathComponent
//            
//            
//            if fileManager.fileExists(atPath: destinationFilePath) {
//                var attributes: NSDictionary
//                do {
//                    try attributes = fileManager.attributesOfItem(atPath: destinationFilePath) as NSDictionary
//                    let theFileSize = attributes.object(forKey: FileAttributeKey.size)
//                    if (theFileSize as AnyObject).int32Value == 0 {
//                        do {
//                            try fileManager.removeItem(atPath: destinationFilePath)
//                        } catch {}
//                    }
//                } catch {}
//            }
//            
//            if !fileManager.fileExists(atPath: destinationFilePath) {
//                do {
//                    try fileManager.createDirectory(atPath: pathsArray.first! + "/CTCaches", withIntermediateDirectories: true, attributes: nil)
//                } catch{}
//            } else {
//                let resultDict = ["errorCode":"-1", "savedFilePath":destinationFilePath]
//                success?(resultDict as Any?)
//                return requestOperation
//            }
//        }
//        
//        requestOperation = self.operationManager.httpRequestOperation(with: URLRequest.init(url: URL.init(string: URLString! as String)!), success: { (operation: AFHTTPRequestOperation?, responseObject: Any?) in
//            let resultDict = ["errorCode":"-1", "savedFilePath":destinationFilePath]
//            success?(resultDict as Any?)
//            }, failure: { (operation: AFHTTPRequestOperation?, error: Error?) in
//                fail?(error)
//        })
//        requestOperation.inputStream = InputStream.init(url: URL.init(string: URLString! as String)!)
//        requestOperation.outputStream = OutputStream.init(toFileAtPath: destinationFilePath, append: false)
//        requestOperation.setDownloadProgressBlock { (bytesRead: UInt, totalBytesRead: Int64, totalBytesExpectedToRead: Int64) in
//            downloadProgress?(totalBytesRead, totalBytesExpectedToRead)
//        }
//        operationManager.operationQueue .addOperation(requestOperation)
//        return requestOperation
//    }
}
