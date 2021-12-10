//
//  ContextMenu.swift
//  Display
//
//  Created by Алексей Смирнов on 31.10.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit

// MARK: - ContextMenuItem
public typealias ActionClosure = (() -> Void)

// MARK: - ContextMenuItem

public protocol ContextMenuItem {
  var title: String {
    get
  }
  var image: UIImage? {
    get
  }
  var action: ActionClosure? {
    get
  }
}

extension ContextMenuItem {
  public var image: UIImage? {
    get { nil }
  }
}

// MARK: - ContextMenuItemWithImage

public struct ContextMenuItemWithImage: ContextMenuItem {
  public var title: String
  public var image: UIImage?
  public var action: ActionClosure?

  public init(title: String, image: UIImage?, action: @escaping ActionClosure) {
    self.title = title
    self.image = image
    self.action = action
  }
}

public var CM = ContextMenu()

// MARK: - ContextMenuConstants

public struct ContextMenuConstants {
  public var MaxZoom: CGFloat = 1.15
  public var MinZoom: CGFloat = 0.6
  public var MenuDefaultHeight: CGFloat = 120
  public var MenuWidth: CGFloat = 250
  public var MenuMarginSpace: CGFloat = 20
  public var TopMarginSpace: CGFloat = 40
  public var BottomMarginSpace: CGFloat = 24
  public var HorizontalMarginSpace: CGFloat = 20
  public var ItemDefaultHeight: CGFloat = 44

  public var LabelDefaultFont: UIFont = Font.medium(14)

  public var MenuCornerRadius: CGFloat = 12
  public var BlurEffectEnabled: Bool = true
  public var BlurEffectDefault = UIBlurEffect(style: .dark)
  public var BackgroundViewColor = UIColor.black.withAlphaComponent(0.6)

  public var DismissOnItemTap: Bool = false
}

// MARK: - ContextMenu

open class ContextMenu: NSObject {

  // MARK: Lifecycle

  // MARK:- Init Functions
  public init(window: UIView? = nil) {
    let wind = window ?? UIApplication.shared.windows.first ?? UIApplication.shared.asKeyWindow
    customView = wind!
    mainViewRect = wind!.frame
  }

  init?(viewTargeted: UIView, window: UIView? = nil) {
    if let wind = window ?? UIApplication.shared.windows.first ?? UIApplication.shared.asKeyWindow {
      customView = wind
      self.viewTargeted = viewTargeted
      mainViewRect = customView.frame
    }else{
      return nil
    }
  }

  init(viewTargeted: UIView, window: UIView) {
    self.viewTargeted = viewTargeted
    customView = window
    mainViewRect = window.frame
  }

  deinit {
//        removeTapInteraction()
  }

  // MARK: Open

  // MARK:- open Variables
  open var MenuConstants = ContextMenuConstants()
  open var viewTargeted: UIView!
  open var placeHolderView: UIView?
  open var headerView: UIView?
  open var footerView: UIView?
//  open var nibView = UINib(nibName: ContextMenuCell.identifier, bundle: Bundle(for: ContextMenuCell.self))
  open var closeAnimation = true

  open var onItemTap: ((_ index: Int, _ item: ContextMenuItem) -> Bool)?
  open var onViewAppear: ((UIView) -> Void)?
  open var onViewDismiss: ((UIView) -> Void)?

  open var items = [ContextMenuItem]()

  // MARK:- Show, Change, Update Menu Functions
  open func showMenu(viewTargeted: UIView, animated: Bool = true){
    NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
    DispatchQueue.main.async {
      self.viewTargeted = viewTargeted
      if !self.items.isEmpty {
        self.menuHeight = (CGFloat(self.items.count) * self.MenuConstants.ItemDefaultHeight) + (self.headerView?.frame.height ?? 0) + (self.footerView?.frame.height ?? 0) // + CGFloat(self.items.count - 1)
      } else {
        self.menuHeight = self.MenuConstants.MenuDefaultHeight
      }
      self.addBlurEffectView()
      self.addMenuView()
      self.addTargetedImageView()
      self.openAllViews()
    }
  }

  open func changeViewTargeted(newView: UIView, animated: Bool = true){
    DispatchQueue.main.async {
      guard self.viewTargeted != nil else{
        return
      }
      self.viewTargeted.alpha = 1
      if let gesture = self.touchGesture {
        self.viewTargeted.removeGestureRecognizer(gesture)
      }
      self.viewTargeted = newView
      self.targetedImageView.image = self.getRenderedImage(afterScreenUpdates: true)
      if let gesture = self.touchGesture {
        self.viewTargeted.addGestureRecognizer(gesture)
      }
      self.updateTargetedImageViewPosition(animated: animated)
    }
  }

  open func updateView(animated: Bool = true){
    DispatchQueue.main.async {
      guard self.viewTargeted != nil else{
        return
      }
      guard self.customView.subviews.contains(self.targetedImageView) else { return }
      if !self.items.isEmpty {
        self.menuHeight = (CGFloat(self.items.count) * self.MenuConstants.ItemDefaultHeight) + (self.headerView?.frame.height ?? 0) + (self.footerView?.frame.height ?? 0) // + CGFloat(self.items.count - 1)
      } else {
        self.menuHeight = self.MenuConstants.MenuDefaultHeight
      }
      self.viewTargeted.alpha = 0
      self.addMenuView()
      self.updateTargetedImageViewPosition(animated: animated)
    }
  }

  open func closeMenu(){
    closeAllViews()
  }

  open func closeMenu(withAnimation animation: Bool) {
    closeAllViews(withAnimation: animation)
  }

  // MARK: Public

  public var tableView = UITableView()

  // MARK: Internal

  // MARK:- Get Rendered Image Functions
  func getRenderedImage(afterScreenUpdates: Bool = false) -> UIImage{
    let renderer = UIGraphicsImageRenderer(size: viewTargeted.bounds.size)
    let viewSnapShotImage = renderer.image { _ in
      viewTargeted.contentScaleFactor = 3
      viewTargeted.drawHierarchy(in: viewTargeted.bounds, afterScreenUpdates: afterScreenUpdates)
    }
    return viewSnapShotImage
  }

  func addBlurEffectView(){

    if !customView.subviews.contains(blurEffectView) {
      customView.addSubview(blurEffectView)
    }
    if MenuConstants.BlurEffectEnabled {
      blurEffectView.effect = UIApplication.shared.asKeyWindow?.traitCollection.userInterfaceStyle == .dark ? MenuConstants.BlurEffectDefault : UIBlurEffect.init(style: .light)
      blurEffectView.backgroundColor = .clear
    }else{
      blurEffectView.effect = nil
      blurEffectView.backgroundColor = MenuConstants.BackgroundViewColor
    }

    blurEffectView.frame = CGRect(x: mainViewRect.origin.x, y: mainViewRect.origin.y, width: mainViewRect.width, height: mainViewRect.height)
    if closeGesture == nil {
      blurEffectView.isUserInteractionEnabled = true
      closeGesture = UITapGestureRecognizer(target: self, action: #selector(dismissViewAction(_:)))
      blurEffectView.addGestureRecognizer(closeGesture!)
    }
  }

  @objc
  func dismissViewAction(_ sender: UITapGestureRecognizer? = nil){
    closeAllViews()
  }

  func addCloseButton(){

    if !customView.subviews.contains(closeButton) {
      customView.addSubview(closeButton)
    }
    closeButton.frame = CGRect(x: mainViewRect.origin.x, y: mainViewRect.origin.y, width: mainViewRect.width, height: mainViewRect.height)
    closeButton.setTitle("", for: .normal)
    closeButton.actionHandler(controlEvents: .touchUpInside) { //[weak self] in
      self.closeAllViews()
    }
  }

  func addTargetedImageView(){

    if !customView.subviews.contains(targetedImageView) {
      customView.addSubview(targetedImageView)
    }

    let rect = viewTargeted.convert(mainViewRect.origin, to: nil)

    targetedImageView.image = getRenderedImage()
    targetedImageView.frame = CGRect(
      x: rect.x,
      y: rect.y,
      width: viewTargeted.frame.width,
      height: viewTargeted.frame.height)
    targetedImageView.layer.shadowColor = UIColor.black.cgColor
    targetedImageView.layer.shadowRadius = 16
    targetedImageView.layer.shadowOpacity = 0
    targetedImageView.isUserInteractionEnabled = true

  }

  func addMenuView(){

    if !customView.subviews.contains(menuView) {
      customView.addSubview(menuView)
      tableView = UITableView()
    }else{
      tableView.removeFromSuperview()
      tableView = UITableView()
    }

    let rect = viewTargeted.convert(mainViewRect.origin, to: nil)

    menuView.backgroundColor = UIColor.mainBackground
    menuView.layer.cornerRadius = MenuConstants.MenuCornerRadius
    menuView.clipsToBounds = true
    menuView.frame = CGRect(
      x: rect.x,
      y: rect.y,
      width: viewTargeted.frame.width,
      height: viewTargeted.frame.height)
    menuView.addSubview(tableView)

    tableView.dataSource = self
    tableView.delegate = self
    tableView.frame = menuView.bounds
    tableView.register(ContextMenuCell.self, forCellReuseIdentifier: "ContextMenuCell")
    tableView.tableHeaderView = headerView
    tableView.tableFooterView = footerView
    tableView.clipsToBounds = true
    tableView.isScrollEnabled = true
    tableView.alwaysBounceVertical = false
    tableView.allowsMultipleSelection = true
    tableView.backgroundColor = .clear
    tableView.reloadData()
  }

  func openAllViews(animated: Bool = true){
    let rect = viewTargeted.convert(mainViewRect.origin, to: nil)
    viewTargeted.alpha = 0
    //        customView.backgroundColor = .clear
    blurEffectView.alpha = 0
    closeButton.isUserInteractionEnabled = true
    targetedImageView.alpha = 1
    targetedImageView.layer.shadowOpacity = 0.0
    targetedImageView.isUserInteractionEnabled = true
    targetedImageView.frame = CGRect(x: rect.x, y: rect.y, width: viewTargeted.frame.width, height: viewTargeted.frame.height)
    menuView.alpha = 0
    menuView.isUserInteractionEnabled = true
    menuView.frame = CGRect(x: rect.x, y: rect.y, width: viewTargeted.frame.width, height: viewTargeted.frame.height)

    if animated {
      UIView.animate(withDuration: 0.2) {
        self.blurEffectView.alpha = 1
        self.targetedImageView.layer.shadowOpacity = 0.2
      }
    }else{
      blurEffectView.alpha = 1
      targetedImageView.layer.shadowOpacity = 0.2
    }
    updateTargetedImageViewPosition(animated: animated)
    onViewAppear?(viewTargeted)
  }

  func closeAllViews(){
    NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    DispatchQueue.main.async {
      self.targetedImageView.isUserInteractionEnabled = false
      self.menuView.isUserInteractionEnabled = false
      self.closeButton.isUserInteractionEnabled = false

      let rect = self.viewTargeted.convert(self.mainViewRect.origin, to: nil)
      if self.closeAnimation {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 6, options: [.layoutSubviews, .preferredFramesPerSecond60, .allowUserInteraction], animations: {
          self.prepareViewsForRemoveFromSuperView(with: rect)

        }) { _ in
          DispatchQueue.main.async {
            self.removeAllViewsFromSuperView()
          }
        }
      }else{
        DispatchQueue.main.async {
          self.prepareViewsForRemoveFromSuperView(with: rect)
          self.removeAllViewsFromSuperView()
        }
      }
      self.onViewDismiss?(self.viewTargeted)
    }
  }

  func closeAllViews(withAnimation animation: Bool = true) {
    NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    DispatchQueue.main.async {
      self.targetedImageView.isUserInteractionEnabled = false
      self.menuView.isUserInteractionEnabled = false
      self.closeButton.isUserInteractionEnabled = false

      let rect = self.viewTargeted.convert(self.mainViewRect.origin, to: nil)
      if animation {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 6, options: [.layoutSubviews, .preferredFramesPerSecond60, .allowUserInteraction], animations: {
          self.prepareViewsForRemoveFromSuperView(with: rect)
        }) { _ in
          DispatchQueue.main.async {
            self.removeAllViewsFromSuperView()
          }
        }
      } else {
        DispatchQueue.main.async {
          self.prepareViewsForRemoveFromSuperView(with: rect)
          self.removeAllViewsFromSuperView()
        }
      }
      self.onViewDismiss?(self.viewTargeted)
    }
  }

  func prepareViewsForRemoveFromSuperView(with rect: CGPoint) {
    blurEffectView.alpha = 0
    targetedImageView.layer.shadowOpacity = 0
    targetedImageView.frame = CGRect(x: rect.x, y: rect.y, width: viewTargeted.frame.width, height: viewTargeted.frame.height)
    menuView.alpha = 0
    menuView.frame = CGRect(x: rect.x, y: rect.y, width: viewTargeted.frame.width, height: viewTargeted.frame.height)
  }

  func removeAllViewsFromSuperView() {
    viewTargeted?.alpha = 1
    targetedImageView.alpha = 0
    targetedImageView.removeFromSuperview()
    blurEffectView.removeFromSuperview()
    closeButton.removeFromSuperview()
    menuView.removeFromSuperview()
    tableView.removeFromSuperview()
  }

  @objc
  func rotated() {
    if UIDevice.current.orientation.isLandscape, !isLandscape {
      updateView()
      isLandscape = true
      print("Landscape")
    } else if !UIDevice.current.orientation.isLandscape, isLandscape {
      updateView()
      isLandscape = false
      print("Portrait")
    }
  }

  func getZoomedTargetedSize() -> CGRect{

    let rect = viewTargeted.convert(mainViewRect.origin, to: nil)
    let targetedImageFrame = viewTargeted.frame

    let backgroundWidth = mainViewRect.width - (2 * MenuConstants.HorizontalMarginSpace)
    let backgroundHeight = mainViewRect.height - MenuConstants.TopMarginSpace - MenuConstants.BottomMarginSpace

    var zoomFactor = MenuConstants.MaxZoom
    var updatedWidth = targetedImageFrame.width // * zoomFactor
    var updatedHeight = targetedImageFrame.height // * zoomFactor

    if backgroundWidth > backgroundHeight {

      let zoomFactorHorizontalWithMenu = (backgroundWidth - MenuConstants.MenuWidth - MenuConstants.MenuMarginSpace) / updatedWidth
      let zoomFactorVerticalWithMenu = backgroundHeight / updatedHeight

      if zoomFactorHorizontalWithMenu < zoomFactorVerticalWithMenu {
        zoomFactor = zoomFactorHorizontalWithMenu
      }else{
        zoomFactor = zoomFactorVerticalWithMenu
      }
      if zoomFactor > MenuConstants.MaxZoom {
        zoomFactor = MenuConstants.MaxZoom
      }

      // Menu Height
      if menuHeight > backgroundHeight {
        menuHeight = backgroundHeight + MenuConstants.MenuMarginSpace
      }
    } else {

      let zoomFactorHorizontalWithMenu = backgroundWidth / updatedWidth
      let zoomFactorVerticalWithMenu = backgroundHeight / (updatedHeight + menuHeight + MenuConstants.MenuMarginSpace)

      if zoomFactorHorizontalWithMenu < zoomFactorVerticalWithMenu {
        zoomFactor = zoomFactorHorizontalWithMenu
      }else{
        zoomFactor = zoomFactorVerticalWithMenu
      }
      if zoomFactor > MenuConstants.MaxZoom {
        zoomFactor = MenuConstants.MaxZoom
      }else if zoomFactor < MenuConstants.MinZoom {
        zoomFactor = MenuConstants.MinZoom
      }
    }

    updatedWidth = (updatedWidth * zoomFactor)
    updatedHeight = (updatedHeight * zoomFactor)

    let updatedX = rect.x - (updatedWidth - targetedImageFrame.width) / 2
    let updatedY = rect.y - (updatedHeight - targetedImageFrame.height) / 2

    return CGRect(x: updatedX, y: updatedY, width: updatedWidth, height: updatedHeight)

  }

  func fixTargetedImageViewExtrudings() {

    if tvY > mainViewRect.height - MenuConstants.BottomMarginSpace - tvH {
      tvY = mainViewRect.height - MenuConstants.BottomMarginSpace - tvH
    }
    else if tvY < MenuConstants.TopMarginSpace {
      tvY = MenuConstants.TopMarginSpace
    }

    if tvX < MenuConstants.HorizontalMarginSpace {
      tvX = MenuConstants.HorizontalMarginSpace
//            mX = MenuConstants.HorizontalMarginSpace
    }
    else if tvX > mainViewRect.width - MenuConstants.HorizontalMarginSpace - tvW {
      tvX = mainViewRect.width - MenuConstants.HorizontalMarginSpace - tvW
//            mX = mainViewRect.width - MenuConstants.HorizontalMarginSpace - mW
    }

//        if mY
  }

  func updateHorizontalTargetedImageViewRect(){

    let rightClippedSpace = (tvW + MenuConstants.MenuMarginSpace + mW + tvX + MenuConstants.HorizontalMarginSpace) - mainViewRect.width
    let leftClippedSpace = -(tvX - MenuConstants.MenuMarginSpace - mW - MenuConstants.HorizontalMarginSpace)

    if leftClippedSpace > 0, rightClippedSpace > 0 {

      let diffY = mainViewRect.width - (mW + MenuConstants.MenuMarginSpace + tvW + MenuConstants.HorizontalMarginSpace + MenuConstants.HorizontalMarginSpace)
      if diffY > 0 {
        if (tvX + tvW / 2) > mainViewRect.width / 2 { //right
          tvX = tvX + leftClippedSpace
          mX = tvX - MenuConstants.MenuMarginSpace - mW
        }else{ //left
          tvX = tvX - rightClippedSpace
          mX = tvX + MenuConstants.MenuMarginSpace + tvW
        }
      } else {
        if (tvX + tvW / 2) > mainViewRect.width / 2 { //right
          tvX = mainViewRect.width - MenuConstants.HorizontalMarginSpace - tvW
          mX = MenuConstants.HorizontalMarginSpace
        }else{ //left
          tvX = MenuConstants.HorizontalMarginSpace
          mX = tvX + tvW + MenuConstants.MenuMarginSpace
        }
      }
    }
    else if rightClippedSpace > 0 {
      mX = tvX - MenuConstants.MenuMarginSpace - mW
    }
    else if leftClippedSpace > 0 {
      mX = tvX + MenuConstants.MenuMarginSpace + tvW
    }
    else{
      mX = tvX + MenuConstants.MenuMarginSpace + tvW
    }

    if mH >= (mainViewRect.height - MenuConstants.TopMarginSpace - MenuConstants.BottomMarginSpace) {
      mY = MenuConstants.TopMarginSpace
      mH = mainViewRect.height - MenuConstants.TopMarginSpace - MenuConstants.BottomMarginSpace
    }
    else if (tvY + mH) <= (mainViewRect.height - MenuConstants.BottomMarginSpace) {
      mY = tvY
    }
    else if (tvY + mH) > (mainViewRect.height - MenuConstants.BottomMarginSpace){
      mY = tvY - ((tvY + mH) - (mainViewRect.height - MenuConstants.BottomMarginSpace))
    }
  }

  func updateVerticalTargetedImageViewRect(){

    let bottomClippedSpace = (tvH + MenuConstants.MenuMarginSpace + mH + tvY + MenuConstants.BottomMarginSpace) - mainViewRect.height
    let topClippedSpace = -(tvY - MenuConstants.MenuMarginSpace - mH - MenuConstants.TopMarginSpace)

    // not enought space down

    if topClippedSpace > 0, bottomClippedSpace > 0 {

      let diffY = mainViewRect.height - (mH + MenuConstants.MenuMarginSpace + tvH + MenuConstants.TopMarginSpace + MenuConstants.BottomMarginSpace)
      if diffY > 0 {
        if (tvY + tvH / 2) > mainViewRect.height / 2 { //down
          tvY = tvY + topClippedSpace
          mY = tvY - MenuConstants.MenuMarginSpace - mH
        }else{ //up
          tvY = tvY - bottomClippedSpace
          mY = tvY + MenuConstants.MenuMarginSpace + tvH
        }
      } else {
        if (tvY + tvH / 2) > mainViewRect.height / 2 { //down
          tvY = mainViewRect.height - MenuConstants.BottomMarginSpace - tvH
          mY = MenuConstants.TopMarginSpace
          mH = mainViewRect.height - MenuConstants.TopMarginSpace - MenuConstants.BottomMarginSpace - MenuConstants.MenuMarginSpace - tvH
        }else{ //up
          tvY = MenuConstants.TopMarginSpace
          mY = tvY + tvH + MenuConstants.MenuMarginSpace
          mH = mainViewRect.height - MenuConstants.TopMarginSpace - MenuConstants.BottomMarginSpace - MenuConstants.MenuMarginSpace - tvH
        }
      }
    }
    else if bottomClippedSpace > 0 {
      mY = tvY - MenuConstants.MenuMarginSpace - mH
    }
    else if topClippedSpace > 0 {
      mY = tvY + MenuConstants.MenuMarginSpace + tvH
    }
    else{
      mY = tvY + MenuConstants.MenuMarginSpace + tvH
    }

  }

  func updateTargetedImageViewRect(){

    mainViewRect = customView.frame

    let targetedImagePosition = getZoomedTargetedSize()

    tvH = targetedImagePosition.height
    tvW = targetedImagePosition.width
    tvY = targetedImagePosition.origin.y
    tvX = targetedImagePosition.origin.x
    mH = menuHeight
    mW = MenuConstants.MenuWidth
    mY = tvY + MenuConstants.MenuMarginSpace
    mX = MenuConstants.HorizontalMarginSpace

    fixTargetedImageViewExtrudings()

    let backgroundWidth = mainViewRect.width - (2 * MenuConstants.HorizontalMarginSpace)
    let backgroundHeight = mainViewRect.height - MenuConstants.TopMarginSpace - MenuConstants.BottomMarginSpace

    if backgroundHeight > backgroundWidth {
      updateVerticalTargetedImageViewRect()
    }
    else{
      updateHorizontalTargetedImageViewRect()
    }

    tableView.frame = CGRect(x: 0, y: 0, width: mW, height: mH)
    tableView.layoutIfNeeded()

  }

  func updateTargetedImageViewPosition(animated: Bool = true){

    updateTargetedImageViewRect()
    if animated {
      UIView.animate(
        withDuration: 0.2,
        delay: 0,
        usingSpringWithDamping: 0.9,
        initialSpringVelocity: 6,
        options: [.layoutSubviews, .preferredFramesPerSecond60, .allowUserInteraction],
        animations:
        { [weak self] in

          self?.updateTargetedImageViewPositionFrame()

        })
    }else{
      updateTargetedImageViewPositionFrame()
    }
  }

  func updateTargetedImageViewPositionFrame(){
    let weakSelf = self

    weakSelf.menuView.alpha = 1
    weakSelf.menuView.frame = CGRect(
      x: weakSelf.mX,
      y: weakSelf.mY,
      width: weakSelf.mW,
      height: weakSelf.mH)

    weakSelf.targetedImageView.frame = CGRect(
      x: weakSelf.tvX,
      y: weakSelf.tvY,
      width: weakSelf.tvW,
      height: weakSelf.tvH)

    weakSelf.blurEffectView.frame = CGRect(
      x: weakSelf.mainViewRect.origin.x,
      y: weakSelf.mainViewRect.origin.y,
      width: weakSelf.mainViewRect.width,
      height: weakSelf.mainViewRect.height)
    weakSelf.closeButton.frame = CGRect(
      x: weakSelf.mainViewRect.origin.x,
      y: weakSelf.mainViewRect.origin.y,
      width: weakSelf.mainViewRect.width,
      height: weakSelf.mainViewRect.height)
  }

  // MARK: Private

  private var mainViewRect: CGRect
  private var customView = UIView()
  private var blurEffectView = UIVisualEffectView()
  private var closeButton = UIButton()
  private var targetedImageView = UIImageView()
  private var menuView = UIView()
  private var tableViewConstraint: NSLayoutConstraint?
  private var zoomedTargetedSize = CGRect()

  private var menuHeight: CGFloat = 180
  private var isLandscape: Bool = false

  private var touchGesture: UITapGestureRecognizer?
  private var closeGesture: UITapGestureRecognizer?

  private var tvH: CGFloat = 0.0
  private var tvW: CGFloat = 0.0
  private var tvY: CGFloat = 0.0
  private var tvX: CGFloat = 0.0
  private var mH: CGFloat = 0.0
  private var mW: CGFloat = 0.0
  private var mY: CGFloat = 0.0
  private var mX: CGFloat = 0.0
}

// MARK: UITableViewDataSource, UITableViewDelegate

extension ContextMenu: UITableViewDataSource, UITableViewDelegate {

  open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    items.count
  }

  open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // swiftlint:disable:next force_cast
    let cell = tableView.dequeueReusableCell(withIdentifier: "ContextMenuCell", for: indexPath) as! ContextMenuCell
    cell.contextMenu = self
    cell.tableView = tableView
    cell.style = MenuConstants
    cell.item = items[indexPath.row]
    cell.setup()
    return cell
  }

  open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let item = items[indexPath.row]
    if onItemTap?(indexPath.row, item) ?? false {
      closeAllViews()
    }
    closeAllViews()
    if let action = item.action {
      action()
    }
  }

  open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    MenuConstants.ItemDefaultHeight
  }

  open func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    MenuConstants.ItemDefaultHeight
  }

}

// MARK: - ClosureSleeve

@objc
class ClosureSleeve: NSObject {

  // MARK: Lifecycle

  init (_ closure: @escaping () -> Void) {
    self.closure = closure
  }

  // MARK: Internal

  let closure: () -> Void

  @objc
  func invoke () {
    closure()
  }
}

extension UIControl {
  func actionHandler(controlEvents control: UIControl.Event = .touchUpInside, ForAction action: @escaping () -> Void) {
    let sleeve = ClosureSleeve(action)
    addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: control)
    objc_setAssociatedObject(self, "[\(arc4random())]", sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
  }
}

// MARK: - ContextMenuCell

open class ContextMenuCell: UITableViewCell {

  // MARK: Lifecycle

  public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    backgroundColor = .mainBackground
    let stackView = UIStackView(arrangedSubviews: [titleLabel, iconImageView])

    contentView.addSubview(stackView)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
      stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
      stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
      stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
    ])
  }

  @available(*, unavailable)
  required public init?(coder _: NSCoder) { fatalError() }

  // MARK: Open

  override open func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

  override open func setHighlighted(_ highlighted: Bool, animated: Bool) {
    if highlighted {
      contentView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
    } else {
      contentView.backgroundColor = .clear
    }
  }

  override open func prepareForReuse() {
    super.prepareForReuse()

    titleLabel.text = nil
    iconImageView.image = nil
  }

  open func setup() {
    titleLabel.text = item.title
    if let menuConstants = style {
      titleLabel.font = menuConstants.LabelDefaultFont
    }
    iconImageView.image = item.image
    iconImageView.tintColor = UIColor.dark
    iconImageView.isHidden = item.image == nil
  }

  // MARK: Internal

  static let identifier = "ContextMenuCell"

  weak var contextMenu: ContextMenu?
  weak var tableView: UITableView?
  var item: ContextMenuItem!
  var style: ContextMenuConstants? = nil

  // MARK: Private

  private lazy var titleLabel: UILabel = {
    $0.font = Font.bold(14)
    return $0
  }(UILabel())

  private lazy var iconImageView: UIImageView = {
    $0.contentMode = .scaleAspectFit
    return $0
  }(UIImageView())

}
