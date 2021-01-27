//
//  PlaceholderTextView.swift
//  Display
//
//  Created by Tatiana Ampilogova on 1/21/21.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit

public class PlaceholderTextView: UITextView {
  
  public var placeholder: String = .init() {
    didSet { placeholderLayer.string = placeholder }
  }
  
  public var placeholderColor = UIColor.blueGray {
    didSet { placeholderLayer.foregroundColor = placeholderColor.cgColor }
  }
  
  public var maxLength: Int? {
    didSet { updateView() }
  }
  
  override public var text: String? {
    didSet { updateView() }
  }
  
  override public var font: UIFont? {
    didSet { updatePlaceholder() }
  }
  
  override public var textContainerInset: UIEdgeInsets {
    didSet { updatePlaceholder() }
  }
  
//  override public var delegate: UITextViewDelegate? {
//    didSet {
//      customDelegate = delegate
//    }
//  }
  
  private lazy var placeholderLayer: CATextLayer = {
    let layer = CATextLayer()
    layer.frame = bounds
    layer.isWrapped = true
    layer.contentsScale = UIScreen.main.scale
    return layer
  }()
  
  public weak var customDelegate: UITextViewDelegate?
  
  override init(frame: CGRect, textContainer: NSTextContainer?) {
    super.init(frame: frame, textContainer: textContainer)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  public override func awakeFromNib() {
    super.awakeFromNib()
    super.delegate = self
  }
  
  override public func layoutSubviews() {
    super.layoutSubviews()
    updateView()
  }
  
  private func setup() {
    super.delegate = self
    textContainer.lineFragmentPadding = .zero
    layer.addSublayer(placeholderLayer)
    updateView()
  }
  
  private func updateView() {
    updateText()
    updatePlaceholder()
  }
  
  private func updateText() {
    if let text = text, let length = maxLength, text.count > length {
      self.text = String(text.prefix(length))
    }
  }
  
  private func updatePlaceholder() {
    guard let font = font else { return }
    
    let width = bounds.width - textContainerInset.bottom
    let height = placeholder.height(forWidth: width, font: font)
    placeholderLayer.frame = CGRect(x: textContainerInset.left,
                                    y: textContainerInset.right,
                                    width: width,
                                    height: height)
    
    placeholderLayer.font = font
    placeholderLayer.fontSize = font.pointSize
    placeholderLayer.isHidden = !(text ?? "" == "")
  }
}

extension PlaceholderTextView: UITextViewDelegate {
  
  public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
    return customDelegate?.textViewShouldBeginEditing?(textView) ?? true
  }
  
  public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
    return customDelegate?.textViewShouldEndEditing?(textView) ?? true
  }
  
  public func textViewDidBeginEditing(_ textView: UITextView) {
    customDelegate?.textViewDidBeginEditing?(textView)
  }
  
  public func textViewDidEndEditing(_ textView: UITextView) {
    customDelegate?.textViewDidEndEditing?(textView)
  }
  
  public func textView(_ textView: UITextView,
                       shouldChangeTextIn range: NSRange,
                       replacementText text: String) -> Bool {
    return customDelegate?.textView?(textView,
                                     shouldChangeTextIn: range,
                                     replacementText: text) ?? true
  }
  
  override public func shouldChangeText(in range: UITextRange, replacementText text: String) -> Bool {
    return true
  }
  
  public func textViewDidChange(_ textView: UITextView) {
    updateView()
    customDelegate?.textViewDidChange?(textView)
  }
  
  public func textViewDidChangeSelection(_ textView: UITextView) {
    customDelegate?.textViewDidChangeSelection?(textView)
  }
  
  public func textView(_ textView: UITextView,shouldInteractWith URL: URL,
                       in characterRange: NSRange,
                       interaction: UITextItemInteraction) -> Bool {
    return customDelegate?.textView?(textView,
                                     shouldInteractWith: URL,
                                     in: characterRange,
                                     interaction: interaction) ?? true
  }
  
  public func textView(_ textView: UITextView,
                       shouldInteractWith textAttachment: NSTextAttachment,
                       in characterRange: NSRange,
                       interaction: UITextItemInteraction) -> Bool {
    return customDelegate?.textView?(textView,
                                     shouldInteractWith: textAttachment,
                                     in: characterRange,
                                     interaction: interaction) ?? true
  }
}
