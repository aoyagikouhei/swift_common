//
//  URLData.swift
//
//  Created by AoyagiKouhei on 2015/12/29.
//  Copyright © 2015年 AoyagiKouhei. All rights reserved.
//

import Foundation

class URLData {
    let schema: String
    let path: String
    let query: Dictionary<String, String>
    
    init(strUrl: String) {
        let pattern = "([^:]+)://([^?]+)\\?(.+)"
        let str: NSString = strUrl as NSString
        let regex = try! NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive)
        let result: NSTextCheckingResult = regex.firstMatchInString(strUrl, options: [], range: NSMakeRange(0, strUrl.characters.count))!
        schema = str.substringWithRange(result.rangeAtIndex(1))
        path = str.substringWithRange(result.rangeAtIndex(2))
        var query = Dictionary<String, String>()
        let queryStr = str.substringWithRange(result.rangeAtIndex(3))
        let ary = queryStr.componentsSeparatedByString("&")
        for pair in ary {
            let pairAry = pair.componentsSeparatedByString("=")
            query[pairAry[0]] = pairAry[1]
        }
        self.query = query
    }
}