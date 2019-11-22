//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import Foundation
import UIKit

/// Protocol for selecting a sticker and dimissing the media drawer
protocol MediaDrawerControllerDelegate: class {
    func didSelectSticker(_ sticker: Sticker)
    func didDismissMediaDrawer()
}

/// A view controller that contains the media drawer in text tools
final class MediaDrawerController: UIViewController, DrawerTabBarControllerDelegate, StickerMenuControllerDelegate {
    
    weak var delegate: MediaDrawerControllerDelegate?
    
    private var openedMenu: UIViewController?
    
    private lazy var drawerTabBarController: DrawerTabBarController = {
        let controller = DrawerTabBarController()
        controller.delegate = self
        return controller
    }()
    
    private lazy var stickerMenuController: StickerMenuController = {
        let controller = StickerMenuController()
        controller.delegate = self
        return controller
    }()
    
    private lazy var mediaDrawerView: MediaDrawerView = MediaDrawerView()
    
    // MARK: - Initializers
    
    init() {
        super.init(nibName: .none, bundle: .none)
    }
    
    @available(*, unavailable, message: "use init(settings:, segments:) instead")
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @available(*, unavailable, message: "use init(settings:, segments:) instead")
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("init(nibName:bundle:) has not been implemented")
    }
    
    // MARK: - View life cycle
    
    override func loadView() {
        view = mediaDrawerView
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        load(childViewController: drawerTabBarController, into: mediaDrawerView.tabBarContainer)
        load(childViewController: stickerMenuController, into: mediaDrawerView.childContainer)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.didDismissMediaDrawer()
    }
        
    // MARK: - DrawerTabBarControllerDelegate
    
    func didSelectOption(_ option: DrawerTabBarOption) {
        let newMenu: UIViewController
        
        switch option {
        case .stickers:
            newMenu = stickerMenuController
        }
        
        openedMenu?.view.alpha = 0
        openedMenu = newMenu
        openedMenu?.view.alpha = 1
    }
    
    // MARK: - StickerMenuControllerDelegate
    
    func didSelectSticker(_ sticker: Sticker) {
        delegate?.didSelectSticker(sticker)
        dismiss(animated: true, completion: nil)
    }
}