//
//  ProductHomePageViewController.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/22.
//

import UIKit
import SnapKit

protocol ProductHomePageViewControllerDelegate: CommonProductPageViewControllerRenderable {
    func didAppearProductList()
    func curationWillAppear()
    func didTapEventBanner(eventDetail: EventBannerDetailEntity)
}

final class ProductHomePageViewController: UIPageViewController {
    
    // MARK: - Property
    weak var scrollDelegate: ScrollDelegate?
    weak var pagingDelegate: ProductHomePageViewControllerDelegate?
    var productListViewControllers: [UIViewController] = []
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        generateChildViewControllers()
        configureViewController()
    }
    
    // MARK: - Private Method
    private func generateChildViewControllers() {
        let curationViewController = ProductCurationViewController()
        curationViewController.curationDelegate = self
        curationViewController.delegate = self
        productListViewControllers.append(curationViewController)
        
        ConvenienceStore.allCases.forEach {
            let childViewController = ProductListViewController(convenienceStore: $0)
            childViewController.scrollDelegate = self
            childViewController.listDelegate = self
            childViewController.delegate = self
            productListViewControllers.append(childViewController)
        }
    }
    
    private func configureViewController() {
        view.backgroundColor = .gray100
        view.translatesAutoresizingMaskIntoConstraints = false
        dataSource = self
        delegate = self
        
        if let firstViewController = productListViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true)
        }
    }
    
    func updatePage(to page: Int) {
        guard let viewController = viewControllers?.first,
              let currentIndex = productListViewControllers.firstIndex(of: viewController)
        else {
            return
        }

        let isForward = currentIndex < page
        let direction: UIPageViewController.NavigationDirection = isForward ? .forward : .reverse
        setViewControllers(
            [productListViewControllers[page]],
            direction: direction,
            animated: true,
            completion: nil
        )
    }
}

// MARK: - UIPageViewControllerDataSource
extension ProductHomePageViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let index = productListViewControllers.firstIndex(of: viewController),
              index - 1 >= 0
        else {
            return nil
        }
        
        let beforeIndex = index - 1
        return productListViewControllers[beforeIndex]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let index = productListViewControllers.firstIndex(of: viewController),
              index + 1 < productListViewControllers.count
        else {
            return nil
        }

        let nextIndex = index + 1
        return productListViewControllers[nextIndex]
    }
}

// MARK: - UIPageViewControllerDelegate
extension ProductHomePageViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard let viewControllers = pageViewController.viewControllers,
              let viewController = viewControllers.first,
              let index = productListViewControllers.firstIndex(of: viewController)
        else {
            return
        }
        
        pagingDelegate?.updateSelectedStoreCell(index: index)
    }
}

// MARK: - ScrollDelegate
extension ProductHomePageViewController: ScrollDelegate {
    func didScroll(scrollView: UIScrollView) {
        scrollDelegate?.didScroll(scrollView: scrollView)
    }
    
    func willBeginDragging(scrollView: UIScrollView) {
        scrollDelegate?.willBeginDragging(scrollView: scrollView)
    }
    
    func didEndDragging(scrollView: UIScrollView) {
        scrollDelegate?.didEndDragging(scrollView: scrollView)
    }
}

// MARK: - ProductListDelegate
extension ProductHomePageViewController: ProductListDelegate {
    
    func didLoadPageList(store: ConvenienceStore) {
        pagingDelegate?.didChangeStore(to: store)
    }
    
    func refreshByPull() {
        guard let viewController = viewControllers?.first,
              let index = productListViewControllers.firstIndex(of: viewController)
        else {
            return
        }
        // curationViewController 제외 -1
        pagingDelegate?.didChangeStore(to: ConvenienceStore.allCases[index - 1])
    }
    
    func didSelect(with product: ProductDetailEntity?) {
        guard let product else { return }
        pagingDelegate?.didSelect(with: product)
    }
    
    func deleteKeywordFilter(_ filter: FilterItemEntity) {
        pagingDelegate?.deleteKeywordFilter(filter)
    }
    
    func refreshFilterButton() {
        pagingDelegate?.didTapRefreshFilterButton()
    }
    
    func didAppearProductList() {
        pagingDelegate?.didAppearProductList()
    }
    
    func didFinishUpdateSnapshot() {
        pagingDelegate?.didFinishUpdateSnapshot()
    }
    
    func didTapFavoriteButton(product: ProductDetailEntity, action: FavoriteButtonAction) {
        pagingDelegate?.didTapFavoriteButton(product: product, action: action)
    }
}

// MARK: - CurationDelegate
extension ProductHomePageViewController: CurationDelegate {
    func curationWillAppear() {
        pagingDelegate?.curationWillAppear()
    }
    
    func didTapEventBanner(eventDetail: EventBannerDetailEntity) {
        logging(.bannerClick, parameter: [
            .bannerName: eventDetail.links.first ?? "nil"
        ])
        pagingDelegate?.didTapEventBanner(eventDetail: eventDetail)
    }
}
