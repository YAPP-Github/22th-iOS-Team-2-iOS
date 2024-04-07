//
//  RootTabBarViewController.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import ModernRIBs
import UIKit

protocol RootTabBarPresentableListener: AnyObject {
}

final class RootTabBarViewController:
    UITabBarController,
    RootTabBarPresentable,
    RootTabBarViewControllable {

    //MARK: - Property
    weak var listener: RootTabBarPresentableListener?
    
    private var lastSelectedItem: UITabBarItem?
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray100
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupTabBar()
    }
    
    //MARK: - Internal Method
    func setViewControllers(_ viewControllers: [ViewControllable]) {
        super.setViewControllers(viewControllers.map(\.uiviewController), animated: false)
    }
    
    //MARK: - Private Method
    private func setupTabBar() {
        tabBar.isTranslucent = false
        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = .black
        tabBar.backgroundColor = .white
        tabBar.layer.cornerRadius = 16
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabBar.layer.applyShadow(color: .black, alpha: 0.15, width: 0, height: 0, blur: 4)
    }
}

extension RootTabBarViewController {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let index = tabBar.items?.firstIndex(of: item) {
            var gaTab: GATabName?
            switch index {
            case 0:
                gaTab = .home
            case 1:
                gaTab = .event
            case 2:
                gaTab = .favorite
            case 3:
                gaTab = .profile
            default:
                gaTab = nil
            }
            logging(.tabbarClick, parameter: [
                .tabName: gaTab?.rawValue ?? "nil"
            ])
        }
        if lastSelectedItem == nil { lastSelectedItem = item }
        
        guard lastSelectedItem == item else {
            lastSelectedItem = item
            return
        }
        
        guard let index = tabBar.items?.firstIndex(of: item),
              let viewControllers = viewControllers,
              let navigationController = viewControllers[index] as? UINavigationController,
              let productListViewController = navigationController.viewControllers[0] as? ProductPresentable
        else {
            return
        }

        lastSelectedItem = item
        productListViewController.didTabRootTabBar()
    }
}
