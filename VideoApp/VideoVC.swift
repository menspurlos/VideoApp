//
//  VideoVC.swift
//  VideoApp
//
//  Created by Dmitry Grishkin on 27.05.2025.
//

import UIKit
import AVFoundation

//class VideoVC: UIViewController {
//    private var player : AVPlayer? = nil
//    let videoURL = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
//
//    override func viewDidLoad() {
//        guard let url = 
//        super.viewDidLoad()
//    }
//    
//    private func setVideoPlayer() {
//        guard let url = URL(string: videoURL) else { return }
//        
//        if self.player == nil {
//            self.player = AVPlayer(url: url)
//            self.playerLayer = AVPlayerLayer(player: self.player)
//            self.playerLayer?.videoGravity = .resizeAspectFill
//            self.playerLayer?.frame = self.videoPlayer.bounds
//            self.playerLayer?.addSublayer(self.viewControll.layer)
//            if let playerLayer = self.playerLayer {
//                self.view.layer.addSublayer(playerLayer)
//            }
//            self.player?.play()
//        }
//    }
//}
