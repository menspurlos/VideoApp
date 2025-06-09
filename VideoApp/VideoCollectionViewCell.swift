//
//  CollectionViewCell.swift
//  VideoApp
//
//  Created by Dmitry Grishkin on 29.05.2025.
//

import UIKit
import AVFoundation
import AVKit
import MediaPlayer

class VideoCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: VideoCollectionViewCell.self)
    
    private var timeObserver: Any?
    private var playerItemStatusObservation: NSKeyValueObservation?
    private var player = AVPlayer()
    private var playerItem: AVPlayerItem?
    var observer: NSObjectProtocol?
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 36, weight: .bold)
        label.numberOfLines = 0
        label.textColor = .red
        label.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(mute))
        label.addGestureRecognizer(tapGesture)
        return label
    }()
    
    private let videoContainer = UIView()
    
    private lazy var scrubSlider: UISlider = {
        let scrubSlider = UISlider()
        scrubSlider.minimumValue = 0
        scrubSlider.maximumValue = 0
        scrubSlider.isContinuous = true
        scrubSlider.addTarget(self, action: #selector(scrubSliderValueChanged(_:)), for: .valueChanged)
        scrubSlider.addTarget(self, action: #selector(sliderTouchDown(_:)), for: .touchDown)
        scrubSlider.addTarget(self, action: #selector(sliderTouchUp(_:)), for: [.touchUpInside, .touchUpOutside])
        return scrubSlider
    }()
    
    private let timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.textAlignment = .center
        timeLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        timeLabel.textColor = .white
        timeLabel.font = UIFont.systemFont(ofSize: 16)
        timeLabel.layer.cornerRadius = 6
        timeLabel.clipsToBounds = true
        timeLabel.isHidden = true
        return timeLabel
    }()
    
    private let controlsContainer: UIView = {
        let view = UIView()
        //        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return view
    }()
    
    private var videoPlayer = VideoPlayer()
    
    lazy var pauseButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "pause"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handlePauseButtton), for: .touchUpInside)
        return button
    }()
    
    lazy var volumeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "lightbulb.max"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(mute), for: .touchUpInside)
        return button
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .green
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    
    func commonInit() {
        
        contentView.addSubview(videoContainer)
        videoContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        configurePlayer()
        
        controlsContainer.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(150)
        }
        
        contentView.addSubview(controlsContainer)
        controlsContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        controlsContainer.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        controlsContainer.addSubview(pauseButton)
        pauseButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        controlsContainer.addSubview(volumeButton)
        volumeButton.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(250)
        }
        
        controlsContainer.addSubview(scrubSlider)
        scrubSlider.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(30)
            make.directionalHorizontalEdges.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(60)
        }
    }

    func configurePlayer() {
        player.isMuted = true
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspect
        playerLayer.frame = contentView.bounds
        videoContainer.layer.sublayers?.removeAll()
        videoContainer.layer.addSublayer(playerLayer)
    }
    
    func configure(with viewModel: VideoViewModel) {
        print("#debugs configure \(String(describing: viewModel.title))")

        activityIndicator.startAnimating()
        
        contentView.backgroundColor = UIColor.black
        
        if let url = URL(string: viewModel.url) {
            let item = AVPlayerItem(url: url)
            player.replaceCurrentItem(with: item)
            playerItem = item
            playerItem?.addObserver(self, forKeyPath: "duration", options: [.new, .initial], context: nil)
            
            playerItemStatusObservation = playerItem?.observe(\.status, options: [.new]) { [weak self] item, _ in
                guard let self = self else { return }
                if item.status == .readyToPlay {
                    // Лодер вырубать
                }
            }
        }
        
        label.text = viewModel.title
        
    }
    
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        // не добавлен наблюдатель
        if keyPath == "currentItem.loadedTimeRanges" {
            activityIndicator.stopAnimating()
        }
        if keyPath == "duration", let duration = playerItem?.duration, duration.isValid && !duration.isIndefinite, duration.seconds > 0 {
            scrubSlider.maximumValue = Float(duration.seconds)
        }
//        if keyPath == "duration" {
//            if let duration = playerItem?.duration, duration.isValid && !duration.isIndefinite {
//                scrubSlider.maximumValue = Float(duration.seconds)
//            }
//        }
    }
    
    func startPlayback() {
        guard !player.isPlaying else { return }
        print("#debugs play \(String(describing: label.text))")
        player.play()
//        videoPlayer.play()
    }
    
    func stopPlayback() {
        guard player.isPlaying else { return }
        print("#debugs stop \(String(describing: label.text))")
//        videoPlayer.stop()
        player.pause()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stopPlayback()
        scrubSlider.value = 0
        removePeriodicTimeObserver()
        playerItemStatusObservation = nil
        playerItem?.removeObserver(self, forKeyPath: "duration")
        //        activityIndicator.startAnimating()
        print("#debugs prepare \(String(describing: label.text))/n ")
        //        contentView.subviews.forEach { $0.removeFromSuperview() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc
    private func handlePauseButtton() {
        stopPlayback()
    }
    
    @objc private func sliderTouchDown(_ sender: UISlider) {
        timeLabel.isHidden = false
        updateLabelTime(for: sender.value)
        removePeriodicTimeObserver()
//        startPlayback()
    }
    
    @objc private func scrubSliderValueChanged(_ sender: UISlider) {
        print(sender.value)
        guard let playerItem = playerItem, playerItem.status == .readyToPlay else {
            print("Перемотка недоступна — видео не готово")
            return
        }
        updateLabelTime(for: sender.value)
        let seekTime = CMTime(seconds: Double(sender.value), preferredTimescale: 600)
        player.seek(to: seekTime)
    }
    
    @objc private func sliderTouchUp(_ sender: UISlider) {
        timeLabel.isHidden = true
        addPeriodicTimeObserver()
//        stopPlayback()
    }
    
    @objc private func mute() {
        player.isMuted.toggle()
        print("Текущая громкость: \(player.volume)")
    }
    
    private func updateLabelTime(for value: Float) {
        let currentTime = value
        let totalTime = scrubSlider.maximumValue
        timeLabel.text = "\(formatTime(currentTime)) / \(formatTime(totalTime))"
    }
    
    private func formatTime(_ seconds: Float) -> String {
        let totalSeconds = Int(max(0, seconds))
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    // MARK: - Обновление слайдера по таймеру
    
    func addPeriodicTimeObserver() {
        guard timeObserver == nil else { return }
        let interval = CMTime(seconds: 0.5, preferredTimescale: 600)
        timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self] time in
            guard let self = self else { return }
            let seconds = CMTimeGetSeconds(time)
            self.scrubSlider.value = Float(seconds)
        }
    }
    
    func removePeriodicTimeObserver() {
        if let timeObserver = timeObserver {
            player.removeTimeObserver(timeObserver)
            self.timeObserver = nil
        }
    }
    
    deinit {
        removePeriodicTimeObserver()
        playerItem?.removeObserver(self, forKeyPath: "duration")
    }
}

