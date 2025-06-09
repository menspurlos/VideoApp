//
//  VideoPlayer.swift
//  VideoApp
//
//  Created by Dmitry Grishkin on 03.06.2025.
//

import UIKit
import AVFoundation

extension AVPlayer {
    var isPlaying: Bool {
        rate > 0 && error == nil
    }
}

final class VideoPlayer: UIView {
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer!
    private var currentURL: URL?

    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        playerLayer = self.layer as? AVPlayerLayer
        playerLayer.videoGravity = .resizeAspect
    }

    func configure(url: URL) {
        guard currentURL != url else { return }
        currentURL = url

        /// возможно, playerItem тоже бы не создавать каждый раз
        let playerItem = AVPlayerItem(url: url)
        if let player {
            player.replaceCurrentItem(with: playerItem)
        } else {
            player = AVPlayer(playerItem: playerItem)
            playerLayer.player = player
        }
    }

    func play() {
        guard let player, !player.isPlaying else { return }
        player.play()
    }

    func stop() {
        guard let player, player.isPlaying else { return }
        player.pause()
        player.seek(to: .zero)
    }

    deinit {
        print("VideoPlayer deinitialized")
        player?.pause()
        player = nil
        playerLayer.player = nil
    }
}
