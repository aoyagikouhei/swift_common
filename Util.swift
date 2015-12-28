//
//  URL.swift
//
//  Created by AoyagiKouhei on 2015/12/29.
//  Copyright © 2015年 AoyagiKouhei. All rights reserved.
//

import Foundation

class Util {
    // メインサイズを取得する
    class func getMainWidth() -> CGFloat {
        let myBoundSize: CGSize = UIScreen.mainScreen().bounds.size
        return myBoundSize.width
    }
    
    // 正規表現 パターンに一致したものがある場合はtrueを返却
    class func isMatchPattern(text: String, pattern: String) -> Bool {
        do {
            let regex = try NSRegularExpression(
                pattern: pattern,
                options: [.CaseInsensitive]
            )
            let matched = regex.firstMatchInString(
                text,
                options: NSMatchingOptions(),
                range: NSMakeRange(0, text.characters.count)
            )
            return matched != nil
        }
        catch {
            return false
        }
    }
}