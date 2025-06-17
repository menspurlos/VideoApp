//
//  StartViewController.swift
//  VideoApp
//
//  Created by Дима Гришкин on 22.05.2025.
//

import UIKit
import SnapKit
import AVFoundation
import Combine

private enum Section: CaseIterable {
    case videos
}

struct VideoViewModel: Hashable {
    let title: String
    var url: String
    let subtitle: String
    let color: UIColor
}

class StartViewController: UIViewController, UIScrollViewDelegate, UICollectionViewDelegate {
    private let playerManager = PlayerManager.shared
    
    private var isObservingVolume = false
    
    private var viewModel: [VideoViewModel] = [
        .init(title: "1", url: "", subtitle: "", color: .red),
        .init(title: "2", url: "", subtitle: "", color: .green),
        .init(title: "3", url: "", subtitle: "", color: .blue),
        .init(title: "4", url: "", subtitle: "", color: .brown),
        .init(title: "5", url: "", subtitle: "", color: .cyan),
        .init(title: "6", url: "", subtitle: "", color: .magenta),
        .init(title: "7", url: "", subtitle: "", color: .gray),
        .init(title: "8", url: "", subtitle: "", color: .yellow),
        .init(title: "9", url: "", subtitle: "", color: .yellow),
        .init(title: "10", url: "", subtitle: "", color: .yellow),
        .init(title: "11", url: "", subtitle: "", color: .yellow),
        .init(title: "12", url: "", subtitle: "", color: .yellow),
        .init(title: "13", url: "", subtitle: "", color: .yellow),
        .init(title: "14", url: "", subtitle: "", color: .yellow),
    ]
    
//    private var isMuted = false

    private  lazy  var layout =  UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
        let itemSize =  NSCollectionLayoutSize (widthDimension: .fractionalWidth( 1.0 ), heightDimension: .fractionalHeight( 1.0 ))
        let item =  NSCollectionLayoutItem (layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize (widthDimension: .fractionalWidth (1.0), heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, repeatingSubitem: item, count :1)
        group.contentInsets = .init(top: 4 , leading: 5 , bottom: 5 , trailing: 5 )
        let section =  NSCollectionLayoutSection (group: group)
        return section
    }
    
    private lazy var collection: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.contentInsetAdjustmentBehavior = .never
        collection.delegate = self
        collection.isPagingEnabled = true
        collection.showsVerticalScrollIndicator = false
        collection.register(VideoCollectionViewCell.self, forCellWithReuseIdentifier: VideoCollectionViewCell.reuseIdentifier)
        collection.isScrollEnabled = true
        
        return collection
    }()
    
    private lazy var dataSource = UICollectionViewDiffableDataSource<Section, VideoViewModel>(collectionView: collection) { [weak self] collectionView, indexPath, item in
        
        guard let self, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCollectionViewCell.reuseIdentifier, for: indexPath) as? VideoCollectionViewCell
        else { return UICollectionViewCell() }
        cell.configure(with: item, playerManager: self.playerManager)
        cell.delegate = self
        
        return cell
    }
    
//    private func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCollectionViewCell.reuseIdentifier, for: indexPath) as! VideoCollectionViewCell
//        
//        let item = viewModel[indexPath.item]
//        cell.updateMuteState(isMuted) // <-- передаём isMuted
//        
//        return cell
//    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "outputVolume" {
            let volume = AVAudioSession.sharedInstance().outputVolume
            print("Громкость изменена: \(volume)")
            playerManager.isMuted.send(false)
        }
    }
    
//    @objc func volumeChanged() {
//        let volume = AVAudioSession.sharedInstance().outputVolume
//        print("Громкость изменена через Notification: $volume)")
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        podpiskaValume()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("viewWillDisappear")
        otmenaPodpiski()
    }

    
    func otmenaPodpiski() {
        guard isObservingVolume else { return }

        print("отмена подписка valume")
        AVAudioSession.sharedInstance().removeObserver(self, forKeyPath: "outputVolume")
        isObservingVolume = false
    }
    
    func podpiskaValume() {
        guard !isObservingVolume else { return }
        print("подписка valume")

        // Подписываемся на изменения громкости
        AVAudioSession.sharedInstance().addObserver(
            self,
            forKeyPath: "outputVolume",
            options: [.new],
            context: nil
        )
        isObservingVolume = true
    }
    
    @objc
    func didEnterBackground() {
        print("Приложение вышло в бэкграунд")
        otmenaPodpiski()
        
        if let visibleCells = collection.visibleCells as? [VideoCollectionViewCell] {
            for cell in visibleCells {
                // Выполняем нужное действие
                cell.stopPlayback()
            }
        }
    }
    
    @objc
    func didForeground() {
        print("Приложение вышло из фона")
        podpiskaValume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // когда приложение выходит в бэкграунд
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.willResignActiveNotification, object: nil)
        // когда приложение выходит из под шторки
        NotificationCenter.default.addObserver(self, selector: #selector(self.didForeground), name: UIApplication.didBecomeActiveNotification, object: nil)
        // когда приложение вышло из фона
        NotificationCenter.default.addObserver(self, selector: #selector(didForeground), name: UIApplication.willEnterForegroundNotification, object: nil)


//        
//        // Активируем аудиосессию
//        do {
//            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
//            try AVAudioSession.sharedInstance().setActive(true)
//        } catch {
//            print("Не удалось активировать аудиосессию")
//        }
//        
//        // Настраиваем наблюдение за изменением громкости
//        UIDevice.current.isProximityMonitoringEnabled = true
//        
//        // Используем KVO для отслеживания изменения громкости
//        AVAudioSession.sharedInstance().addObserver(self, forKeyPath: "outputVolume", options: .new, context: nil)
        
        let urlArray: [String] = ["https://tcpzzdh01k.a.trbcdn.net/cdn/habopiha52/stories/2025/06/9/_video_/68464cd60e47cf5a86a80fa9/,68464cd60e47cf5a86a80fa9,68464cdc0e47cf5a86a80fb5,68464cdd0e47cf5a86a80fb7,.mp4.urlset/playlist.m3u8",
                                  "https://tcpzzdh01k.a.trbcdn.net/cdn/habopiha52/_video_/67f89cc80e47cf27f8a0b9c2/,67f89cc80e47cf27f8a0b9c2,67f89cf90e47cf27f8a0b9ce,.mp4.urlset/playlist.m3u8",
                                   "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
                                   "https://tcpzzdh01k.a.trbcdn.net/cdn/habopiha52/opinions/145ae28d-19d4-420d-a953-4f97195f2507/617816d8-7e68-4304-8f75-9be9dbe4ae92.mp4",
                                   "https://flipfit-cdn.akamaized.net/flip_hls/661f570aab9d840019942b80-473e0b/video_h1.m3u8",
                                   "https://flipfit-cdn.akamaized.net/flip_hls/663e5a1542cd740019b97dfa-ccf0e6/video_h1.m3u8?ref=developerinsider.co",
                                   "https://flipfit-cdn.akamaized.net/flip_hls/662aae7a42cd740019b91dec-3e114f/video_h1.m3u8?ref=developerinsider.co",
                                   "https://mattermost.dns-shop.ru/files/599x16d3wb837xztc67jsn3zec/public?h=21gxzHQuudyIsZa-Tnu_IpXxdLU5uW36FxaooeT9MAg",
                                   "https://tcpzzdh01k.a.trbcdn.net/cdn/habopiha52/stories/2025/06/10/_video_/684776d20e47cf5a86a83757/,684776d20e47cf5a86a83757,684776da0e47cf5a86a83763,684776da0e47cf5a86a83764,.mp4.urlset/playlist.m3u8",
                                   "https://tcpzzdh01k.a.trbcdn.net/cdn/habopiha52/stories/2025/06/6/_video_/684272390e47cf5a86a7c7a4/,684272390e47cf5a86a7c7a4,6842723f0e47cf5a86a7c7b9,6842723f0e47cf5a86a7c7b8,.mp4.urlset/playlist.m3u8",
                                   "https://tcpzzdh01k.a.trbcdn.net/cdn/habopiha52/stories/2025/06/9/_video_/684675a50e47cf5a86a814eb/,684675a50e47cf5a86a814eb,684675b40e47cf5a86a814f8,684675b40e47cf5a86a814f7,.mp4.urlset/playlist.m3u8",
                                   "https://tcpzzdh01k.a.trbcdn.net/cdn/habopiha52/stories/2025/06/9/_video_/68464cd60e47cf5a86a80fa9/,68464cd60e47cf5a86a80fa9,68464cdc0e47cf5a86a80fb5,68464cdd0e47cf5a86a80fb7,.mp4.urlset/playlist.m3u8",
                                   "https://tcpzzdh01k.a.trbcdn.net/cdn/habopiha52/stories/2025/06/6/_video_/68426cbc0e47cf5a86a7c70c/,68426cbc0e47cf5a86a7c70c,68426cc10e47cf5a86a7c719,68426cc10e47cf5a86a7c718,.mp4.urlset/playlist.m3u8",
                                   "https://tcpzzdh01k.a.trbcdn.net/cdn/habopiha52/stories/2025/06/5/_video_/6840f3640e47cf5a86a79699/,6840f3640e47cf5a86a79699,6840f36b0e47cf5a86a796a5,6840f36b0e47cf5a86a796a6,.mp4.urlset/playlist.m3u8",
                                   "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
                                   "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
        ]
        
        let urlArray2: [String] = ["https://mattermost.dns-shop.ru/files/ptjjiweotiyhdp9e3pewhjp9cc/public?h=3_6mWUmNcZcbvjK8BI6dFOih48CWx7v5YP9C5G--UMY",
                                   "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
                                   "https://mattermost.dns-shop.ru/files/599x16d3wb837xztc67jsn3zec/public?h=21gxzHQuudyIsZa-Tnu_IpXxdLU5uW36FxaooeT9MAg",
                                   "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
                                   "https://mattermost.dns-shop.ru/files/599x16d3wb837xztc67jsn3zec/public?h=21gxzHQuudyIsZa-Tnu_IpXxdLU5uW36FxaooeT9MAg",
                                   "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
                                   "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
                                   "https://mattermost.dns-shop.ru/files/599x16d3wb837xztc67jsn3zec/public?h=21gxzHQuudyIsZa-Tnu_IpXxdLU5uW36FxaooeT9MAg",
                                   "https://tcpzzdh01k.a.trbcdn.net/cdn/habopiha52/stories/2025/06/9/_video_/684675a50e47cf5a86a814eb/,684675a50e47cf5a86a814eb,684675b40e47cf5a86a814f8,684675b40e47cf5a86a814f7,.mp4.urlset/playlist.m3u8",
                                   "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
                                   "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
                                   "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
                                   "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
                                   "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
                                   "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
                                   "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
        ]
        
        for (index, url) in urlArray.enumerated() where index < viewModel.count {
            viewModel[index].url = url
        }
        
        view.addSubview(collection)
        collection.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
        
        updateDataSource(data: viewModel)
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return false // Запрещаем скролл к верху по тапу на статус-бар
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let collectionView = scrollView as? UICollectionView else { return }
        
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let visibleCenterPoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        for cell in collectionView.visibleCells {
            let cellRect = collectionView.convert(cell.bounds, from: cell)
            let distanceFromCenter = abs(cell.center.y - visibleCenterPoint.y)
            
            if distanceFromCenter < collectionView.bounds.height / 2 {
                // Ячейка видна — запустить видео
                if let videoCell = cell as? VideoCollectionViewCell {
                    videoCell.startPlayback()
                }
            } else {
                // Ячейка ушла больше чем наполовину — остановить
                if let videoCell = cell as? VideoCollectionViewCell {
                    /// тут бы просто что-то сообщить про ячейку, а не решать что надо стопнуть.
                    videoCell.stopPlayback()
                }
            }
        }
    }
    
    func scrollToNextItem() {
        let currentIndex = collection.indexPathsForVisibleItems.first?.row ?? 0
        
        guard currentIndex < viewModel.count - 1 else {
            print("Это последняя ячейка")
            return
        }
        
        let nextIndex = currentIndex + 1
        let nextIndexPath = IndexPath(row: nextIndex, section: 0)
        
        collection.scrollToItem(at: nextIndexPath, at: .centeredVertically, animated: true)
    }
    
    private func updateDataSource(
        data: [VideoViewModel]
    ) {
        var snapshot = NSDiffableDataSourceSnapshot<
            Section,
            VideoViewModel
        >()
        
        snapshot.appendSections([.videos])
        snapshot.appendItems(data, toSection: .videos)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    deinit {
        // Отписываемся
        otmenaPodpiski()
        print("KVO observer удален")
        NotificationCenter.default.removeObserver(self)
    }
}

extension StartViewController: VideoCollectionViewCellDelegate {
    func changeMute() {
        let currentState = playerManager.isMuted.value
        playerManager.isMuted.send(!currentState)
    }
    
    func videoDidFinishPlaying(_ cell: VideoCollectionViewCell) {
        scrollToNextItem()
    }
}

extension UISlider {
    func applyCustomStyle(trackColor: UIColor, thumbColor: UIColor, trackHeight: CGFloat = 6, thumbSize: CGFloat = 24) {
        self.minimumTrackTintColor = trackColor
        self.maximumTrackTintColor = trackColor.withAlphaComponent(0.2)

        if #available(iOS 13.0, *) {
            let minimumTrackImage = createTrackImage(color: trackColor, height: trackHeight)
            let maximumTrackImage = createTrackImage(color: self.maximumTrackTintColor, height: trackHeight)
            self.setMinimumTrackImage(minimumTrackImage, for: .normal)
            self.setMaximumTrackImage(maximumTrackImage, for: .normal)
        }

        let thumbImageNormal = createCircleImage(color: thumbColor, diameter: 2)
        let thumbImageSelected = createCircleImage(color: thumbColor, diameter: 50)

        self.setThumbImage(thumbImageNormal, for: .normal)
        self.setThumbImage(thumbImageSelected, for: .highlighted)
    }
    
    private func createCircleImage(color: UIColor, diameter: CGFloat) -> UIImage {
        let size = CGSize(width: diameter, height: diameter)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIBezierPath(ovalIn: CGRect(origin: .zero, size: size)).fill()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    private func createTrackImage(color: UIColor?, height: CGFloat) -> UIImage {
        let width: CGFloat = 1.0
        let size = CGSize(width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color?.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .tile)
    }
}


