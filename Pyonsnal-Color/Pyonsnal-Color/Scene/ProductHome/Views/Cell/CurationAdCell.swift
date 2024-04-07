//
//  CurationAdCell.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 12/23/23.
//

import UIKit
import SnapKit
import GoogleMobileAds

final class CurationAdCell: UICollectionViewCell {
    private var adMobManager: AdMobManager?
    private let nativeAdView = NativeAdView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAdMobManagerIfNeeded(adMobManager: AdMobManager) {
        if self.adMobManager != nil { return }
        self.adMobManager = adMobManager
        self.adMobManager?.delegate = self
        self.adMobManager?.loadAd()
    }
    
    private func configureView() {
        contentView.addSubview(nativeAdView)
        nativeAdView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - AdMobManagerDelegate
extension CurationAdCell: AdMobManagerDelegate {
    func didReceive(nativeAd: GADNativeAd) {
        (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
        (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body
        nativeAdView.bodyView?.isHidden = nativeAd.body == nil
        nativeAdView.callToActionView?.isHidden = nativeAd.callToAction == nil
        (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
        nativeAdView.iconView?.isHidden = nativeAd.icon == nil
        nativeAdView.nativeAd = nativeAd
    }
    
    func didFailToReceiveAd(with error: Error) {
        Log.d(message: "\(error.localizedDescription)")
    }
}
