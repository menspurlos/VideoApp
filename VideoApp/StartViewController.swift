//
//  StartViewController.swift
//  VideoApp
//
//  Created by Дима Гришкин on 22.05.2025.
//

import UIKit
import SnapKit

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
    
    private var viewModel: [VideoViewModel] = [
        .init(title: "1", url: "", subtitle: "", color: .red),
        .init(title: "2", url: "", subtitle: "", color: .green),
        .init(title: "3", url: "", subtitle: "", color: .blue),
        .init(title: "4", url: "", subtitle: "", color: .brown),
        .init(title: "5", url: "", subtitle: "", color: .cyan),
        .init(title: "6", url: "", subtitle: "", color: .magenta),
        .init(title: "7", url: "", subtitle: "", color: .gray),
    ]
    
    private var layout: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = UIScreen.main.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout
    }
    
    private lazy var collection: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.delegate = self
        collection.isPagingEnabled = false
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlArray: [String] = ["https://mattermost.dns-shop.ru/files/599x16d3wb837xztc67jsn3zec/public?h=21gxzHQuudyIsZa-Tnu_IpXxdLU5uW36FxaooeT9MAg",
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
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let cellHeight = scrollView.bounds.height
        let currentOffset = scrollView.contentOffset.y
        let currentIndex = Int(currentOffset / cellHeight)
        
        // Определяем, куда двигается пользователь
        var proposedIndex = currentIndex
        
        if velocity.y > 0 {
            // Скроллит вниз — к следующей ячейке
            proposedIndex = currentIndex + 1
        } else if velocity.y < 0 {
            // Скроллит вверх — к предыдущей ячейке
            proposedIndex = currentIndex - 1
        } else {
            // Если нет скорости — определяем по положению
            let offsetY = currentOffset.truncatingRemainder(dividingBy: cellHeight)
            if offsetY >= cellHeight / 2 {
                proposedIndex += 1
            }
        }
        
        // Ограничиваем индекс диапазоном
        let numberOfItems = viewModel.count // замени на реальное количество ячеек
        let newIndex = min(max(proposedIndex, 0), numberOfItems - 1)
        
        targetContentOffset.pointee = CGPoint(x: 0, y: CGFloat(newIndex) * cellHeight)
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
}

