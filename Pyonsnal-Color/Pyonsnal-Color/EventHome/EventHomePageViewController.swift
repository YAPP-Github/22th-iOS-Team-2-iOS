//
//  PersonalPageViewController.swift
//  CollectionView-Structure-Test
//
//  Created by 조소정 on 2023/06/15.
//

import UIKit

protocol EventHomePageViewControllerDelegate: AnyObject {
    func updateSelectedTabCell(index: Int)
}

final class EventHomePageViewController: UIPageViewController {
    
    // MARK: - Private property
    private var pageViewControllers = [EventHomeTabViewController]()
    private var currentIndex: Int = 0
    private var tabCount: Int = 5 // 임시
    
    var currentViewController: EventHomeTabViewController?
    weak var pageDelegate: EventHomePageViewControllerDelegate?
    weak var scrollDelegate: ScrollDelegate?

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setPageViewControllers()
    }
    
    // MARK: - Private Method
    private func setPageViewControllers() {
        for _ in 0..<tabCount {
            // dummy
            let viewController = EventHomeTabViewController()
            viewController.scrollDelegate = self
            
            pageViewControllers.append(viewController)
            
        }
        
        self.delegate = self
        self.dataSource = self
        if let firstViewController = pageViewControllers.first {
            currentViewController = firstViewController
            setViewControllers([firstViewController], direction: .forward, animated: true)
        }
    }
    
    //tabCollecionview 클릭시 연결할 함수
    func updatePage(_ index: Int) {
        let viewController = pageViewControllers[index]

        let direction: UIPageViewController.NavigationDirection = currentIndex <= index ? .forward : .reverse
        currentIndex = index
        
        setViewControllers([viewController], direction: direction, animated: true) { (result) in }
    }
    
}

extension EventHomePageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let viewControllers = pageViewController.viewControllers,
              let viewController = viewControllers.first as? EventHomeTabViewController,
              let index = pageViewControllers.firstIndex(of: viewController) else {
            return
        }
        
        self.pageDelegate?.updateSelectedTabCell(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? EventHomeTabViewController {
            guard let index = pageViewControllers.firstIndex(of: viewController) else { return nil }
            let beforeIndex = index - 1
            currentIndex = index
            if beforeIndex >= 0, beforeIndex < pageViewControllers.count {
                currentViewController = pageViewControllers[beforeIndex]
                return pageViewControllers[beforeIndex]
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let viewController =  viewController as? EventHomeTabViewController {
            guard let index = pageViewControllers.firstIndex(of: viewController) else { return nil }
            let afterIndex = index + 1
            currentIndex = index
            if afterIndex >= 0, afterIndex < pageViewControllers.count {
                currentViewController = pageViewControllers[afterIndex]
                return pageViewControllers[afterIndex]
            }
        }
        return nil
        
    }
    
    
}

extension EventHomePageViewController: ScrollDelegate {
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
