//
//  InterfaceController.swift
//  PBL2 WatchKit Extension
//
//  Created by KurohataY on 2019/10/09.
//  Copyright © 2019 KurohataY. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity
import CoreMotion

class InterfaceController: WKInterfaceController, WCSessionDelegate {

    @IBOutlet weak var ActionData: WKInterfaceLabel!
    
    //CMMotionManager(データの習得のため)、OperationQueue(複数の非同期処理の終了を待ち合わせ)を利用
    let motionManager = CMMotionManager()
    let queue = OperationQueue()

    var randNum =  String(UInt32())
    
    //以下データ保存用の変数
    var applicationDict = [String: String]()
    //ディバイスの向き
    var attitude_pitch = ""
    var attitude_roll = ""
    var attitude_yaw = ""
    
    //重力加速度
    var gravity_x = ""
    var gravity_y = ""
    var gravity_z = ""
    
    //デバイスの回転速度
    var rotationRate_x = ""
    var rotationRate_y = ""
    var rotationRate_z = ""
    
    //ユーザが与えている加速度
    var userAcceleration_x = ""
    var userAcceleration_y = ""
    var userAcceleration_z = ""


    //アプリを立ち上げた時の処理
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        activateSession()
    }

    //iPhnoeとの通信処理
    func activateSession(){
        if WCSession.isSupported() {
            let session: WCSession = WCSession.default
            session.delegate = self
            session.activate()
        }
        sendMessage()
    }

    //データ習得＋iPhnoeにデータを送る
    func sendMessage(){
        //エラー処理
        if !motionManager.isDeviceMotionAvailable {
            print("Device Motion is not available.")
            return
        }

        if self.randNum == "" {
            motionManager.stopDeviceMotionUpdates()
            return
        }else{
            
            motionManager.startDeviceMotionUpdates(to: queue) { (deviceMotion: CMDeviceMotion?, error: Error?) in

                //エラー処理
                if error != nil {
                    print("Encountered error: \(error!)")
                }

                //データ習得
                if deviceMotion != nil {
                    self.attitude_pitch = "\(deviceMotion!.attitude.pitch)"
                    self.attitude_roll = "\(deviceMotion!.attitude.roll)"
                    self.attitude_yaw = "\(deviceMotion!.attitude.yaw)"
                    
                    self.gravity_x = "\(deviceMotion!.gravity.x)"
                    self.gravity_y = "\(deviceMotion!.gravity.y)"
                    self.gravity_z = "\(deviceMotion!.gravity.z)"
                    
                    self.rotationRate_x = "\(deviceMotion!.rotationRate.x)"
                    self.rotationRate_y = "\(deviceMotion!.rotationRate.y)"
                    self.rotationRate_z = "\(deviceMotion!.rotationRate.z)"
                    
                    self.userAcceleration_x = "\(deviceMotion!.userAcceleration.x)"
                    self.userAcceleration_y = "\(deviceMotion!.userAcceleration.y)"
                    self.userAcceleration_z = "\(deviceMotion!.userAcceleration.z)"
                }

                //データを送る処理
                if WCSession.default.isReachable {

                    let date = Date()

                    self.applicationDict = [
                        "date": String(describing: date),
                        "attitude_pitch": self.attitude_pitch,
                        "attitude_roll": self.attitude_roll,
                        "attitude_yaw": self.attitude_yaw,
                        "gravity_x": self.gravity_x,
                        "gravity_y": self.gravity_y,
                        "gravity_z": self.gravity_z,
                        "rotationRate_x": self.rotationRate_x,
                        "rotationRate_y": self.rotationRate_y,
                        "rotationRate_z": self.rotationRate_z,
                        "userAcceleration_x": self.userAcceleration_x,
                        "userAcceleration_y": self.userAcceleration_y,
                        "userAcceleration_z": self.userAcceleration_z
                    ]
                    sleep(UInt32(0.5))
                    WCSession.default.sendMessage(self.applicationDict, replyHandler: {(reply) -> Void in
                        print(reply)
                    }){(error) -> Void in
                        print(error)
                    }
                }
            }
        }
    }

    @available(watchOS 2.2, *)
    //エラー処理
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidComplete")
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
    }
}
