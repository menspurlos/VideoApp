//
//  CollectionViewCell.swift
//  VideoApp
//
//  Created by Dmitry Grishkin on 29.05.2025.
//

import UIKit
import AVFoundation

class VideoCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: VideoCollectionViewCell.self)
    
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 36, weight: .bold)
        label.numberOfLines = 0
        label.textColor = .red
        return label
    }()
    
    private let videoContainer = UIView()

    func configure(with viewModel: VideoViewModel) {
        
        contentView.addSubview(videoContainer)
        videoContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        label.text = viewModel.title
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        contentView.backgroundColor = viewModel.color
        
        if let url = URL(string: viewModel.url) {
            player = AVPlayer(url: url)
            
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.videoGravity = .resizeAspectFill
            playerLayer?.frame = contentView.bounds
            if let layer = playerLayer {
                videoContainer.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
                videoContainer.layer.addSublayer(layer)
            }
            player?.play()
        }
    }
    
    func startPlayback() {
        guard let player, !player.isPlaying else { return }
        print("play \(String(describing: label.text))")
        player.play()
    }

    func stopPlayback() {
        print("stop \(String(describing: label.text))")
        player?.pause()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stopPlayback()
        player = nil
        playerLayer = nil
        contentView.subviews.forEach { $0.removeFromSuperview() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension AVPlayer {
    var isPlaying: Bool {
        rate > 0 && error == nil
    }
}
