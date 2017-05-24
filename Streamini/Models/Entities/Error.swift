//
//  Error.swift
//  Streamini
//
//  Created by Vasily Evreinov on 08/02/15.
//  Copyright (c) 2015 UniProgy s.r.o. All rights reserved.
//

import Foundation

class Error : NSObject {
    static let kLoginExpiredCode: UInt  = 100
    static let kUnsuccessfullPing: UInt = 202
    static let kUserBlocked: UInt       = 201
    static let kPaidStream: UInt        = 1000
    static let kMoreCredits: UInt       = 1001

    var status             = false
    var code: UInt         = 0
    var message: NSString  = ""

    func toNSError() -> NSError {        
        let userInfo = NSMutableDictionary()
        userInfo[NSLocalizedDescriptionKey] = self.message
        userInfo["code"] = self.code
        
        let error = NSError(domain: "com.uniprogy.streamini", code: 1, userInfo: userInfo as! [AnyHashable: Any])
        return error
    }
}
