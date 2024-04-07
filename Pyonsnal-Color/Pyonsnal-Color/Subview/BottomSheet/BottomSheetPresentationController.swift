//
//  BottomSheetPresentationController.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/07/30.
//

import UIKit

final class BottomSheetPresentationController: UIPresentationController {
    private let containerSize: CGSize?
    var backgroundDidTapAction: (() -> Void)?
    var dismissCompletion: (() -> Void)?
    
    private let backgroundView: UIView = {
        let view: UIView = .init(frame: .zero)
        return view
    }()
    
    override var frameOfPresentedViewInContainerView: CGRect {
        switch containerSize {
        case .none:
            return calculateContainerFrameAutomatic()
        case .some:
            return calculateContainerFrameManually()
        }
    }
    
    // MARK: - Initializer
    required init(
        containerSize: CGSize?,
        presented: UIViewController,
        presenting: UIViewController?,
        backgroundDidTapAction: (() -> Void)?,
        dismissCompletion: (() -> Void)?
    ) {
        self.containerSize = containerSize
        self.backgroundDidTapAction = backgroundDidTapAction
        self.dismissCompletion = dismissCompletion
        super.init(presentedViewController: presented, presenting: presenting)
        
        configureAction()
    }
    
    // MARK: - Override Method
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    override func size(
        forChildContentContainer container: UIContentContainer,
        withParentContainerSize parentSize: CGSize
    ) -> CGSize {
        return .init(
            width: parentSize.width,
            height: containerSize?.height ?? UIView.layoutFittingCompressedSize.height
        )
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        containerView?.insertSubview(backgroundView, at: 0)
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        
        dismissCompletion?()
    }
    
    // MARK: - Private Method
    private func updatePresentedView() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    private func calculateContainerFrameAutomatic() -> CGRect {
        guard let containerView,
              let presentedView else {
            return .zero
        }
        
        let safeAreaFrame = containerView.bounds.inset(by: containerView.safeAreaInsets)
        let fittingSize = CGSize(
            width: safeAreaFrame.width,
            height: UIView.layoutFittingCompressedSize.height
        )
        let height = presentedView.systemLayoutSizeFitting(
            fittingSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .defaultLow
        ).height
        
        var frame = safeAreaFrame
        frame.size = .init(width: safeAreaFrame.width, height: height)
        
        return frame
    }
    
    private func calculateContainerFrameManually() -> CGRect {
        guard let containerView else { return .zero }
        
        var frame: CGRect = .zero
        
        let containerSize = size(
            forChildContentContainer: presentedViewController,
            withParentContainerSize: containerView.bounds.size
        )
        
        frame.size = containerSize
        frame.origin.x = (containerView.bounds.width - containerSize.width) / 2
        frame.origin.y = containerView.bounds.height - containerSize.height
        
        return frame
    }
    
    private func configureAction() {
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundDidTapAction(_:))))
    }
    
    @objc private func backgroundDidTapAction(_ recognizer: UITapGestureRecognizer) {
        guard recognizer.state == .ended else { return }
        
        backgroundDidTapAction?()
    }
}
