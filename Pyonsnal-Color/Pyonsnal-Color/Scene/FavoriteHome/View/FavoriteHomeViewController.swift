//
//  FavoriteHomeViewController.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/09/11.
//

import UIKit
import SnapKit
import ModernRIBs
import Combine

protocol FavoriteHomePresentableListener: AnyObject {
    func requestFavoriteProducts()
    func deleteAllProducts()
    func appendProduct(product: ProductDetailEntity)
    func deleteProduct(product: ProductDetailEntity)
    func didTapSearchButton()
    func didSelect(with product: ProductDetailEntity)
    func loadMoreItems(type: ProductType)
    var isPagingEnabled: Bool { get }
}

enum FavoriteHomeTab: Int, CaseIterable {
    case product = 0
    case event
    
    var productType: ProductType {
        switch self {
        case .product:
            return .pb
        case .event:
            return .event
        }
    }
}

final class FavoriteHomeViewController: UIViewController,
                                    FavoriteHomePresentable,
                                    FavoriteHomeViewControllable {
    // MARK: Interface
    enum Size {
        static let headerViewHeight: CGFloat = 48
        static let stackViewHeight: CGFloat = 40
        static let underBarHeight: CGFloat = 3
        static let dividerViewHeight: CGFloat = 1
    }
    
    enum Text {
        static let tabBarItem = "찜"
        static let productTab = "차별화 상품"
        static let eventTab = "행사 상품"
    }
    
    weak var listener: FavoriteHomePresentableListener?
    
    // MARK: Private Property
    private let viewHolder: ViewHolder = .init()
    private var products = [FavoriteHomeTab: [ProductDetailEntity]]()
    private var scrollIndex = CurrentValueSubject<Int, Never>(0)
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configureTabBarItem()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        logging(.pageView, parameter: [
            .screenName: "main_like"
        ])
        
        listener?.requestFavoriteProducts()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewHolder.place(in: self.view)
        viewHolder.configureConstraints(for: self.view)
        configureUI()
        setTabSelectedState(to: .product)
        configureNavigationView()
        setPageViewController()
        bindActions()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        listener?.deleteAllProducts()
    }
    
    // MARK: - Public Method
    func updateProducts(products: [ProductDetailEntity]?, tab: FavoriteHomeTab) {
        self.products[tab] = products
        viewHolder.pageViewController.updateProducts(
            to: tab.rawValue,
            with: products
        )
    }
    
    // MARK: - Private Method
    private func configureUI() {
        view.backgroundColor = .white
    }
    
    private func configureTabBarItem() {
        tabBarItem.setTitleTextAttributes([.font: UIFont.label2], for: .normal)
        tabBarItem = UITabBarItem(
            title: Text.tabBarItem,
            image: ImageAssetKind.TabBar.favoriteUnSelected.image,
            selectedImage: ImageAssetKind.TabBar.favoriteSelected.image
        )
    }
    
    private func setTabSelectedState(to state: FavoriteHomeTab) {
        switch state {
        case .product:
            setSelectedState(
                button: viewHolder.productTabButton,
                underBarView: viewHolder.productUnderBarView
            )
            setUnSelectedState(
                button: viewHolder.eventTabButton,
                underBarView: viewHolder.eventUnderBarView
            )
        case .event:
            setSelectedState(
                button: viewHolder.eventTabButton,
                underBarView: viewHolder.eventUnderBarView
            )
            setUnSelectedState(
                button: viewHolder.productTabButton,
                underBarView: viewHolder.productUnderBarView
            )
        }
    }
    
    private func setSelectedState(button: UIButton, underBarView: UIView) {
        button.isSelected = true
        underBarView.isHidden = false
    }
    
    private func setUnSelectedState(button: UIButton, underBarView: UIView) {
        button.isSelected = false
        underBarView.isHidden = true
    }
    
    private func didTapButton(selectedTab: FavoriteHomeTab) {
        scrollIndex.send(selectedTab.rawValue)
        viewHolder.pageViewController.updatePage(to: selectedTab.rawValue)
    }
    
    private func setPageViewController() {
        addChild(viewHolder.pageViewController)
        viewHolder.pageViewController.didMove(toParent: self)
        viewHolder.pageViewController.pageDelegate = self
    }
    
    private func configureNavigationView() {
        viewHolder.titleNavigationView.delegate = self
    }
    
    private func bindActions() {
        viewHolder.productTabButton
            .tapPublisher
            .sink { [weak self] _ in
                self?.didTapButton(selectedTab: .product)
            }.store(in: &cancellable)

        viewHolder.eventTabButton
            .tapPublisher
            .sink { [weak self] _ in
                self?.didTapButton(selectedTab: .event)
            }.store(in: &cancellable)
        
        scrollIndex
            .sink { [weak self] index in
            let tab = FavoriteHomeTab(rawValue: index) ?? .product
            self?.setTabSelectedState(to: tab)
        }.store(in: &cancellable)
        
    }

}

// MARK: - TitleNavigationViewDelegate
extension FavoriteHomeViewController: TitleNavigationViewDelegate {
    func didTabSearchButton() {
        listener?.didTapSearchButton()
    }
    
    func didTabNotificationButton() {
    }
}

// MARK: - ProductPresentable
extension FavoriteHomeViewController: ProductPresentable {
    func didTabRootTabBar() {
        guard let currentTabViewController = viewHolder.pageViewController.viewControllers?.first as? FavoriteHomePageTabViewController else { return }
        currentTabViewController.scrollCollectionViewToTop()
    }
}

// MARK: - FavoriteHomeTabPageViewControllerDelegate
extension FavoriteHomeViewController: FavoriteHomeTabPageViewControllerDelegate {
    func loadProducts() {
        listener?.requestFavoriteProducts()
    }
    
    func updateSelectedTab(index: Int) {
        scrollIndex.send(index)
        viewHolder.pageViewController.updatePage(to: index)
    }
    
    func didTapProduct(product: ProductDetailEntity) {
        listener?.didSelect(with: product)
    }
    
    func didTapFavoriteButton(product: ProductDetailEntity, action: FavoriteButtonAction) {
        switch action {
        case .add:
            listener?.appendProduct(product: product)
        case .delete:
            listener?.deleteProduct(product: product)
        }
    }
    
    func pullToRefresh() {
        listener?.deleteAllProducts()
    }
    
    func loadMoreItems() {
        if listener?.isPagingEnabled ?? false {
            let tab = FavoriteHomeTab(rawValue: scrollIndex.value) ?? .product
            listener?.loadMoreItems(type: tab.productType)
        }
    }
}
