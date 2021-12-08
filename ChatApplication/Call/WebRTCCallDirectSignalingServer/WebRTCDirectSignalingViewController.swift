//
//  WebRTCViewController.swift
//  ChatApplication
//
//  Created by Hamed Hosseini on 7/3/21.
//


import Foundation
import UIKit
import FanapPodChatSDK
import SwiftUI
import WebRTC

struct WebRTCDirectSignalingView:UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context)-> WebRTCDirectSignalingViewController {
        let vc = UIStoryboard(name: "WebRTCDirectSignaling", bundle: nil).instantiateInitialViewController() as! WebRTCDirectSignalingViewController
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

class WebRTCDirectSignalingViewController: UIViewController, WebRTCClientDelegate{
    
    
    @IBOutlet weak var localView: UIView!
    var webRTCClient:WebRTCClientNewDirectServer?
    private var localRenderer:RTCVideoRenderer?
    
    func getConfig(isClientA:Bool = false)->WebRTCConfigOld {
        return WebRTCConfigOld(peerName:"KuretoAdmin1",
                                  iceServers: ["stun:46.32.6.188:3478","turn:46.32.6.188:3478"],
                                  topicVideoSend: isClientA ? "Vi-hossein" : "Vi-masoud",
                                  topicVideoReceive: isClientA ? "Vi-masoud" : "Vi-hossein",
                                  topicAudioSend: isClientA ? "Au-hossein" : "Au-masoud",
                                  topicAudioReceive: isClientA ? "Au-masoud" : "Au-hossein",
                                  brokerAddress:"10.56.16.53:9093",
                                  dataChannel: false,
                                  customFrameCapturer: false,
                                  userName: "mkhorrami",
                                  password: "mkh_123456",
                                  videoConfig: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        webRTCClient = WebRTCClientNewDirectServer(config: getConfig(isClientA: false), delegate: self)
//        #if arch(arm64)
//            // Using metal (arm64 only)
//            let localRenderer = RTCMTLVideoView(frame: self.localView?.frame ?? CGRect.zero)
//            let remoteRenderer = RTCMTLVideoView(frame: self.view.frame)
//            localRenderer.videoContentMode = .scaleAspectFill
//            remoteRenderer.videoContentMode = .scaleAspectFill
//        #else
//            // Using OpenGLES for the rest
//            let localRenderer = RTCEAGLVideoView(frame: self.localView?.frame ?? CGRect.zero)
//            let remoteRenderer = RTCEAGLVideoView(frame: self.view.frame)
//        #endif
//        
//        //setup local camera view
//        localView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)//mirror view to show correct posiotion on view
//        self.localRenderer = localRenderer
//        self.webRTCClient?.startCaptureLocalVideo(renderer: localRenderer)
//        localRenderer.frame.origin = .zero //to fit to local view position
//        localView.addSubview(localRenderer)
//        localView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(switchCamera)))
//
//        //setup remote camera view
//        self.webRTCClient?.renderRemoteVideo(remoteRenderer)
//        remoteRenderer.frame.origin = .zero //to fit to local view position
//        self.view.addSubview(remoteRenderer)
//        view.sendSubviewToBack(remoteRenderer)
    }
    
    @objc func switchCamera(){
        guard let renderer = localRenderer else {return}
        webRTCClient?.switchCameraPosition(renderer: renderer)
    }
    
    //never re run app when call is open must tap on close
    @IBAction func stopTaped(_ senderf:UIButton){
        Chat.sharedInstance.closeSignalingServerCall(peerName: getConfig(isClientA: false).peerName) //free call for token user
    }
    
    @IBAction func offerTaped(_ senderf:UIButton){
        webRTCClient?.getLocalSDPWithOffer(isSend:true,onSuccess: { sdp in
            self.webRTCClient?.sendOfferToPeer(sdp , isSend: true)
        })
        
        webRTCClient?.getLocalSDPWithOffer(isSend:false,onSuccess: { sdp in
            self.webRTCClient?.sendOfferToPeer(sdp , isSend: false)
        })
    }
    
    @IBAction func answerTaped(_ senderf:UIButton){
        webRTCClient?.getAnswerSDP(onSuccess: { sdp in
            self.webRTCClient?.sendAnswerToPeer(sdp)
        })
    }
    
    func didIceConnectionStateChanged(iceConnectionState: RTCIceConnectionState) {
        
    }
    
    func didReceiveData(data: Data) {
        
    }
    
    func didReceiveMessage(message: String) {
        
    }
    
    func didConnectWebRTC() {
        
    }
    
    func didDisconnectWebRTC() {
        
    }
    
}