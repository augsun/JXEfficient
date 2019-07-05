### 目前版本 API 还未稳定, 将在版本 1.0.0 中稳定API. 目前可以接入使用, 后期只调整 API 调用. 

### 文档后期会持续补充更新，敬请期待~

# JXEfficient

[![CI Status](https://img.shields.io/travis/452720799@qq.com/JXEfficient.svg?style=flat)](https://travis-ci.org/452720799@qq.com/JXEfficient)
[![Version](https://img.shields.io/cocoapods/v/JXEfficient.svg?style=flat)](https://cocoapods.org/pods/JXEfficient)
[![License](https://img.shields.io/cocoapods/l/JXEfficient.svg?style=flat)](https://cocoapods.org/pods/JXEfficient)
[![Platform](https://img.shields.io/cocoapods/p/JXEfficient.svg?style=flat)](https://cocoapods.org/pods/JXEfficient)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

JXEfficient is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'JXEfficient'
```

## ClassTree 

Continuous updates will be made.

```
.
├── JXEfficient
│   ├── Category
│   │   ├── NSDate
│   │   │   ├── NSDate+JXCategory.h
│   │   │   └── NSDate+JXCategory.m
│   │   ├── NSLayoutConstraint
│   │   │   ├── NSLayoutConstraint+JXCategory.h
│   │   │   └── NSLayoutConstraint+JXCategory.m
│   │   ├── NSString
│   │   │   ├── NSString+JXCategory.h
│   │   │   ├── NSString+JXCategory.m
│   │   │   ├── NSString+JXCategory_URLString.h
│   │   │   └── NSString+JXCategory_URLString.m
│   │   ├── UIButton
│   │   │   ├── UIButton+JXCategory.h
│   │   │   └── UIButton+JXCategory.m
│   │   ├── UICollectionView
│   │   │   ├── UICollectionView+JXCategory.h
│   │   │   └── UICollectionView+JXCategory.m
│   │   ├── UIColor
│   │   │   ├── UIColor+JXCategory.h
│   │   │   └── UIColor+JXCategory.m
│   │   ├── UIImage
│   │   │   ├── UIImage+JXCategory.h
│   │   │   └── UIImage+JXCategory.m
│   │   ├── UIScrollView
│   │   │   ├── UIScrollView+JXCategory.h
│   │   │   └── UIScrollView+JXCategory.m
│   │   ├── UITableView
│   │   │   ├── UITableView+JXCategory.h
│   │   │   └── UITableView+JXCategory.m
│   │   ├── UIView
│   │   │   ├── UIView+JXCategory.h
│   │   │   ├── UIView+JXCategory.m
│   │   │   ├── UIView+JXToastAndProgressHUD.h
│   │   │   └── UIView+JXToastAndProgressHUD.m
│   │   └── UIViewController
│   │       ├── UIViewController+JXCategory.h
│   │       └── UIViewController+JXCategory.m
│   ├── JXBaseDocker
│   │   ├── JXBaseDocker.h
│   │   └── JXBaseDocker.m
│   ├── JXBaseWebVC
│   │   ├── JXBaseWebVC.h
│   │   ├── JXBaseWebVC.m
│   │   ├── JXBaseWebVCScriptMessageHandler.h
│   │   └── JXBaseWebVCScriptMessageHandler.m
│   ├── JXChowder
│   │   ├── JXChowder+GetTimestampFromNet.h
│   │   ├── JXChowder+GetTimestampFromNet.m
│   │   ├── JXChowder.h
│   │   └── JXChowder.m
│   ├── JXCoreData
│   │   ├── JXCoreData.h
│   │   └── JXCoreData.m
│   ├── JXEfficient_docker.h
│   ├── JXEfficient_docker.m
│   ├── JXEncryption
│   │   ├── JXEncryption+AES.h
│   │   ├── JXEncryption+AES.m
│   │   ├── JXEncryption+MD5.h
│   │   ├── JXEncryption+MD5.m
│   │   ├── JXEncryption+RSA.h
│   │   ├── JXEncryption+RSA.m
│   │   ├── JXEncryption.h
│   │   ├── JXEncryption.m
│   │   ├── RSA.h
│   │   └── RSA.m
│   ├── JXInline.h
│   ├── JXInline.m
│   ├── JXJSONCache
│   │   ├── JXJSONCache.h
│   │   └── JXJSONCache.m
│   ├── JXLocationCoordinates
│   │   ├── JXLocationCoordinates.h
│   │   └── JXLocationCoordinates.m
│   ├── JXMacro.h
│   ├── JXMacro.m
│   ├── JXRegular
│   │   ├── JXRegular.h
│   │   └── JXRegular.m
│   ├── JXSystemAlert
│   │   ├── JXSystemActionSheet.h
│   │   ├── JXSystemActionSheet.m
│   │   ├── JXSystemAlert.h
│   │   └── JXSystemAlert.m
│   ├── JXUUIDAndKeyChain
│   │   ├── JXUUIDAndKeyChain.h
│   │   └── JXUUIDAndKeyChain.m
│   ├── JXUpdateCheck
│   │   ├── JXUpdateCheck.h
│   │   └── JXUpdateCheck.m
│   └── UIView
│       ├── JXCarouselView
│       │   ├── JXCarouselImagePageControlView.h
│       │   ├── JXCarouselImagePageControlView.m
│       │   ├── JXCarouselImageView.h
│       │   ├── JXCarouselImageView.m
│       │   ├── JXCarouselModel.h
│       │   ├── JXCarouselModel.m
│       │   ├── JXCarouselPageControlView.h
│       │   ├── JXCarouselPageControlView.m
│       │   ├── JXCarouselView.h
│       │   └── JXCarouselView.m
│       ├── JXFlowView
│       │   ├── JXFlowView.h
│       │   ├── JXFlowView.m
│       │   ├── JXFlowViewItemModel.h
│       │   ├── JXFlowViewItemModel.m
│       │   ├── JXFlowViewItemView.h
│       │   ├── JXFlowViewItemView.m
│       │   ├── JXFlowViewLayout.h
│       │   └── JXFlowViewLayout.m
│       ├── JXImageBrowser
│       │   ├── JXImageBrowser.h
│       │   ├── JXImageBrowser.m
│       │   ├── JXImageBrowserImage.h
│       │   ├── JXImageBrowserImage.m
│       │   ├── JXImageBrowserImageView.h
│       │   ├── JXImageBrowserImageView.m
│       │   ├── JXImageBrowserLoadImageFailureView.h
│       │   ├── JXImageBrowserLoadImageFailureView.m
│       │   ├── JXImageBrowserPageControlView.h
│       │   ├── JXImageBrowserPageControlView.m
│       │   ├── JXImageBrowserProgressHUDView.h
│       │   └── JXImageBrowserProgressHUDView.m
│       ├── JXNaviView
│       │   ├── JXNaviView.h
│       │   └── JXNaviView.m
│       ├── JXNavigationBar
│       │   ├── JXNavigationBar.h
│       │   ├── JXNavigationBar.m
│       │   ├── JXNavigationBarItem.h
│       │   └── JXNavigationBarItem.m
│       ├── JXPagingView
│       │   ├── JXPagingView.h
│       │   └── JXPagingView.m
│       ├── JXPopupBaseView
│       │   ├── JXPopupBaseView.h
│       │   └── JXPopupBaseView.m
│       ├── JXPopupView
│       │   ├── JXPopupGeneralView.h
│       │   ├── JXPopupGeneralView.m
│       │   ├── JXPopupView.h
│       │   └── JXPopupView.m
│       ├── JXQRCodeScanView
│       │   ├── JXQRCodeScanView.h
│       │   └── JXQRCodeScanView.m
│       ├── JXRollView
│       │   ├── JXRollView.h
│       │   └── JXRollView.m
│       ├── JXTagLayout
│       │   ├── JXTagFlowLayout.h
│       │   └── JXTagFlowLayout.m
│       ├── JXTagsGeneralView
│       │   ├── JXTagsGeneralView.h
│       │   ├── JXTagsGeneralView.m
│       │   ├── JXTagsGeneralViewTagCell.h
│       │   ├── JXTagsGeneralViewTagCell.m
│       │   ├── JXTagsGeneralViewTagModel.h
│       │   └── JXTagsGeneralViewTagModel.m
│       ├── JXTagsView
│       │   ├── JXTagsView.h
│       │   ├── JXTagsView.m
│       │   ├── JXTagsViewTagModel.h
│       │   └── JXTagsViewTagModel.m
│       └── JXVideoPlayerView
│           ├── JXVideoPlayerView.h
│           └── JXVideoPlayerView.m
├── JXEfficient.h
└── JXEfficient.m
```



### JXPopupBaseView -> JXPopupView -> JXPopupGeneralView

![JXPopupGeneralView](https://raw.githubusercontent.com/augsun/Resources/master/JXEfficient/JXPopupGeneralView/JXPopupGeneralView.gif)



## Author

codersun@126.com

## License

JXEfficient is available under the MIT license. See the LICENSE file for more info.
