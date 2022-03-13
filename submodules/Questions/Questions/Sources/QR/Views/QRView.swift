//
//  QRView.swift
//  Questions
//
//  Created by Алексей Смирнов on 13.03.2022.
//

import EpoxyCore

final class QRView: UIView, EpoxyableView {

  // MARK: Lifecycle

  init(style: Style) {
    super.init(frame: .zero)

    addSubview(imageView)
    imageView.layer.cornerRadius = 4
    imageView.clipsToBounds = true
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.constrainToMargins()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  struct Style: Hashable {

  }

  struct Content: Equatable {
    let text: String
  }

  func setContent(_ content: Content, animated: Bool) {
    imageView.image = generateQRCode(from: content.text)
  }

  // MARK: Private

  private let imageView = UIImageView()

  private func generateQRCode(from string: String) -> UIImage? {
    let data = string.data(using: String.Encoding.ascii)
    if let filter = CIFilter(name: "CIQRCodeGenerator") {
      filter.setValue(data, forKey: "inputMessage")
      let transform = CGAffineTransform(scaleX: 3, y: 3)

      if let output = filter.outputImage?.transformed(by: transform) {
        return UIImage(ciImage: output)
      }
    }

    return nil
  }
}
