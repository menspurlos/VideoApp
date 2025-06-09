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
    private var cancellables = Set<AnyCancellable>()
    private var viewModel: [VideoViewModel] = [
        .init(title: "1", url: "", subtitle: "", color: .red),
        .init(title: "2", url: "", subtitle: "", color: .green),
        .init(title: "3", url: "", subtitle: "", color: .blue),
        .init(title: "4", url: "", subtitle: "", color: .brown),
        .init(title: "5", url: "", subtitle: "", color: .cyan),
        .init(title: "6", url: "", subtitle: "", color: .magenta),
        .init(title: "7", url: "", subtitle: "", color: .gray),
        .init(title: "8", url: "", subtitle: "", color: .yellow),
    ]

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
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCollectionViewCell.reuseIdentifier, for: indexPath) as? VideoCollectionViewCell
        else { return UICollectionViewCell() }
        cell.configure(with: item)
        
        return cell
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "outputVolume" {
            let volume = AVAudioSession.sharedInstance().outputVolume
            print("Громкость изменена: \(volume)")
            // Здесь можно выполнить действие при изменении громкости
        }
    }
    
//    @objc func volumeChanged() {
//        let volume = AVAudioSession.sharedInstance().outputVolume
//        print("Громкость изменена через Notification: $volume)")
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        podpiskaValume()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        otmenaPodpiski()
    }

    
    func otmenaPodpiski() {
        print("отмена подписка valume")
        AVAudioSession.sharedInstance().removeObserver(self, forKeyPath: "outputVolume")
    }
    
    func podpiskaValume() {
        print("подписка valume")

        // Подписываемся на изменения громкости
        AVAudioSession.sharedInstance().addObserver(
            self,
            forKeyPath: "outputVolume",
            options: [.new, .initial],
            context: nil
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        



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
        
        let urlArray: [String] = ["https://mattermost.dns-shop.ru/files/ptjjiweotiyhdp9e3pewhjp9cc/public?h=3_6mWUmNcZcbvjK8BI6dFOih48CWx7v5YP9C5G--UMY",
                                  "https://tcpzzdh01k.a.trbcdn.net/cdn/habopiha52/_video_/67f89cc80e47cf27f8a0b9c2/,67f89cc80e47cf27f8a0b9c2,67f89cf90e47cf27f8a0b9ce,.mp4.urlset/playlist.m3u8",
                                   "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8",
                                   "https://tcpzzdh01k.a.trbcdn.net/cdn/habopiha52/opinions/145ae28d-19d4-420d-a953-4f97195f2507/617816d8-7e68-4304-8f75-9be9dbe4ae92.mp4",
                                   "https://flipfit-cdn.akamaized.net/flip_hls/661f570aab9d840019942b80-473e0b/video_h1.m3u8",
                                   "https://flipfit-cdn.akamaized.net/flip_hls/663e5a1542cd740019b97dfa-ccf0e6/video_h1.m3u8?ref=developerinsider.co",
                                   "https://flipfit-cdn.akamaized.net/flip_hls/662aae7a42cd740019b91dec-3e114f/video_h1.m3u8?ref=developerinsider.co",
                                   "https://mattermost.dns-shop.ru/files/599x16d3wb837xztc67jsn3zec/public?h=21gxzHQuudyIsZa-Tnu_IpXxdLU5uW36FxaooeT9MAg",
                                   "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
                                   "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
                                   "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
                                   "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
                                   "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
                                   "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
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
                                   "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
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
    }
}

