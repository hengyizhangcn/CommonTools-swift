//
//  KMNetworkEngine.swift
//  Kotmi
//
//  Created by zhy on 7/21/16.
//  Copyright © 2016 HangZhou WeiQun IT Co., Ltd. All rights reserved.
//

import Foundation

public let KMNetworkingEngineTypeCommon:Int32 = 0
public let KMNetworkingEngineTypeUpload:Int32 = 1
public let KMNetworkingEngineTypeDownload:Int32 = 2

public typealias successBlock = (AnyObject?) -> Void
public typealias failBlock = (AnyObject?) -> Void
public typealias fbUploadProgress = (Int64, Int64) -> Void
public typealias fbDownloadProgress = (Int64, Int64) -> Void

public class KMNetworkEngine: NSObject {
    public var timeoutInterval: NSTimeInterval?
    
    private lazy var operationManager: AFHTTPRequestOperationManager = {
        return AFHTTPRequestOperationManager()
    }()
    
    
    static let instance = KMNetworkEngine()
    
    public func httpRequest(type: NSString?, URLString: NSString?, parameters: NSDictionary?, files: NSArray?, filesData: NSData?, fileUploadKey: NSString?, savedFilePath: NSString?, requestType:NSNumber?, success: successBlock?, fail: failBlock?, uploadProgress: fbUploadProgress?, downloadProgress: fbDownloadProgress?) -> NSOperation {
        operationManager.requestSerializer.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData;
        operationManager.requestSerializer.timeoutInterval = (timeoutInterval != nil) ? timeoutInterval! : 10
        operationManager.responseSerializer.acceptableContentTypes = NSSet.init(objects: "text/html", "video/mp4", "application/json", "application/octet-stream") as Set<NSObject>
        var operation: NSOperation = NSOperation.init()
        if URLString == nil {
            return operation
        }
        switch requestType!.intValue {
        case KMNetworkingEngineTypeCommon:
            operation = commonHttpRequest(type, URLString: URLString, parameters: parameters, success: success, fail: fail)
        case KMNetworkingEngineTypeUpload:
            operation = uploadRequest(URLString, parameters: parameters, files: files, filesData: filesData, fileUploadKey: fileUploadKey, success: success, fail: fail, uploadProgress: uploadProgress)
        case KMNetworkingEngineTypeDownload:
            operation = downloadRequest(URLString, parameters: parameters, savedFilePath: savedFilePath, success: success, fail: fail, downloadProgress: downloadProgress)
        default: break
        }
        return operation
    }
    
    private func commonHttpRequest(type: NSString?, URLString: NSString?, parameters: NSDictionary?, success: successBlock?, fail: failBlock?) -> NSOperation {
        var requestOperation: AFHTTPRequestOperation = AFHTTPRequestOperation.init()
        if (type!.isEqualToString("GET")) {
            requestOperation = operationManager.GET(URLString! as String, parameters: parameters!, success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                var returnObject: AnyObject?
                do {
                    try returnObject = NSJSONSerialization.JSONObjectWithData(operation!.responseData, options: NSJSONReadingOptions.MutableContainers)
                } catch {}
                success?(returnObject)
                }, failure: { (operation: AFHTTPRequestOperation?, error: NSError?) in
                    fail?(error)
            })
        } else if (type!.isEqualToString("POST")) {
            requestOperation = operationManager.POST(URLString! as String, parameters: parameters, success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                var returnObject: AnyObject?
                do {
                    try returnObject = NSJSONSerialization.JSONObjectWithData(operation!.responseData, options: NSJSONReadingOptions.MutableContainers)
                } catch {}
                success?(returnObject)
                }, failure: { (operation: AFHTTPRequestOperation?, error: NSError?) in
                    fail?(error)
            })
        }
        return requestOperation
    }
    
    private func uploadRequest(URLString: NSString?, parameters: NSDictionary?, files: NSArray?, filesData: NSData?, fileUploadKey: NSString?, success: successBlock?, fail: failBlock?, uploadProgress: fbUploadProgress?) -> NSOperation {
        var requestOperation: AFHTTPRequestOperation = AFHTTPRequestOperation.init()
        if files?.count > 0 || filesData != nil {
            requestOperation = operationManager.POST(URLString as! String, parameters: parameters!, constructingBodyWithBlock: { (formData: AFMultipartFormData!) in
                if files?.count > 0 {
                    for filePath in files! {
                        if !NSFileManager.defaultManager().fileExistsAtPath(filePath as! String) {
                            continue
                        }
                        
                        let fileData: NSData? = NSData.init(contentsOfFile: filePath as! String)
                        let nameStr: String = (fileUploadKey != nil) ? fileUploadKey! as String : "files"
                        formData .appendPartWithFileData(fileData, name: nameStr, fileName: filePath.lastPathComponent, mimeType: "application/octet-stream")
                    }
                } else if filesData != nil {
                    let nameStr: String = (fileUploadKey != nil) ? fileUploadKey! as String : "files"
                    formData .appendPartWithFileData(filesData!, name: nameStr, fileName: "file", mimeType: "application/octet-stream")
                }
                
                }, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject?) in
                    var returnObject: AnyObject?
                    do {
                        try returnObject = NSJSONSerialization.JSONObjectWithData(operation!.responseData, options: NSJSONReadingOptions.MutableContainers)
                    } catch {}
                    success?(returnObject)
                }, failure: { (operation: AFHTTPRequestOperation?, error: NSError?) in
                    fail?(error)
            })
            requestOperation.setUploadProgressBlock({ (bytesWritten: UInt, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) in
                uploadProgress?(totalBytesWritten, totalBytesExpectedToWrite)
            })
        }
        return requestOperation
    }
    private func downloadRequest(URLString: NSString?, parameters: NSDictionary?, savedFilePath: NSString?, success: successBlock?, fail: failBlock?, downloadProgress: fbDownloadProgress?) -> NSOperation {
        var requestOperation: AFHTTPRequestOperation = AFHTTPRequestOperation.init()
        var destinationFilePath: String
        let fileManager: NSFileManager = NSFileManager.defaultManager()
        
        
        
        if savedFilePath != nil {
            destinationFilePath = savedFilePath as! String
            
            if fileManager.fileExistsAtPath(destinationFilePath) {
                var attributes: NSDictionary
                do {
                    try attributes = fileManager.attributesOfItemAtPath(destinationFilePath) as NSDictionary
                    let theFileSize = attributes.objectForKey(NSFileSize)
                    if theFileSize?.intValue == 0 {
                        do {
                            try fileManager.removeItemAtPath(destinationFilePath)
                        } catch {}
                    }
                } catch {}
            }
            
            if fileManager.fileExistsAtPath(destinationFilePath) {
                let resultDict = ["errorCode":"-1", "savedFilePath":destinationFilePath]
                success?(resultDict)
                return requestOperation
            }
        } else {
            let pathsArray = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
            destinationFilePath = pathsArray.first! + "/avCaches/" + URLString!.stringByDeletingPathExtension.stringFromMD5() + "." + URLString!.pathExtension
            
            
            if fileManager.fileExistsAtPath(destinationFilePath) {
                var attributes: NSDictionary
                do {
                    try attributes = fileManager.attributesOfItemAtPath(destinationFilePath) as NSDictionary
                    let theFileSize = attributes.objectForKey(NSFileSize)
                    if theFileSize?.intValue == 0 {
                        do {
                            try fileManager.removeItemAtPath(destinationFilePath)
                        } catch {}
                    }
                } catch {}
            }
            
            if !fileManager.fileExistsAtPath(destinationFilePath) {
                do {
                    try fileManager.createDirectoryAtPath(pathsArray.first! + "/avCaches", withIntermediateDirectories: true, attributes: nil)
                } catch{}
            } else {
                let resultDict = ["errorCode":"-1", "savedFilePath":destinationFilePath]
                success?(resultDict)
                return requestOperation
            }
        }
        
        requestOperation = self.operationManager.HTTPRequestOperationWithRequest(NSURLRequest.init(URL: NSURL.init(string: URLString! as String)!), success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject?) in
            let resultDict = ["errorCode":"-1", "savedFilePath":destinationFilePath]
            success?(resultDict)
            }, failure: { (operation: AFHTTPRequestOperation?, error: NSError?) in
                fail?(error)
        })
        requestOperation.inputStream = NSInputStream.init(URL: NSURL.init(string: URLString! as String)!)
        requestOperation.outputStream = NSOutputStream.init(toFileAtPath: destinationFilePath, append: false)
        requestOperation.setDownloadProgressBlock { (bytesRead: UInt, totalBytesRead: Int64, totalBytesExpectedToRead: Int64) in
            downloadProgress?(totalBytesRead, totalBytesExpectedToRead)
        }
        operationManager.operationQueue .addOperation(requestOperation)
        return requestOperation
    }
}