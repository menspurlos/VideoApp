////
////  VideoPlayerControlsView.swift
////  VideoApp
////
////  Created by Dmitry Grishkin on 17.06.2025.
////
//
//import UIKit
//
//class videoPlayerControlsView: VideoPlayerControlsView {
//    
//    private lazy var scrubSlider: UISlider = {
//        let scrubSlider = UISlider()
//        scrubSlider.minimumValue = 0
//        scrubSlider.maximumValue = 0
//        scrubSlider.isContinuous = true
//        scrubSlider.maximumTrackTintColor = UIColor(white: 1, alpha: 0.2)
//        scrubSlider.minimumTrackTintColor = .white
//        scrubSlider.thumbTintColor = .white
//        //        scrubSlider.applyCustomStyle(trackColor: .white, thumbColor: .white, trackHeight: 1, thumbSize: 2)
//        scrubSlider.addTarget(self, action: #selector(scrubSliderValueChanged(_:)), for: .valueChanged)
//        scrubSlider.addTarget(self, action: #selector(sliderTouchDown(_:)), for: .touchDown)
//        scrubSlider.addTarget(self, action: #selector(sliderTouchUp(_:)), for: [.touchUpInside, .touchUpOutside])
//        return scrubSlider
//    }()
//    
//    private let timeLabel: UILabel = {
//        let timeLabel = UILabel()
//        timeLabel.textAlignment = .center
//        timeLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
//        timeLabel.textColor = .white
//        timeLabel.font = UIFont.systemFont(ofSize: 16)
//        timeLabel.layer.cornerRadius = 6
//        timeLabel.clipsToBounds = true
//        timeLabel.isHidden = true
//        return timeLabel
//    }()
//    
//    lazy var playPauseButton: UIButton = {
//        let button = UIButton(type: .custom)
//        button.setImage(UIImage(named: "buttonPause"), for: .normal)
//        button.imageView?.contentMode = .scaleAspectFit
//        button.contentHorizontalAlignment = .fill
//        button.contentVerticalAlignment = .fill
//        button.tintColor = .white
//        button.addTarget(self, action: #selector(handlePauseButtton), for: .touchUpInside)
//        return button
//    }()
//    
//    private lazy var sliderStack: UIStackView = {
//        let stackView = UIStackView(arrangedSubviews: [playPauseButton, scrubSlider, volumeButton])
//        stackView.axis = .horizontal
//        return stackView
//    }()
//    
//    lazy var pauseButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(systemName: "play"), for: .normal)
//        button.isHidden = true
//        button.imageView?.contentMode = .scaleAspectFit
//        button.contentHorizontalAlignment = .fill
//        button.contentVerticalAlignment = .fill
//        button.tintColor = .white
//        button.addTarget(self, action: #selector(handlePauseButtton), for: .touchUpInside)
//        return button
//    }()
//    
//    lazy var volumeButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(named: "buttonVolumeOn"), for: .normal)
//        button.tintColor = .white
//        button.addTarget(self, action: #selector(mute), for: .touchUpInside)
//        return button
//    }()
//}
