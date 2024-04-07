//
//  ProductSearchSortBottomSheetViewController.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/07/30.
//

import ModernRIBs
import UIKit

protocol ProductSearchSortBottomSheetPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class ProductSearchSortBottomSheetViewController: UIViewController,
                                                            ProductSearchSortBottomSheetPresentable,
                                                            ProductSearchSortBottomSheetViewControllable {

    // MARK: - Declaration
    struct Payload {
        let sortList: [FilterItemEntity] = []
    }
    
    enum Size {
        static let selectionButtonHeight: CGFloat = 40
    }
    
    // MARK: - Interface
    var payload: Payload? {
        didSet { updateUI() }
    }
    weak var listener: ProductSearchSortBottomSheetPresentableListener?
    
    // MARK: - Private Method
    private let viewHolder: ViewHolder = .init()
    private let presentor = BottomSheetPresentor()
    
    // MARK: - Initializer
    init() {
        super.init(nibName: nil, bundle: nil)
        
//        modalPresentationStyle = .custom
//        transitioningDelegate = presentor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewHolder.place(in: view)
        viewHolder.configureConstraints(for: view)
        
        configureUI()
        configureAction()
    }
    
    // MARK: - Private Method
    private func configureUI() {
        view.backgroundColor = .white
    }
    
    private func configureAction() {
        viewHolder.closeButton.addTarget(
            self,
            action: #selector(closeButtonAction(_:)),
            for: .touchUpInside
        )
    }
    
    private func updateUI() {
        guard let payload else { return }
        
        viewHolder.buttonStackView.subviews.forEach {
            $0.snp.removeConstraints()
            $0.removeFromSuperview()
        }
        
        payload.sortList.forEach { sort in
            let selectionButton = SelectionButton()
            selectionButton.setTitle(sort.name, for: .normal)
            selectionButton.addTarget(
                self,
                action: #selector(selectionButtonAction(_:)),
                for: .touchUpInside
            )
            viewHolder.buttonStackView.addArrangedSubview(selectionButton)
            selectionButton.snp.makeConstraints { make in
                make.height.equalTo(Size.selectionButtonHeight)
            }
        }
    }
    
    @objc private func selectionButtonAction(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    @objc private func closeButtonAction(_ sender: UIButton) {
        
    }
}
