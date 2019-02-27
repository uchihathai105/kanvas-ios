//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import Foundation
import UIKit

protocol FilterCollectionControllerDelegate: class {
    /// Callback for when a filter item is selected
    func didSelectFilter(_ filterItem: FilterItem)
}

/// Constants for Collection Controller
private struct FilterCollectionControllerConstants {
    static let animationDuration: TimeInterval = 0.25
}

/// Controller for handling the filter item collection.
final class FilterCollectionController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private lazy var filterCollectionView = FilterCollectionView()
    private var filterItems: [FilterItem]
    private var selectedCell: FilterCollectionCell?
    
    weak var delegate: FilterCollectionControllerDelegate?
    
    /// Initializes the collection with Tumblr colors
    init() {
        filterItems = [FilterItem(representativeColor: .tumblrBrightRed),
                       FilterItem(representativeColor: .tumblrBrightPink),
                       FilterItem(representativeColor: .tumblrBrightOrange),
                       FilterItem(representativeColor: .tumblrBrightYellow),
                       FilterItem(representativeColor: .tumblrBrightGreen),
                       FilterItem(representativeColor: .tumblrBrightBlue),
                       FilterItem(representativeColor: .tumblrBrightPurple)]
        super.init(nibName: .none, bundle: .none)
    }
    
    @available(*, unavailable, message: "use init() instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @available(*, unavailable, message: "use init() instead")
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("init(nibName:bundle:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func loadView() {
        view = filterCollectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterCollectionView.collectionView.register(cell: FilterCollectionCell.self)
        filterCollectionView.collectionView.delegate = self
        filterCollectionView.collectionView.dataSource = self
        setUpView()
        setUpRecognizers()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        filterCollectionView.collectionView.collectionViewLayout.invalidateLayout()
        filterCollectionView.collectionView.layoutIfNeeded()
    }
    
    private func setUpView() {
        filterCollectionView.alpha = 0
    }
    
    private func setUpRecognizers() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(collectionTapped))
        filterCollectionView.collectionView.addGestureRecognizer(tapRecognizer)
    }
    
    // MARK: - Public interface
    
    func isViewVisible() -> Bool {
        return filterCollectionView.alpha > 0
    }
    
    func showView(_ show: Bool) {
        UIView.animate(withDuration: FilterCollectionControllerConstants.animationDuration) {
            self.filterCollectionView.alpha = show ? 1 : 0
        }
    }
    
    /// Returns the collection of filter items
    ///
    /// - Returns: Filter item array
    func getFilterItems() -> [FilterItem] {
        return filterItems
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionCell.identifier, for: indexPath)
        if let cell = cell as? FilterCollectionCell {
            cell.bindTo(filterItems[indexPath.item])
        }
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard filterItems.count > 0, collectionView.bounds != .zero else { return .zero }
        
        let leftInset = cellBorderWhenCentered(firstCell: true, leftBorder: true, collectionView: collectionView)
        let rightInset = cellBorderWhenCentered(firstCell: false, leftBorder: false, collectionView: collectionView)
        
        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }
    
    private func cellBorderWhenCentered(firstCell: Bool, leftBorder: Bool, collectionView: UICollectionView) -> CGFloat {
        let cellMock = FilterCollectionCell(frame: .zero)
        if firstCell, let firstFilter = filterItems.first {
            cellMock.bindTo(firstFilter)
        }
        else if let lastFilter = filterItems.last {
            cellMock.bindTo(lastFilter)
        }
        let cellSize = cellMock.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        let cellWidth = cellSize.width
        let center = collectionView.center.x
        let border = leftBorder ? center - cellWidth/2 : center + cellWidth/2
        let inset = leftBorder ? border : collectionView.bounds.width - border
        return inset
    }
    
    // MARK: - Scrolling
    
    private func scrollToOptionAt(_ index: Int) {
        guard filterCollectionView.collectionView.numberOfItems(inSection: 0) > index else { return }
        let indexPath = IndexPath(item: index, section: 0)
        filterCollectionView.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        didSelectFilter(at: indexPath)
    }
    
    private func indexPathAtCenter() -> IndexPath? {
        let x = filterCollectionView.collectionView.center.x + filterCollectionView.collectionView.contentOffset.x
        let y = filterCollectionView.collectionView.center.y + filterCollectionView.collectionView.contentOffset.y
        let point: CGPoint = CGPoint(x: x, y: y)
        return filterCollectionView.collectionView.indexPathForItem(at: point)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if let indexPath = indexPathAtCenter(), !decelerate {
            scrollToOptionAt(indexPath.item)
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if let indexPath = indexPathAtCenter() {
            scrollToOptionAt(indexPath.item)
        }
    }
    
    // When the collection is decelerating, but the user taps a cell to stop,
    // the collection needs to set a cell at the center of the screen
    @objc func collectionTapped() {
        if let indexPath = indexPathAtCenter() {
            scrollToOptionAt(indexPath.item)
        }
    }
    
    // Mark: - Filter Selection
    
    /// Sets the selected circle (increasing its size) and deselect the previous circle (making it standard size).
    /// It also calls the delegate to set the camera filter.
    ///
    /// - Returns: Filter array
    private func didSelectFilter(at indexPath: IndexPath) {
        if let previousCell = selectedCell {
            previousCell.setSelected(false)
        }
        
        let cell = filterCollectionView.collectionView.cellForItem(at: indexPath) as? FilterCollectionCell
        if let cell = cell {
            cell.setSelected(true)
            selectedCell = cell
        }
        
        delegate?.didSelectFilter(filterItems[indexPath.item])
    }
    
}
