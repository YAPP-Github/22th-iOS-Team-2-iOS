//
//  ProductFilterViewController.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/07/25.
//

import UIKit
import ModernRIBs
import SnapKit

protocol ProductFilterPresentableListener: AnyObject {
    // TODO: 엔티티 변경
    func didTapApplyButton(with selectedItems: [FilterItemEntity], type: FilterType)
    func didSelectSortFilter(item: FilterItemEntity)
    func didTapCloseButton()
}

final class ProductFilterViewController:
    UIViewController,
    ProductFilterPresentable,
    ProductFilterViewControllable {
    
    typealias DataSource = UICollectionViewDiffableDataSource<FilterType, FilterItemEntity>

    // MARK: - Property
    weak var listener: ProductFilterPresentableListener?
    
    private let viewHolder = ViewHolder()
    private var dataSource: DataSource?
    private var filterEntity: FilterEntity
    
    // MARK: - Initializer
    init(filterEntity: FilterEntity) {
        self.filterEntity = filterEntity
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewHolder.place(in: view)
        viewHolder.configureConstraints(for: view)
        configureView()
        configureCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        resizeCollectionViewHeight()
        showFilter()
    }
    
    // MARK: - Private Method
    private func configureView() {
        // TODO: 임시 Hidden - swipe gesture 추가 예정
        viewHolder.grabView.isHidden = true
        setFilterTitle()
        setMultiSelect()
        hideApplyButton()
        configureButtonsAction()
        addGestureToBackgroundView()
    }
    
    private func setFilterTitle() {
        viewHolder.titleLabel.text = filterEntity.defaultText
    }
    
    private func setMultiSelect() {
        let filterType = filterEntity.filterType
        viewHolder.collectionView.allowsMultipleSelection = filterType == .sort ? false : true
    }
    
    private func hideApplyButton() {
        let filterType = filterEntity.filterType
        viewHolder.applyButton.isHidden = filterType == .sort ? true : false
    }
    
    private func addGestureToBackgroundView() {
        let gestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(didTapBackgroundView)
        )
        gestureRecognizer.delegate = self
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    private func configureButtonsAction() {
        viewHolder.applyButton.addTarget(
            self,
            action: #selector(didTapApplyButton),
            for: .touchUpInside
        )
        viewHolder.closeButton.addTarget(
            self,
            action: #selector(didTapCloseButton),
            for: .touchUpInside
        )
    }
    
    private func configureCollectionView() {
        viewHolder.collectionView.setCollectionViewLayout(createLayout(), animated: true)
        viewHolder.collectionView.delegate = self
        registerCells()
        configureDataSource()
        applySnapshot()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        if let section = ProductFilterSectionLayout().section(at: filterEntity.filterType) {
            return UICollectionViewCompositionalLayout(section: section)
        }
        return UICollectionViewLayout()
    }
    
    private func registerCells() {
        viewHolder.collectionView.register(SortFilterCell.self)
        viewHolder.collectionView.register(EventFilterCell.self)
        viewHolder.collectionView.register(RecommendFilterCell.self)
    }
    
    private func configureDataSource() {
        dataSource = DataSource(
            collectionView: viewHolder.collectionView
        ) { [weak self] collectionView, index, item in
            switch self?.filterEntity.filterType {
            case .sort:
                let cell: SortFilterCell = collectionView.dequeueReusableCell(for: index)
                
                cell.configureCell(filterItem: item)
                if item.isSelected {
                    self?.setSelectedItemToCollectionView(at: index)
                }
                return cell
            case .event:
                let cell: EventFilterCell = collectionView.dequeueReusableCell(for: index)
                
                cell.configureCell(filterItem: item)
                if item.isSelected {
                    self?.setSelectedItemToCollectionView(at: index)
                }
                return cell
            case .category, .recommend:
                let cell: RecommendFilterCell = collectionView.dequeueReusableCell(for: index)
                
                cell.configureCell(filterItem: item)
                if item.isSelected {
                    self?.setSelectedItemToCollectionView(at: index)
                }
                return cell
            default:
                return UICollectionViewCell()
            }
        }
    }
    
    private func applySnapshot() {
        let filterType = filterEntity.filterType
        let items = filterEntity.filterItem
        var snapshot = NSDiffableDataSourceSnapshot<FilterType, FilterItemEntity>()
        snapshot.appendSections([filterType])
        
        snapshot.appendItems(items)
        
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func resizeCollectionViewHeight() {
        let height = viewHolder.collectionView.contentSize.height
        
        if height > 0 {
            viewHolder.collectionView.snp.makeConstraints {
                $0.height.equalTo(height)
            }
        }
    }
    
    private func showFilter() {
        viewHolder.containerView.snp.remakeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveLinear) { [weak self] in
            self?.view.backgroundColor = .black.withAlphaComponent(0.7)
            self?.view.layoutIfNeeded()
        }
    }
    
    private func hideFilter(_ completion: @escaping () -> Void) {
        viewHolder.containerView.snp.remakeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.snp.bottom)
        }
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveLinear) { [weak self] in
            self?.view.backgroundColor = .clear
            self?.view.layoutIfNeeded()
        } completion: { _ in
            completion()
        }
    }
    
    private func setApplyButtonState() {
        guard filterEntity.filterType != .sort else { return }
        
        if viewHolder.collectionView.indexPathsForSelectedItems?.count == 0 {
            viewHolder.applyButton.setState(with: .disabled)
        } else {
            viewHolder.applyButton.setState(with: .enabled)
        }
    }
    
    private func setSelectedItemToCollectionView(at index: IndexPath) {
        viewHolder.collectionView.selectItem(
            at: index,
            animated: false,
            scrollPosition: .init()
        )
        setApplyButtonState()
    }
    
    // MARK: - Objective Method
    @objc private func didTapApplyButton() {
        let selectedItems = filterEntity.filterItem.filter { $0.isSelected == true }
    
        let gaEventName: GAEventName?
        let gaParameterKey: GAParameterKey?
        switch filterEntity.filterType {
        case .recommend:
            gaEventName = .recommendFilterClick
            gaParameterKey = .recommendFilterName
        case .category:
            gaEventName = .categoryFilterClick
            gaParameterKey = .categoryFilterName
        case .event:
            gaEventName = .eventFilterClick
            gaParameterKey = .eventFilterName
        default:
            gaEventName = nil
            gaParameterKey = nil
        }
        if let gaEventName,
           let gaParameterKey {
            logging(gaEventName, parameter: [
                gaParameterKey: selectedItems.map { $0.name }.joined(separator: ", ")
            ])
        }
        listener?.didTapApplyButton(with: selectedItems, type: filterEntity.filterType)
    }
    
    @objc private func didTapCloseButton() {
        hideFilter { [weak self] in
            self?.listener?.didTapCloseButton()
        }
    }
    
    @objc private func didTapBackgroundView() {
        hideFilter { [weak self] in
            self?.listener?.didTapCloseButton()
        }
    }
}

// MARK: - UICollectionViewDelegate
extension ProductFilterViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        filterEntity.filterItem[indexPath.item].isSelected = true
        setApplyButtonState()
        
        if filterEntity.filterType == .sort {
            listener?.didSelectSortFilter(item: filterEntity.filterItem[indexPath.item])
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didDeselectItemAt indexPath: IndexPath
    ) {
        filterEntity.filterItem[indexPath.item].isSelected = false
        setApplyButtonState()
    }
}

extension ProductFilterViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldReceive touch: UITouch
    ) -> Bool {
        guard touch.view?.isDescendant(of: viewHolder.containerView) == false else {
            return false
        }
        return true
    }
}

extension ProductFilterViewController {
    final class ViewHolder: ViewHolderable {
        
        enum Text {
            static let applyTitle: String = "적용하기"
        }
        
        enum Size {
            static let containerViewRadius: CGFloat = 16
            static let grabViewRadius: CGFloat = 2.5
            static let grabViewSize: CGSize = .init(width: 36, height: 5)
            static let grabViewTop: CGFloat = 5
            static let titleLeading: CGFloat = 20
            static let titleTop: CGFloat = 40
            static let applyButtonHeight: CGFloat = 52
        }
        
        let containerView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            view.makeRoundCorners(
                cornerRadius: Size.containerViewRadius,
                maskedCorners: [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            )
            return view
        }()
        
        let grabView: UIView = {
            let view = UIView()
            view.makeRounded(with: Size.grabViewRadius)
            view.backgroundColor = .gray400
            return view
        }()
        
        let closeButton: UIButton = {
            let button = UIButton()
            button.setImage(.iconClose, for: .normal)
            return button
        }()
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.font = .title1
            label.textColor = .black
            return label
        }()
        
        let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = .spacing40
            return stackView
        }()
        
        let collectionView: UICollectionView = {
            let collectionView = UICollectionView(
                frame: .zero,
                collectionViewLayout: UICollectionViewLayout()
            )
            collectionView.isScrollEnabled = false
            return collectionView
        }()
        
        let applyButton: PrimaryButton = {
            let button = PrimaryButton(state: .disabled)
            button.setText(with: Text.applyTitle)
            return button
        }()
        
        func place(in view: UIView) {
            view.addSubview(containerView)
            
            containerView.addSubview(grabView)
            containerView.addSubview(closeButton)
            containerView.addSubview(titleLabel)
            containerView.addSubview(stackView)
            
            stackView.addArrangedSubview(collectionView)
            stackView.addArrangedSubview(applyButton)
        }
        
        func configureConstraints(for view: UIView) {
            containerView.snp.makeConstraints {
                $0.leading.trailing.bottom.equalTo(view)
                $0.top.equalTo(view.snp.bottom)
            }
            
            grabView.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(containerView).offset(Size.grabViewTop)
                $0.size.equalTo(Size.grabViewSize)
            }
            
            closeButton.snp.makeConstraints {
                $0.top.equalToSuperview().offset(.spacing12)
                $0.trailing.equalToSuperview().inset(.spacing12)
            }
            
            titleLabel.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(Size.titleLeading)
                $0.top.equalToSuperview().offset(Size.titleTop)
            }
            
            stackView.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(Size.titleLeading)
                $0.trailing.equalToSuperview().inset(Size.titleLeading)
                $0.top.equalTo(titleLabel.snp.bottom).offset(.spacing24)
            }
            
            collectionView.snp.makeConstraints {
                $0.height.greaterThanOrEqualTo(90)
                $0.bottom.lessThanOrEqualTo(
                    view.safeAreaLayoutGuide
                ).inset(.spacing40).priority(.low)
            }
            
            applyButton.snp.makeConstraints {
                $0.height.equalTo(Size.applyButtonHeight)
                $0.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide).priority(.high)
                $0.bottom.equalTo(containerView).inset(.spacing16).priority(.medium)
            }
        }
    }
}
