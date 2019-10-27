//
//  ViewController.swift
//  PBL2
//
//  Created by KurohataY on 2019/10/09.
//  Copyright © 2019 KurohataY. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController, WCSessionDelegate {

    //書き出し用
    var messageData: String = ""
    //動作状態
    var actionState: String!
    //ラベル
    var labelArray: [String] = ["date","attitude_picth","attitude_roll","attitude_yaw","gravity_x","gravity_y","gravity_z","rotationRate_x","rotationRate_y","rotationRate_z","userAcceleration_x","userAcceleration_y","userAcceleration_z","action\n"]
    //AppleWatchのCore Motionデータの格納場所
    var messageArray: [String] = []
    
    //ラベル付け
    @IBAction func changeButton(_ sender: Any) {
        actionState = "change"
    }
    //ラベル付け
    @IBAction func oneTouchButton(_ sender: Any) {
        actionState = "onetouch"
    }
    //ラベル付け
    @IBAction func outButton(_ sender: Any) {
        actionState = "out"
    }
    //ラベル付け
    @IBAction func noneButton(_ sender: Any) {
        actionState = ""
    }
    
    //書き込み処理(取り出し方：https://codeday.me/jp/qa/20190301/344079.html)
    @IBAction func fileWrite(_ sender: Any) {
        
        if let dir = FileManager.default.urls( for: .documentDirectory, in: .userDomainMask ).first {

            let filePath = dir.appendingPathComponent( "PBLtest.txt" )
            self.messageData += messageArray.joined(separator: ",")

            do {
                print("testing")
                print("filePath: \(filePath)")
                try messageData.write(to: filePath, atomically: true, encoding: .utf8)
            } catch {
                print("error")
            }
        }
    }
    //ロード時の処理
    override func viewDidLoad() {
        super.viewDidLoad()
        actionState = ""
        messageData = labelArray.joined(separator: ",")
        activateSession()
        
    }

    //AppleWatchとの通信処理
    func activateSession(){
        if WCSession.isSupported() {
            let session: WCSession = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    //メッセージを受け取りテキストデータとして格納処理
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {

        //メッセージを受け取り
        let params = message
        //メッセージを受け取りテキストデータとして格納
        messageArray.append(params["date"] as! String)
        messageArray.append(params["attitude_pitch"] as! String)
        messageArray.append(params["attitude_roll"] as! String)
        messageArray.append(params["attitude_yaw"] as! String)
        messageArray.append(params["gravity_x"] as! String)
        messageArray.append(params["gravity_y"] as! String)
        messageArray.append(params["gravity_z"] as! String)
        messageArray.append(params["rotationRate_x"] as! String)
        messageArray.append(params["rotationRate_y"] as! String)
        messageArray.append(params["rotationRate_z"] as! String)
        messageArray.append(params["userAcceleration_x"] as! String)
        messageArray.append(params["userAcceleration_y"] as! String)
        messageArray.append(params["userAcceleration_z"] as! String)
        
        //動作状態のラベル
        if actionState  == "change"{
            messageArray.append("change\n")
            print("change")
        }else if actionState  == "onetouch"{
            messageArray.append("onetouch\n")
            print("onetouch")
        }else if actionState  == "out"{
            messageArray.append("out\n")
            print("out")
        }else{
            messageArray.append("none\n")
            print("none")
        }

        replyHandler(["reply" : "Done"])
    }

    @available(iOS 9.3, *)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidComplete")
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        print("sessionDidBecomeInactive")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        print("sessionDidDeactivate")
    }
    
    
}

