//
//  MyPickViewController.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/09/11.
//

import UIKit
import SnapKit
import ModernRIBs
import Combine

protocol MyPickPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class MyPickViewController: UIViewController,
                                  MyPickPresentable,
                                  MyPickViewControllable {
    enum Size {
        static let headerViewHeight: CGFloat = 48
        static let stackViewHeight: CGFloat = 40
        static let underBarHeight: CGFloat = 3
    }
    
    enum Text {
        static let tabBarItem = "찜"
        static let productTab = "차별화 상품"
        static let eventTab = "행사 상품"
    }
    
    enum Tab: Int {
        case product = 0
        case event
    }
    
    weak var listener: MyPickPresentableListener?
    private let viewHolder: ViewHolder = .init()
    private var scrollIndex = PassthroughSubject<Int, Never>()
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configureTabBarItem()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewHolder.place(in: self.view)
        viewHolder.configureConstraints(for: self.view)
        setTabSelectedState(to: .product)
        configureAction()
        configureCollectionView()
        configureNavigationView()
        bindActions()
    }
    
    private func configureTabBarItem() {
        tabBarItem.setTitleTextAttributes([.font: UIFont.label2], for: .normal)
        tabBarItem = UITabBarItem(
            title: Text.tabBarItem,
            image: ImageAssetKind.TabBar.myPickUnSelected.image,
            selectedImage: ImageAssetKind.TabBar.myPickSelected.image
        )
    }
    
    private func setTabSelectedState(to state: Tab) {
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
    
    private func configureAction() {
        viewHolder.productTabButton.addTarget(
            self,
            action: #selector(didTapProductButton),
            for: .touchUpInside
        )
        viewHolder.eventTabButton.addTarget(
            self,
            action: #selector(didTapEventButton),
            for: .touchUpInside
        )
    }
    
    @objc
    func didTapProductButton() {
        let selectedTab: Tab = .product
        self.selectTabAndScrollToItem(tab: selectedTab)
    }
    
    @objc
    func didTapEventButton() {
        let selectedTab: Tab = .event
        self.selectTabAndScrollToItem(tab: selectedTab)
    }
    
    private func selectTabAndScrollToItem(tab: Tab) {
        self.setTabSelectedState(to: tab)
        let indexPath = IndexPath(item: tab.rawValue, section: 0)
        viewHolder.collectionView.scrollToItem(
            at: indexPath,
            at: .centeredHorizontally,
            animated: true
        )
    }
    
    private func configureCollectionView() {
        viewHolder.collectionView.register(MyPickProductContainerCell.self)
        viewHolder.collectionView.delegate = self
        viewHolder.collectionView.dataSource = self
    }
    
    private func configureNavigationView() {
        viewHolder.titleNavigationView.delegate = self
    }
    
    private func bindActions() {
        scrollIndex
            .sink { [weak self] index in
            let tab = Tab(rawValue: index) ?? .product
            self?.setTabSelectedState(to: tab)
        }.store(in: &cancellable)
    }
    
    final class ViewHolder: ViewHolderable {
        let titleNavigationView: TitleNavigationView = {
            let view = TitleNavigationView()
            view.updateTitleLabel(with: Text.tabBarItem)
            return view
        }()
        
        private let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.distribution = .fillEqually
            stackView.axis = .horizontal
            return stackView
        }()
        
        private let productSubView: UIView = {
            let view = UIView()
            return view
        }()
        
        let productTabButton: UIButton = {
            let button = UIButton()
            button.setText(with: Text.productTab)
            button.titleLabel?.font = .label1
            button.setTitleColor(.black, for: .selected)
            button.setTitleColor(.gray400, for: .normal)
            return button
        }()
        
        private let eventSubView: UIView = {
            let view = UIView()
            return view
        }()
        
        let eventTabButton: UIButton = {
            let button = UIButton()
            button.setText(with: Text.eventTab)
            button.titleLabel?.font = .label1
            button.setTitleColor(.black, for: .selected)
            button.setTitleColor(.gray400, for: .normal)
            return button
        }()
        
        let productUnderBarView: UIView = {
            let view = UIView()
            view.backgroundColor = .black
            return view
        }()
        
        let eventUnderBarView: UIView = {
            let view = UIView()
            view.backgroundColor = .black
            return view
        }()
        
        let collectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.isPagingEnabled = true
            collectionView.showsHorizontalScrollIndicator = false
            return collectionView
        }()
        
        func place(in view: UIView) {
            view.addSubview(titleNavigationView)
            view.addSubview(stackView)
            stackView.addArrangedSubview(productSubView)
            stackView.addArrangedSubview(eventSubView)
            productSubView.addSubview(productTabButton)
            productSubView.addSubview(productUnderBarView)
            eventSubView.addSubview(eventTabButton)
            eventSubView.addSubview(eventUnderBarView)
            view.addSubview(collectionView)
        }
        
        func configureConstraints(for view: UIView) {
            titleNavigationView.snp.makeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                $0.height.equalTo(Size.headerViewHeight)
                $0.leading.trailing.equalToSuperview()
            }
            
            stackView.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(.spacing16)
                $0.trailing.equalToSuperview().inset(.spacing16)
                $0.top.equalTo(titleNavigationView.snp.bottom)
                $0.height.equalTo(Size.stackViewHeight)
            }
            
            productTabButton.snp.makeConstraints {
                $0.top.leading.trailing.bottom.equalToSuperview()
            }
            
            eventTabButton.snp.makeConstraints {
                $0.top.leading.trailing.bottom.equalToSuperview()
            }
            
            productUnderBarView.snp.makeConstraints {
                $0.leading.trailing.bottom.equalToSuperview()
                $0.height.equalTo(Size.underBarHeight)
            }
            
            eventUnderBarView.snp.makeConstraints {
                $0.leading.trailing.bottom.equalToSuperview()
                $0.height.equalTo(Size.underBarHeight)
            }
            
            collectionView.snp.makeConstraints {
                $0.top.equalTo(stackView.snp.bottom)
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            }
        }

    }

}

extension MyPickViewController: TitleNavigationViewDelegate {
    func didTabSearchButton() {
//        listener?.didTapSearchButton()
    }
    
    func didTabNotificationButton() {
    }
}

extension MyPickViewController: UICollectionViewDelegate {
    
}

extension MyPickViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MyPickProductContainerCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.update(with: nil)
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentIndex = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        scrollIndex.send(currentIndex)
    }

}

extension MyPickViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
}
