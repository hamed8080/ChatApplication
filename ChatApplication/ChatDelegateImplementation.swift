//
//  ChatDelegateImplementation.swift
//  ChatImplementation
//
//  Created by Hamed Hosseini on 2/6/21.
//

import Foundation
import FanapPodChatSDK
import UIKit

enum ConnectionStatus:Int{
    case Connecting   = 0
    case Disconnected = 1
    case Reconnecting = 2
    case UnAuthorized = 3
    case CONNECTED    = 4
}

class ChatDelegateImplementation: ChatDelegates {
           
	private (set) static var sharedInstance = ChatDelegateImplementation()
    
    func createChatObject(){
        if let config = Config.getConfig(.Sandbox){
            let token = UserDefaults.standard.string(forKey: "token")
            print("token is: \(token ?? "")")
            Chat.sharedInstance.createChatObject(config: .init(socketAddress: config.socketAddresss,
                                                               serverName: config.serverName,
                                                               token: token ?? config.debugToken,
                                                               ssoHost: config.ssoHost,
                                                               platformHost: config.platformHost,
                                                               fileServer: config.fileServer,
                                                               enableCache: true,
                                                               msgTTL: 800000,//for integeration server need to be long time
                                                               reconnectOnClose: true,
                                                               isDebuggingLogEnabled: true,
                                                               enableNotificationLogObserver: true
                                                               
                                                               
            ))
            Chat.sharedInstance.delegate = self
        }
    }
	
	func chatConnect() {
        print("🟡 chat connected")
        AppState.shared.connectionStatus = .Connecting
	}
	
	func chatDisconnect() {
        print("🔴 chat Disconnect")
        AppState.shared.connectionStatus = .Disconnected
	}
	
	func chatReconnect() {
		print("🔄 chat Reconnect")
        AppState.shared.connectionStatus = .Reconnecting
	}
	
	func chatReady(withUserInfo: User) {
        print("🟢 chat ready Called\(withUserInfo)")
        AppState.shared.connectionStatus = .CONNECTED
	}
	
	func chatState(state: AsyncStateType) {
		print("chat state changed: \(state)")
	}
	
	func chatError(errorCode: Int, errorMessage: String, errorResult: Any?) {
		if errorCode == 21  || errorCode == 401{
//            let st = UIStoryboard(name: "Main", bundle: nil)
//            let vc = st.instantiateViewController(identifier: "UpdateTokenController")
//            guard let rootVC = SceneDelegate.getRootViewController() else {return}
//            rootVC.presentedViewController?.dismiss(animated: true)
//            rootVC.present(vc, animated: true)
		}
	}
	
	func botEvents(model: BotEventModel) {
		print(model)
	}
	
	func contactEvents(model: ContactEventModel) {
		print(model)
	}
	
	func fileUploadEvents(model: FileUploadEventModel) {
		print(model)
	}
	
	func messageEvents(model: MessageEventModel) {
		print(model)
	}
	
	func systemEvents(model: SystemEventModel) {
		print(model)
	}
	
	func threadEvents(model: ThreadEventModel) {
		print(model)
	}
	
	func userEvents(model: UserEventModel) {
		print(model)
	}
}
