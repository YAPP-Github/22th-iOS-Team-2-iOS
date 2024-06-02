//
//  MyReviewRouter.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 5/19/24.
//

import ModernRIBs

protocol MyReviewInteractable: Interactable,
                               MyDetailReviewListener {
    var router: MyReviewRouting? { get set }
    var listener: MyReviewListener? { get set }
}

protocol MyReviewViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class MyReviewRouter: ViewableRouter<MyReviewInteractable, MyReviewViewControllable>, MyReviewRouting {
    

    private let myDetailReviewBuilder: MyDetailReviewBuildable
    private var myDetailReviewRouting: ViewableRouting?
    
    init(
        interactor: MyReviewInteractable,
        viewController: MyReviewViewControllable,
        myDetailReviewBuilder: MyDetailReviewBuilder
    ) {
        self.myDetailReviewBuilder =  myDetailReviewBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachMyDetailReview(productDetail: ProductDetailEntity, review: ReviewEntity) {
        if myDetailReviewRouting != nil { return }
        let myDetailReviewRouter = myDetailReviewBuilder.build(
            withListener: interactor,
            productDetail: productDetail,
            review: review
        )
        myDetailReviewRouting = myDetailReviewRouter
        attachChild(myDetailReviewRouter)
        viewController.pushViewController(myDetailReviewRouter.viewControllable, animated: true)
    }
    
    func detachMyDetailReview() {
        guard let myDetailReviewRouting else { return }
        viewController.popViewController(animated: true)
        self.myDetailReviewRouting = nil
        detachChild(myDetailReviewRouting)
    }
}
