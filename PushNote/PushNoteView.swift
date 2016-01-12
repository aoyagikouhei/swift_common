//
//  PushNoteView.swift
//
//  Created by AoyagiKouhei on 2016/01/08.
//  Copyright © 2016年 uniquevision. All rights reserved.
//

import UIKit

// プッシュ通知が来た時に上に表示するビュー
// https://github.com/avielg/AGPushNote
class PushNoteView: UIView {
    // 開くまでの時間
    static let openDuration: NSTimeInterval = 0.5
    
    // 閉じるまでの時間
    static let closeDuration: NSTimeInterval = 0.3
    
    // 表示している時間
    static let viewDuration: NSTimeInterval = 5.0
    
    // 唯一のインスタンス
    static var instance: PushNoteView?
    
    // インスタンス取得
    class func getInstance() -> PushNoteView {
        if nil != instance {
            return instance!
        }
        let nib = UINib(nibName: "PushNoteView", bundle: NSBundle.mainBundle())
        instance = nib.instantiateWithOwner(self, options: nil).first as? PushNoteView
        instance?.setup()
        return instance!
    }
    
    // 表示する
    class func show(msg: String, touchHandler: (() -> Void)? = nil) {
        let view = getInstance()
        view.messageLabel.text = msg
        view.touchHandler = touchHandler
        let f = view.frame
        UIView.animateWithDuration(
            PushNoteView.openDuration, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            view.frame = CGRectMake(f.origin.x, 0, f.size.width, f.size.height)
            }) { (flag) in
                view.timer = NSTimer.scheduledTimerWithTimeInterval(PushNoteView.viewDuration, target: view, selector: "close", userInfo: nil, repeats: false)
        }
    }
    
    @IBOutlet weak var messageLabel: UILabel!
    var timer: NSTimer?
    private var gesture: UITapGestureRecognizer?
    var touchHandler: (() -> Void)?

    // セットアップ
    func setup() {
        let app = UIApplication.sharedApplication()
        
        // 自身のサイズを指定する
        let width = app.keyWindow!.bounds.size.width
        let f = self.frame
        self.frame = CGRectMake(0, -f.size.height, width, f.size.height)
        
        self.gesture = UITapGestureRecognizer(target: self, action: "onTouch:")
        self.messageLabel.addGestureRecognizer(self.gesture!)
        self.messageLabel.userInteractionEnabled = true
        
        app.delegate?.window!?.addSubview(self)
    }
    
    // クローズ
    func close() {
        if let timer = self.timer {
            timer.invalidate()
            self.timer = nil
        }
        
        let f = self.frame
        UIView.animateWithDuration(
            PushNoteView.closeDuration, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.frame = CGRectMake(0, -f.size.height, f.size.width, f.size.height)
            },completion: nil)
    }
    
    // 即クローズ
    func fastClose() {
        if let timer = self.timer {
            timer.invalidate()
            self.timer = nil
        }
        let f = self.frame
        self.frame = CGRectMake(0, -f.size.height, f.size.width, f.size.height)
    }
    
    // クローズボタンが押された
    @IBAction func onClose(sender: AnyObject) {
        self.close()
    }
    
    // ラベルがタッチされた
    func onTouch(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .Ended {
            self.fastClose()
            if nil != self.touchHandler {
                self.touchHandler!()
            }
        }
    }
}
