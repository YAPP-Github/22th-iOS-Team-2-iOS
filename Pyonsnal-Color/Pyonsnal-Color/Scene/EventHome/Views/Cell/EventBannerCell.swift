//
//  EventBannerCell.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/06/10.
//

import UIKit
import SnapKit

protocol EventBannerCellDelegate: AnyObject {
    func didTapEventBannerCell(with imageURL: String, store: ConvenienceStore)
}

final class EventBannerCell: UICollectionViewCell {
    
    enum SectionType: Hashable {
        case event
    }
    
    enum ItemType: Hashable {
        case event(banner: EventBannerEntity)
    }
    
    // MARK: - Constants
    enum Constants {
        enum Size {
            static let cellCornerRadius: CGFloat = 16
            static let countLabelCornerRadius: CGFloat = 12
        }
        
        static let timeSecond: Double = 5.0
        static let initialIndex: Int = 0
    }
    
    weak var delegate: EventBannerCellDelegate?
    
    // MARK: - Private property
    typealias DataSource = UICollectionViewDiffableDataSource<SectionType, ItemType>
    private var dataSource: DataSource?
    private let viewHolder: ViewHolder = .init()
    private var timer: Timer?
    private var currentIndex = 0 {
        didSet {
            updatePageCountLabel(with: currentIndex)
        }
    }
    private var eventBannerUrls: [EventBannerEntity] = []
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        viewHolder.place(in: contentView)
        viewHolder.configureConstraints(for: contentView)
        configureUI()
        configureDatasource()
        configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.stopTimer()
    }
    
    func update(_ eventBannerUrls: [EventBannerEntity]) {
        self.setTimer()
        self.eventBannerUrls = eventBannerUrls
        
        makeSnapshot(with: eventBannerUrls)
    }
    
    // MARK: - Private Method
    private func configureUI() {
        makeRounded(with: Constants.Size.cellCornerRadius)
        updatePageCountLabel(with: currentIndex)
        viewHolder.pageCountContainerView.makeRounded(with: Constants.Size.countLabelCornerRadius)
    }
    
    private func configureDatasource() {
        dataSource = DataSource(collectionView: viewHolder.collectionView) { collectionView, indexPath, item -> UICollectionViewCell? in
            switch item {
            case .event(let _):
                let cell: EventBannerItemCell = collectionView.dequeueReusableCell(for: indexPath)
                let eventBanner = self.eventBannerUrls[indexPath.item]
                cell.update(with: eventBanner.thumbnailImageURL)
                cell.setImageContentMode(with: eventBanner.storeType)
                self.updatePageCountLabel(with: self.currentIndex)
                cell.delegate = self
                return cell
            }
        }
    }
    
    private func configureCollectionView() {
        viewHolder.collectionView.delegate = self
        registerCollectionViewCells()
    }
    
    private func registerCollectionViewCells() {
        viewHolder.collectionView.register(EventBannerItemCell.self)
    }
    
    private func makeSnapshot(with banners: [EventBannerEntity]) {
        var snapshot = NSDiffableDataSourceSnapshot<SectionType, ItemType>()

        if !eventBannerUrls.isEmpty {
            snapshot.appendSections([.event])
            let eventUrls = banners.map { eventUrl in
                return ItemType.event(banner: eventUrl)
            }
            snapshot.appendItems(eventUrls, toSection: .event)
        }
        
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
}

//MARK: - Timer
extension EventBannerCell {
    
    private func setTimer() {
        if timer != nil { stopTimer() }
        DispatchQueue.main.async { [weak self] in
            self?.timer = Timer.scheduledTimer(withTimeInterval: Constants.timeSecond,
                                         repeats: true) { [weak self] _ in
                self?.startAutoScroll()
            }
        }
    }
    
    private func startAutoScroll() {
        let updatedIndex = currentIndex + 1
        var indexPath: IndexPath
        var animated: Bool = true
        if updatedIndex < eventBannerUrls.count {
            indexPath = IndexPath(item: updatedIndex, section: 0)
        } else {
            indexPath = IndexPath(item: Constants.initialIndex, section: 0)
            animated = false
        }
        
        currentIndex = indexPath.item
        viewHolder.collectionView.scrollToItem(at: indexPath,
                                               at: .right,
                                               animated: animated)

    }
    
    private func updatePageCountLabel(with index: Int) {
        guard !eventBannerUrls.isEmpty,
              index < eventBannerUrls.count else { return }
        let updatedIndex = currentIndex + 1
        setPageCountLabelText(with: updatedIndex)
    }
    
    private func setPageCountLabelText(with updatedIndex: Int) {
        let attributedText = NSMutableAttributedString()
        attributedText.appendAttributes(
            string: "\(updatedIndex)",
            font: .body4r,
            color: .white
        )
        attributedText.appendAttributes(
            string: "/\(eventBannerUrls.count)",
            font: .body4r,
            color: .gray300
        )
        viewHolder.pageCountLabel.attributedText = attributedText
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
}

//MARK: - UICollectionViewDelegate
extension EventBannerCell: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopTimer()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentIndex = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        setTimer()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = eventBannerUrls[indexPath.row]
        delegate?.didTapEventBannerCell(with: model.imageURL ?? "", store: model.storeType)
    }
}

//MARK: - EventBannerItemCellDelegate
extension EventBannerCell: EventBannerItemCellDelegate {
    func didTapEventBannerCell(with imageURL: String, store: ConvenienceStore) {
        delegate?.didTapEventBannerCell(with: imageURL, store: store)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension EventBannerCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        return CGSize(width: width, height: height)
    }
}

extension EventBannerCell {
    class ViewHolder: ViewHolderable {
        let collectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            let collectionView = UICollectionView(frame: .zero,
                                                  collectionViewLayout: layout)
            collectionView.isPagingEnabled = true
            collectionView.showsHorizontalScrollIndicator = false
            return collectionView
        }()
        
        let pageCountContainerView: UIView = {
            let view = UIView()
            view.backgroundColor = .black
            view.layer.opacity = 0.5
            return view
        }()
        
        let pageCountLabel: UILabel = {
            let label = UILabel()
            return label
        }()
        
        func place(in view: UIView) {
            view.addSubview(collectionView)
            view.addSubview(pageCountContainerView)
            pageCountContainerView.addSubview(pageCountLabel)
        }
        
        func configureConstraints(for view: UIView) {
            collectionView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            
            pageCountContainerView.snp.makeConstraints {
                $0.top.equalToSuperview().offset(12)
                $0.trailing.equalToSuperview().inset(12)
            }
            
            pageCountLabel.snp.makeConstraints {
                $0.top.equalToSuperview().offset(4)
                $0.bottom.equalToSuperview().inset(4)
                $0.leading.equalToSuperview().offset(10)
                $0.trailing.equalToSuperview().inset(10)
            }
        }

    }
}
