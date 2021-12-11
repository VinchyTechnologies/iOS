//
//  PartnerAnnotationView.swift
//  Smart
//
//  Created by Алексей Смирнов on 28.04.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import DisplayMini
import MapKit
import UIKit

// MARK: - PartnerAnnotationViewModel

final class PartnerAnnotationViewModel: NSObject, MKAnnotation {

  // MARK: Lifecycle

  init(kind: Kind) {
    self.kind = kind
  }

  // MARK: Internal

  enum Kind: Equatable {
    case store(partnerId: Int, affilatedId: Int, title: String?, latitude: CLLocationDegrees, longitude: CLLocationDegrees, shouldCluster: Bool)

    static func == (lhs: Kind, rhs: Kind) -> Bool {
      switch (lhs, rhs) {
      case (let .store(lhsPartnerId, lhsAffilatedId, _, _, _, _), .store(let rhsPartnerId, let rhsAffilatedId, _, _, _, _)):
        return lhsPartnerId == rhsPartnerId && lhsAffilatedId == rhsAffilatedId
      }
    }
  }

  var title: String? {
    switch kind {
    case .store(_, _, let title, _, _, _):
      return title
    }
  }

  var partnerId: Int {
    switch kind {
    case .store(let partnerId, _, _, _, _, _):
      return partnerId
    }
  }

  var affilatedId: Int {
    switch kind {
    case .store(_, let affilatedId, _, _, _, _):
      return affilatedId
    }
  }

  var shouldCluster: Bool {
    switch kind {
    case .store(_, _, _, _, _, let shouldCluster):
      return shouldCluster
    }
  }

  // This property must be key-value observable, which the `@objc dynamic` attributes provide.
  @objc
  dynamic var coordinate: CLLocationCoordinate2D {
    get {
      switch kind {
      case .store(_, _, _, let latitude, let longitude, _):
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
      }
    }

    set {}
  }

  static func == (lhs: PartnerAnnotationViewModel, rhs: PartnerAnnotationViewModel) -> Bool {
    lhs.isEqual(rhs)
  }

  override func isEqual(_ object: Any?) -> Bool {
    if object is PartnerAnnotationViewModel {
      return (object as! PartnerAnnotationViewModel).kind == kind // swiftlint:disable:this force_cast
    } else {
      return false
    }
  }

  // MARK: Fileprivate

  fileprivate let kind: Kind
}

// MARK: - C

private enum C {
  static let font: UIFont = Font.medium(16)
}

// MARK: - PartnerAnnotationView

final class PartnerAnnotationView: MKAnnotationView, Reusable {

  // MARK: Lifecycle

  override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
    super.init(annotation: annotation, reuseIdentifier: nil)

    canShowCallout = false

    guard let annotation = annotation as? PartnerAnnotationViewModel else {
      return
    }

    let triangleViewWidth: CGFloat = 16
    let triangleViewHeight: CGFloat = 10

    let titleText: String = (annotation.title ?? "")

    titleLabel.text = titleText

    let width = titleText.width(usingFont: C.font)

    frame = .init(
      x: 0,
      y: 0,
      width: width + 16,
      height: titleText.height(forWidth: width, font: C.font) + 8 + triangleViewHeight)

    let triangleView = TriangleView(
      frame: .init(
        x: width / 2,
        y: titleText.height(forWidth: width, font: C.font) + 8,
        width: triangleViewWidth,
        height: triangleViewHeight))
    addSubview(titleLabel)
    addSubview(triangleView)

    titleLabel.layer.cornerRadius = titleText.height(forWidth: width, font: C.font) / 2
    titleLabel.clipsToBounds = true

//    centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) { fatalError() }

  // MARK: Internal

  static var reuseId: String {
    PartnerAnnotationView.description()
  }

  var titleText = String()

  override func layoutSubviews() {
    super.layoutSubviews()
    let width = titleText.width(usingFont: C.font)
    titleLabel.frame = .init(x: bounds.origin.x, y: bounds.origin.y, width: bounds.width, height: titleText.height(forWidth: width, font: C.font) + 8)
    titleLabel.layer.cornerRadius = titleLabel.frame.height / 2
    titleLabel.clipsToBounds = true
  }

  override func willMove(toSuperview newSuperview: UIView?) {
    super.willMove(toSuperview: newSuperview)
    addBounceAnnimation()
  }

  // MARK: Private

  private let titleLabel: UILabel = {
    $0.backgroundColor = .accent
    $0.font = C.font
    $0.textAlignment = .center
    $0.textColor = .white
    return $0
  }(UILabel())

  private func addBounceAnnimation() {
    let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")

    bounceAnimation.values = [NSNumber(value: 0.05), NSNumber(value: 1.1), NSNumber(value: 0.9), NSNumber(value: 1)]
    bounceAnimation.duration = 0.6

    var timingFunctions = [AnyHashable](repeating: 0, count: bounceAnimation.values?.count ?? 0)
    for _ in 0 ..< (bounceAnimation.values?.count ?? 0) {
      timingFunctions.append(CAMediaTimingFunction(name: .easeInEaseOut))
    }
    bounceAnimation.timingFunctions = timingFunctions as? [CAMediaTimingFunction]

    bounceAnimation.isRemovedOnCompletion = false

    layer.add(bounceAnimation, forKey: "bounce")
  }
}

// MARK: - TriangleView

private final class TriangleView: UIView {

  // MARK: Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .clear
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) { fatalError() }

  // MARK: Internal

  override func draw(_ rect: CGRect) {
    backgroundColor = .clear
    guard let context = UIGraphicsGetCurrentContext() else { return }
    context.beginPath()
    context.move(to: CGPoint(x: rect.minX, y: rect.minY))
    context.addLine(to: CGPoint(x: rect.maxX / 2.0, y: rect.maxY))
    context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
    context.closePath()
    context.setFillColor(UIColor.accent.cgColor)
    context.fillPath()
  }
}
