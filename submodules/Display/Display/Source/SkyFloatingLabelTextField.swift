// swiftlint:disable all

import UIKit

// MARK: - ErrorMessagePlacement

/**
 An enum for the possible error label placements.
 .default is the standard (on top) position; the error message is displayed in the `titleLabel`.
 .bottom displays the error below the text field in a dedicated `errorLabel`.
 */
public enum ErrorMessagePlacement {
  case `default`
  case bottom
}

// MARK: - SkyFloatingLabelTextField

/**
 A beautiful and flexible textfield implementation with support for title label, error message and placeholder.
 */
@IBDesignable
open class SkyFloatingLabelTextField: UITextField {

  // MARK: Lifecycle

  // MARK: - Initializers

  /**
   Initializes the control
   - parameter frame the frame of the control
   */
  override public init(frame: CGRect) {
    super.init(frame: frame)
    init_SkyFloatingLabelTextField()
  }

  /**
   Intialzies the control by deserializing it
   - parameter aDecoder the object to deserialize the control from
   */
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    init_SkyFloatingLabelTextField()
  }

  // MARK: Open

  // MARK: Animation timing

  /// The value of the title appearing duration
  @objc open dynamic var titleFadeInDuration: TimeInterval = 0.2
  /// The value of the title disappearing duration
  @objc open dynamic var titleFadeOutDuration: TimeInterval = 0.3

  // MARK: View components

  /// The internal `UIView` to display the line below the text input.
  open var lineView: UIView!

  /// The internal `UILabel` that displays the selected, deselected title or error message based on the current state.
  open var titleLabel: UILabel!

  /// The internal `UILabel` that displays error messsage if `errorMessagePlacement` is `.bottom`.
  open var errorLabel: UILabel!

  // MARK: Properties

  /**
   The formatter used before displaying content in the title label.
   This can be the `title`, `selectedTitle` or the `errorMessage`.
   The default implementation converts the text to uppercase.
   */
  open var titleFormatter: ((String) -> String) = { (text: String) -> String in
    if #available(iOS 9.0, *) {
      return text.localizedUppercase
    } else {
      return text.uppercased()
    }
  }

  // swiftlint:disable:this type_body_length
  /**
   A Boolean value that determines if the language displayed is LTR.
   Default value set automatically from the application language settings.
   */
  @objc open var isLTRLanguage: Bool = UIApplication.shared.userInterfaceLayoutDirection == .leftToRight {
    didSet {
      updateTextAligment()
    }
  }

  /// A UIColor value that determines the text color of the editable text
  @IBInspectable
  override open dynamic var textColor: UIColor? {
    set {
      cachedTextColor = newValue
      updateControl(false)
    }
    get {
      cachedTextColor
    }
  }

  /// A UIColor value that determines text color of the placeholder label
  @IBInspectable open dynamic var placeholderColor = UIColor.lightGray {
    didSet {
      updatePlaceholder()
    }
  }

  /// A UIFont value that determines text color of the placeholder label
  @objc open dynamic var placeholderFont: UIFont? {
    didSet {
      updatePlaceholder()
    }
  }

  /// A `ErrorMessagePlacement` value that determines where the error message will be displayed.
  open var errorMessagePlacement: ErrorMessagePlacement = .default {
    didSet {
      updateControl()
      updatePlaceholder()
    }
  }

  /// An `NSTextAlignment` value that determines the error label text alignment.
  open var errorLabelAlignment: NSTextAlignment? {
    didSet {
      updateTextAligment()
    }
  }

  /// A UIFont value that determines the text font of the title label
  @objc open dynamic var titleFont: UIFont = .systemFont(ofSize: 13) {
    didSet {
      updateTitleLabel()
    }
  }

  /// A UIColor value that determines the text color of the title label when in the normal state
  @IBInspectable open dynamic var titleColor: UIColor = .gray {
    didSet {
      updateTitleColor()
    }
  }

  /// A UIColor value that determines the color of the bottom line when in the normal state
  @IBInspectable open dynamic var lineColor: UIColor = .lightGray {
    didSet {
      updateLineView()
    }
  }

  /// A UIColor value that determines the color used for the label displaying the error message
  @IBInspectable open dynamic var errorColor: UIColor = .red {
    didSet {
      updateColors()
    }
  }

  /// A UIColor value that determines the color used for the line when error message is not `nil`
  @IBInspectable open dynamic var lineErrorColor: UIColor? {
    didSet {
      updateColors()
    }
  }

  /// A UIColor value that determines the color used for the text when error message is not `nil`
  @IBInspectable open dynamic var textErrorColor: UIColor? {
    didSet {
      updateColors()
    }
  }

  /// A UIColor value that determines the color used for the title label when error message is not `nil`
  @IBInspectable open dynamic var titleErrorColor: UIColor? {
    didSet {
      updateColors()
    }
  }

  /// A UIColor value that determines the color used for the title label and line when text field is disabled
  @IBInspectable open dynamic var disabledColor = UIColor(white: 0.88, alpha: 1.0) {
    didSet {
      updateControl()
      updatePlaceholder()
    }
  }

  /// A UIColor value that determines the text color of the title label when editing
  @IBInspectable open dynamic var selectedTitleColor: UIColor = .blue {
    didSet {
      updateTitleColor()
    }
  }

  /// A UIColor value that determines the color of the line in a selected state
  @IBInspectable open dynamic var selectedLineColor: UIColor = .black {
    didSet {
      updateLineView()
    }
  }

  // MARK: Line height

  /// A CGFloat value that determines the height for the bottom line when the control is in the normal state
  @IBInspectable open dynamic var lineHeight: CGFloat = 0.5 {
    didSet {
      updateLineView()
      setNeedsDisplay()
    }
  }

  /// A CGFloat value that determines the height for the bottom line when the control is in a selected state
  @IBInspectable open dynamic var selectedLineHeight: CGFloat = 1.0 {
    didSet {
      updateLineView()
      setNeedsDisplay()
    }
  }

  /**
   Identifies whether the text object should hide the text being entered.
   */
  override open var isSecureTextEntry: Bool {
    set {
      super.isSecureTextEntry = newValue
      fixCaretPosition()
    }
    get {
      super.isSecureTextEntry
    }
  }

  /// A String value for the error message to display.
  @IBInspectable
  open var errorMessage: String? {
    didSet {
      updateControl(true)
    }
  }

  /**
   A Boolean value that determines whether the receiver is highlighted.
   When changing this value, highlighting will be done with animation
   */
  override open var isHighlighted: Bool {
    get {
      _highlighted
    }
    set {
      _highlighted = newValue
      updateTitleColor()
      updateLineView()
    }
  }

  /// A Boolean value that determines whether the textfield is being edited or is selected.
  open var editingOrSelected: Bool {
    super.isEditing || isSelected
  }

  /// A Boolean value that determines whether the receiver has an error message.
  open var hasErrorMessage: Bool {
    errorMessage != nil && errorMessage != ""
  }

  /// The text content of the textfield
  @IBInspectable
  override open var text: String? {
    didSet {
      updateControl(false)
    }
  }

  /**
   The String to display when the input field is empty.
   The placeholder can also appear in the title label when both `title` `selectedTitle` and are `nil`.
   */
  @IBInspectable
  override open var placeholder: String? {
    didSet {
      setNeedsDisplay()
      updatePlaceholder()
      updateTitleLabel()
    }
  }

  /// The String to display when the textfield is editing and the input is not empty.
  @IBInspectable open var selectedTitle: String? {
    didSet {
      updateControl()
    }
  }

  /// The String to display when the textfield is not editing and the input is not empty.
  @IBInspectable open var title: String? {
    didSet {
      updateControl()
    }
  }

  // Determines whether the field is selected. When selected, the title floats above the textbox.
  override open var isSelected: Bool {
    didSet {
      updateControl(true)
    }
  }

  /// update colors when is enabled changed
  override open var isEnabled: Bool {
    didSet {
      updateControl()
      updatePlaceholder()
    }
  }

  /**
   Calculate the content size for auto layout
   - returns: the content size to be used for auto layout
   */
  override open var intrinsicContentSize: CGSize {
    if errorMessagePlacement == .bottom {
      return CGSize(width: bounds.size.width, height: titleHeight() + textHeight() + errorHeight())
    } else {
      return CGSize(width: bounds.size.width, height: titleHeight() + textHeight())
    }
  }

  /**
   Invoked when the editing state of the textfield changes. Override to respond to this change.
   */
  @objc
  open func editingChanged() {
    updateControl(true)
    updateTitleLabel(true)
  }

  // MARK: Responder handling

  /**
    Attempt the control to become the first responder
    - returns: True when successfull becoming the first responder
   */
  @discardableResult
  override open func becomeFirstResponder() -> Bool {
    let result = super.becomeFirstResponder()
    updateControl(true)
    return result
  }

  /**
   Attempt the control to resign being the first responder
   - returns: True when successfull resigning being the first responder
   */
  @discardableResult
  override open func resignFirstResponder() -> Bool {
    let result = super.resignFirstResponder()
    updateControl(true)
    return result
  }

  // MARK: - Color updates

  /// Update the colors for the control. Override to customize colors.
  open func updateColors() {
    updateLineColor()
    updateTitleColor()
    updateTextColor()
    updateErrorLabelColor()
  }

  /*
   *   Set this value to make the title visible
   */
  open func setTitleVisible(
    _ titleVisible: Bool,
    animated: Bool = false,
    animationCompletion: ((_ completed: Bool) -> Void)? = nil)
  {
    if _titleVisible == titleVisible {
      return
    }
    _titleVisible = titleVisible
    updateTitleColor()
    updateTitleVisibility(animated, completion: animationCompletion)
  }

  /**
   Returns whether the title is being displayed on the control.
   - returns: True if the title is displayed on the control, false otherwise.
   */
  open func isTitleVisible() -> Bool {
    if errorMessagePlacement == .default {
      return hasText || hasErrorMessage || _titleVisible
    } else {
      return hasText || _titleVisible
    }
  }

  open func isErrorVisible() -> Bool {
    hasErrorMessage
  }

  // MARK: - UITextField text/placeholder positioning overrides

  /**
   Calculate the rectangle for the textfield when it is not being edited
   - parameter bounds: The current bounds of the field
   - returns: The rectangle that the textfield should render in
   */
  override open func textRect(forBounds bounds: CGRect) -> CGRect {
    let superRect = super.textRect(forBounds: bounds)
    let titleHeight = self.titleHeight()
    var height = superRect.size.height - titleHeight - selectedLineHeight
    if errorMessagePlacement == .bottom {
      height -= errorHeight()
    }
    let rect = CGRect(
      x: superRect.origin.x,
      y: titleHeight,
      width: superRect.size.width,
      height: height)
    return rect
  }

  /**
   Calculate the rectangle for the textfield when it is being edited
   - parameter bounds: The current bounds of the field
   - returns: The rectangle that the textfield should render in
   */
  override open func editingRect(forBounds bounds: CGRect) -> CGRect {
    let superRect = super.editingRect(forBounds: bounds)
    let titleHeight = self.titleHeight()

    var height = superRect.size.height - titleHeight - selectedLineHeight
    if errorMessagePlacement == .bottom {
      height -= errorHeight()
    }

    let rect = CGRect(
      x: superRect.origin.x,
      y: titleHeight,
      width: superRect.size.width,
      height: height)
    return rect
  }

  /**
   Calculate the rectangle for the placeholder
   - parameter bounds: The current bounds of the placeholder
   - returns: The rectangle that the placeholder should render in
   */
  override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    var height = bounds.size.height - titleHeight() - selectedLineHeight
    if errorMessagePlacement == .bottom {
      height -= errorHeight()
    }
    let rect = CGRect(
      x: 0,
      y: titleHeight(),
      width: bounds.size.width,
      height: height)
    return rect
  }

  // MARK: - Positioning Overrides

  /**
   Calculate the bounds for the title label. Override to create a custom size title field.
   - parameter bounds: The current bounds of the title
   - parameter editing: True if the control is selected or highlighted
   - returns: The rectangle that the title label should render in
   */
  open func titleLabelRectForBounds(_ bounds: CGRect, editing: Bool) -> CGRect {
    if editing {
      return CGRect(x: 0, y: 0, width: bounds.size.width, height: titleHeight())
    }
    return CGRect(x: 0, y: titleHeight(), width: bounds.size.width, height: titleHeight())
  }

  /**
   Calculate the bounds for the error label. Override to create a custom size error field.
   - parameter bounds: The current bounds of the title
   - parameter editing: True if the control is selected or highlighted
   - returns: The rectangle that the title label should render in
   */
  open func errorLabelRectForBounds(_ bounds: CGRect, editing: Bool) -> CGRect {
    if errorMessagePlacement == .default {
      return CGRect.zero
    } else {
      let lineRect = lineViewRectForBounds(bounds, editing: editing)
      if editing {
        let originY = lineRect.origin.y + selectedLineHeight
        return CGRect(x: 0, y: originY, width: bounds.size.width, height: errorHeight())
      }
      let originY = lineRect.origin.y + selectedLineHeight + errorHeight()
      return CGRect(x: 0, y: originY, width: bounds.size.width, height: errorHeight())
    }
  }

  /**
   Calculate the bounds for the bottom line of the control.
   Override to create a custom size bottom line in the textbox.
   - parameter bounds: The current bounds of the line
   - parameter editing: True if the control is selected or highlighted
   - returns: The rectangle that the line bar should render in
   */
  open func lineViewRectForBounds(_ bounds: CGRect, editing: Bool) -> CGRect {
    let height = editing ? selectedLineHeight : lineHeight
    if errorMessagePlacement == .bottom {
      return CGRect(x: 0, y: textRect(forBounds: bounds).maxY, width: bounds.size.width, height: height)
    } else {
      return CGRect(x: 0, y: bounds.size.height - height, width: bounds.size.width, height: height)
    }
  }

  /**
   Calculate the height of the title label.
   -returns: the calculated height of the title label. Override to size the title with a different height
   */
  open func titleHeight() -> CGFloat {
    if
      let titleLabel = titleLabel,
      let font = titleLabel.font
    {
      return font.lineHeight
    }
    return 15.0
  }

  /**
   Calculate the height of the error label.
   -returns: the calculated height of the error label. Override to size the error with a different height
   */
  open func errorHeight() -> CGFloat {
    if
      let errorLabel = errorLabel,
      let font = errorLabel.font
    {
      return font.lineHeight
    }
    return 15.0
  }

  /**
   Calculate the height of the textfield.
   -returns: the calculated height of the textfield. Override to size the textfield with a different height
   */
  open func textHeight() -> CGFloat {
    guard let font = self.font else {
      return 0.0
    }

    return font.lineHeight + 7.0
  }

  // MARK: - Layout

  /// Invoked when the interface builder renders the control
  override open func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()

    borderStyle = .none

    isSelected = true
    _renderingInInterfaceBuilder = true
    updateControl(false)
    invalidateIntrinsicContentSize()
  }

  /// Invoked by layoutIfNeeded automatically
  override open func layoutSubviews() {
    super.layoutSubviews()

    titleLabel.frame = titleLabelRectForBounds(bounds, editing: isTitleVisible() || _renderingInInterfaceBuilder)
    errorLabel.frame = errorLabelRectForBounds(bounds, editing: isErrorVisible() || _renderingInInterfaceBuilder)
    lineView.frame = lineViewRectForBounds(bounds, editing: editingOrSelected || _renderingInInterfaceBuilder)
  }

  // MARK: Fileprivate

  // MARK: Colors

  fileprivate var cachedTextColor: UIColor?

  /// The backing property for the highlighted property
  fileprivate var _highlighted: Bool = false

  fileprivate var _renderingInInterfaceBuilder: Bool = false

  fileprivate var _titleVisible: Bool = false

  fileprivate func updateTextAligment() {
    if isLTRLanguage {
      textAlignment = .left
      titleLabel.textAlignment = .left
      errorLabel.textAlignment = .left
    } else {
      textAlignment = .right
      titleLabel.textAlignment = .right
      errorLabel.textAlignment = .right
    }

    // Override error message default alignment
    if let errorLabelAlignment = errorLabelAlignment {
      errorLabel.textAlignment = errorLabelAlignment
    }
  }

  fileprivate func updatePlaceholder() {
    guard let placeholder = placeholder, let font = placeholderFont ?? font else {
      return
    }
    let color = isEnabled ? placeholderColor : disabledColor
    #if swift(>=4.2)
    attributedPlaceholder = NSAttributedString(
      string: placeholder,
      attributes: [
        NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: font,
      ])
    #elseif swift(>=4.0)
    attributedPlaceholder = NSAttributedString(
      string: placeholder,
      attributes: [
        NSAttributedStringKey.foregroundColor: color, NSAttributedStringKey.font: font,
      ])
    #else
    attributedPlaceholder = NSAttributedString(
      string: placeholder,
      attributes: [NSForegroundColorAttributeName: color, NSFontAttributeName: font])
    #endif
  }

  fileprivate final func init_SkyFloatingLabelTextField() {
    borderStyle = .none
    createTitleLabel()
    createLineView()
    createErrorLabel()
    updateColors()
    addEditingChangedObserver()
    updateTextAligment()
  }

  fileprivate func addEditingChangedObserver() {
    addTarget(self, action: #selector(SkyFloatingLabelTextField.editingChanged), for: .editingChanged)
  }

  // MARK: create components

  fileprivate func createTitleLabel() {
    let titleLabel = UILabel()
    titleLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    titleLabel.font = titleFont
    titleLabel.alpha = 0.0
    titleLabel.textColor = titleColor

    addSubview(titleLabel)
    self.titleLabel = titleLabel
  }

  fileprivate func createErrorLabel() {
    let errorLabel = UILabel()
    errorLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    errorLabel.font = titleFont
    errorLabel.alpha = 0.0
    errorLabel.textColor = errorColor

    addSubview(errorLabel)
    self.errorLabel = errorLabel
  }

  fileprivate func createLineView() {
    if lineView == nil {
      let lineView = UIView()
      lineView.isUserInteractionEnabled = false
      self.lineView = lineView
      configureDefaultLineHeight()
    }

    lineView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
    addSubview(lineView)
  }

  fileprivate func configureDefaultLineHeight() {
    let onePixel: CGFloat = 1.0 / UIScreen.main.scale
    lineHeight = 2.0 * onePixel
    selectedLineHeight = 2.0 * lineHeight
  }

  // MARK: - View updates

  fileprivate func updateControl(_ animated: Bool = false) {
    updateColors()
    updateLineView()
    updateTitleLabel(animated)
  }

  fileprivate func updateLineView() {
    guard let lineView = lineView else {
      return
    }

    lineView.frame = lineViewRectForBounds(bounds, editing: editingOrSelected)
    updateLineColor()
  }

  fileprivate func updateErrorLabelColor() {
    errorLabel.textColor = errorColor
  }

  fileprivate func updateLineColor() {
    guard let lineView = lineView else {
      return
    }

    if !isEnabled {
      lineView.backgroundColor = disabledColor
    } else if hasErrorMessage {
      lineView.backgroundColor = lineErrorColor ?? errorColor
    } else {
      lineView.backgroundColor = editingOrSelected ? selectedLineColor : lineColor
    }
  }

  fileprivate func updateTitleColor() {
    guard let titleLabel = titleLabel else {
      return
    }

    if !isEnabled {
      titleLabel.textColor = disabledColor
    } else if hasErrorMessage, errorMessagePlacement == .default {
      titleLabel.textColor = titleErrorColor ?? errorColor
    } else {
      if editingOrSelected || isHighlighted {
        titleLabel.textColor = selectedTitleColor
      } else {
        titleLabel.textColor = titleColor
      }
    }
  }

  fileprivate func updateTextColor() {
    if !isEnabled {
      super.textColor = disabledColor
    } else if hasErrorMessage {
      super.textColor = textErrorColor ?? errorColor
    } else {
      super.textColor = cachedTextColor
    }
  }

  // MARK: - Title handling

  fileprivate func updateTitleLabel(_ animated: Bool = false) {
    guard let titleLabel = titleLabel else {
      return
    }

    var titleText: String?
    var errorText: String?

    if errorMessagePlacement == .default {
      if hasErrorMessage {
        titleText = titleFormatter(errorMessage!)
      } else {
        if editingOrSelected {
          titleText = selectedTitleOrTitlePlaceholder()
          if titleText == nil {
            titleText = titleOrPlaceholder()
          }
        } else {
          titleText = titleOrPlaceholder()
        }
      }
    } else {
      if hasErrorMessage {
        errorText = titleFormatter(errorMessage!)
      }
      if editingOrSelected {
        titleText = selectedTitleOrTitlePlaceholder()
        if titleText == nil {
          titleText = titleOrPlaceholder()
        }
      } else {
        titleText = titleOrPlaceholder()
      }
    }
    titleLabel.text = titleText
    titleLabel.font = titleFont

    errorLabel.text = errorText
    errorLabel.font = titleFont
    updateTitleVisibility(animated)
    updateErrorVisibility(animated)
  }

  fileprivate func updateTitleVisibility(_ animated: Bool = false, completion: ((_ completed: Bool) -> Void)? = nil) {
    let alpha: CGFloat = isTitleVisible() ? 1.0 : 0.0
    let frame: CGRect = titleLabelRectForBounds(bounds, editing: isTitleVisible())
    let updateBlock = { () -> Void in
      self.titleLabel.alpha = alpha
      self.titleLabel.frame = frame
    }
    if animated {
      #if swift(>=4.2)
      let animationOptions: UIView.AnimationOptions = .curveEaseOut
      #else
      let animationOptions: UIViewAnimationOptions = .curveEaseOut
      #endif
      let duration = isTitleVisible() ? titleFadeInDuration : titleFadeOutDuration
      UIView.animate(withDuration: duration, delay: 0, options: animationOptions, animations: { () -> Void in
        updateBlock()
      }, completion: completion)
    } else {
      updateBlock()
      completion?(true)
    }
  }

  fileprivate func updateErrorVisibility(_ animated: Bool = false, completion: ((_ completed: Bool) -> Void)? = nil) {
    let alpha: CGFloat = isErrorVisible() ? 1.0 : 0.0
    let frame: CGRect = errorLabelRectForBounds(bounds, editing: isErrorVisible())
    let updateBlock = { () -> Void in
      self.errorLabel.alpha = alpha
      self.errorLabel.frame = frame
    }
    if animated {
      #if swift(>=4.2)
      let animationOptions: UIView.AnimationOptions = .curveEaseOut
      #else
      let animationOptions: UIViewAnimationOptions = .curveEaseOut
      #endif
      let duration = isErrorVisible() ? titleFadeInDuration : titleFadeOutDuration
      UIView.animate(withDuration: duration, delay: 0, options: animationOptions, animations: { () -> Void in
        updateBlock()
      }, completion: completion)
    } else {
      updateBlock()
      completion?(true)
    }
  }

  // MARK: - Helpers

  fileprivate func titleOrPlaceholder() -> String? {
    guard let title = title ?? placeholder else {
      return nil
    }
    return titleFormatter(title)
  }

  fileprivate func selectedTitleOrTitlePlaceholder() -> String? {
    guard let title = selectedTitle ?? title ?? placeholder else {
      return nil
    }
    return titleFormatter(title)
  }
} // swiftlint:disable:this file_length

// MARK: - IconType

/**
 Identify the type of icon.
    - font: Set your icon by setting the font of iconLabel
    - image: Set your icon by setting the image of iconImageView
 */
public enum IconType: Int {
  case font
  case image
}

// MARK: - SkyFloatingLabelTextFieldWithIcon

/**
 A beautiful and flexible textfield implementation with support for icon, title label, error message and placeholder.
 */
open class SkyFloatingLabelTextFieldWithIcon: SkyFloatingLabelTextField {

  // MARK: Lifecycle

  // MARK: Initializers

  /**
   Initializes the control
   - parameter type the type of icon
   */
  public convenience init(frame: CGRect, iconType: IconType) {
    self.init(frame: frame)
    self.iconType = iconType
    updateIconViewHiddenState()
  }

  /**
   Initializes the control
   - parameter frame the frame of the control
   */
  override public init(frame: CGRect) {
    super.init(frame: frame)
    createIcon()
    updateIconViewHiddenState()
  }

  /**
   Intialzies the control by deserializing it
   - parameter aDecoder the object to deserialize the control from
   */
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    createIcon()
    updateIconViewHiddenState()
  }

  // MARK: Open

  /// A UIImageView value that identifies the view used to display the icon
  open var iconImageView: UIImageView!

  /// A UILabel value that identifies the label used to display the icon
  open var iconLabel: UILabel!

  open var iconType: IconType = .font {
    didSet {
      updateIconViewHiddenState()
    }
  }

  /// A UIImage value that determines the image that the icon is using
  @IBInspectable
  open dynamic var iconImage: UIImage? {
    didSet {
      // Show a warning if setting an image while the iconType is IconType.font
      if iconType == .font { NSLog("WARNING - Did set iconImage when the iconType is set to IconType.font. The image will not be displayed.") } // swiftlint:disable:this line_length
      iconImageView?.image = iconImage
    }
  }

  /// A Bool value that determines if the UIImage should be templated or not
  @IBInspectable
  open dynamic var templateImage: Bool = true {
    didSet {
      if templateImage {
        let templatedOriginalImage = iconImageView.image?
          .withRenderingMode(.alwaysTemplate)
        iconImageView.image = templatedOriginalImage
      }
    }
  }

  /// A UIFont value that determines the font that the icon is using
  @objc open dynamic var iconFont: UIFont? {
    didSet {
      iconLabel?.font = iconFont
    }
  }

  /// A String value that determines the text used when displaying the icon
  @IBInspectable
  open var iconText: String? {
    didSet {
      // Show a warning if setting an icon text while the iconType is IconType.image
      if iconType == .image { NSLog("WARNING - Did set iconText when the iconType is set to IconType.image. The icon with the specified text will not be displayed.") } // swiftlint:disable:this line_length
      iconLabel?.text = iconText
    }
  }

  /// A UIColor value that determines the color of the icon in the normal state
  @IBInspectable
  open dynamic var iconColor = UIColor.gray {
    didSet {
      if iconType == .font {
        updateIconLabelColor()
      }
      if iconType == .image, templateImage {
        updateImageViewTintColor()
      }
    }
  }

  /// A UIColor value that determines the color of the icon when the control is selected
  @IBInspectable
  open dynamic var selectedIconColor = UIColor.gray {
    didSet {
      updateIconLabelColor()
    }
  }

  /// A float value that determines the width of the icon
  @IBInspectable
  open dynamic var iconWidth: CGFloat = 20 {
    didSet {
      updateFrame()
    }
  }

  /**
   A float value that determines the left margin of the icon.
   Use this value to position the icon more precisely horizontally.
   */
  @IBInspectable
  open dynamic var iconMarginLeft: CGFloat = 4 {
    didSet {
      updateFrame()
    }
  }

  /**
   A float value that determines the bottom margin of the icon.
   Use this value to position the icon more precisely vertically.
   */
  @IBInspectable
  open dynamic var iconMarginBottom: CGFloat = 4 {
    didSet {
      updateFrame()
    }
  }

  /**
   A float value that determines the rotation in degrees of the icon.
   Use this value to rotate the icon in either direction.
   */
  @IBInspectable
  open var iconRotationDegrees: Double = 0 {
    didSet {
      iconLabel.transform = CGAffineTransform(rotationAngle: CGFloat(iconRotationDegrees * .pi / 180.0))
      iconImageView.transform = CGAffineTransform(rotationAngle: CGFloat(iconRotationDegrees * .pi / 180.0))
    }
  }

  // MARK: Handling the icon color

  /// Update the colors for the control. Override to customize colors.
  override open func updateColors() {
    super.updateColors()
    if iconType == .font {
      updateIconLabelColor()
    }
    if iconType == .image, templateImage {
      updateImageViewTintColor()
    }
  }

  // MARK: Custom layout overrides

  /**
    Calculate the bounds for the textfield component of the control.
    Override to create a custom size textbox in the control.
    - parameter bounds: The current bounds of the textfield component
    - returns: The rectangle that the textfield component should render in
   */
  override open func textRect(forBounds bounds: CGRect) -> CGRect {
    var rect = super.textRect(forBounds: bounds)
    if isLTRLanguage {
      rect.origin.x += CGFloat(iconWidth + iconMarginLeft)
    } else {
      rect.origin.x -= CGFloat(iconWidth + iconMarginLeft)
    }
    rect.size.width -= CGFloat(iconWidth + iconMarginLeft)
    return rect
  }

  /**
   Calculate the rectangle for the textfield when it is being edited
   - parameter bounds: The current bounds of the field
   - returns: The rectangle that the textfield should render in
   */
  override open func editingRect(forBounds bounds: CGRect) -> CGRect {
    var rect = super.editingRect(forBounds: bounds)
    if isLTRLanguage {
      rect.origin.x += CGFloat(iconWidth + iconMarginLeft)
    } else {
      // don't change the editing field X position for RTL languages
    }
    rect.size.width -= CGFloat(iconWidth + iconMarginLeft)
    return rect
  }

  /**
   Calculates the bounds for the placeholder component of the control.
   Override to create a custom size textbox in the control.
   - parameter bounds: The current bounds of the placeholder component
   - returns: The rectangle that the placeholder component should render in
   */
  override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    var rect = super.placeholderRect(forBounds: bounds)
    if isLTRLanguage {
      rect.origin.x += CGFloat(iconWidth + iconMarginLeft)
    } else {
      // don't change the editing field X position for RTL languages
    }
    rect.size.width -= CGFloat(iconWidth + iconMarginLeft)
    return rect
  }

  /// Invoked by layoutIfNeeded automatically
  override open func layoutSubviews() {
    super.layoutSubviews()
    updateFrame()
  }

  // MARK: Internal

  @IBInspectable
  var iconTypeValue: Int {
    get {
      iconType.rawValue
    }

    set(iconIndex) {
      iconType = IconType(rawValue: iconIndex) ?? .font
    }
  }

  // MARK: Fileprivate

  // MARK: Creating the icon

  /// Creates the both icon label and icon image view
  fileprivate func createIcon() {
    createIconLabel()
    createIconImageView()
  }

  // MARK: Creating the icon label

  /// Creates the icon label
  fileprivate func createIconLabel() {
    let iconLabel = UILabel()
    iconLabel.backgroundColor = UIColor.clear
    iconLabel.textAlignment = .center
    iconLabel.autoresizingMask = [.flexibleTopMargin, .flexibleRightMargin]
    self.iconLabel = iconLabel
    addSubview(iconLabel)
    updateIconLabelColor()
  }

  // MARK: Creating the icon image view

  /// Creates the icon image view
  fileprivate func createIconImageView() {
    let iconImageView = UIImageView()
    iconImageView.backgroundColor = .clear
    iconImageView.contentMode = .scaleAspectFit
    iconImageView.autoresizingMask = [.flexibleTopMargin, .flexibleRightMargin]
    self.iconImageView = iconImageView
    templateImage = true
    addSubview(iconImageView)
  }

  // MARK: Set icon hidden property

  /// Shows the corresponding icon depending on iconType property
  fileprivate func updateIconViewHiddenState() {
    switch iconType {
    case .font:
      iconLabel.isHidden = false
      iconImageView.isHidden = true
    case .image:
      iconLabel.isHidden = true
      iconImageView.isHidden = false
    }
  }

  fileprivate func updateImageViewTintColor() {
    if !isEnabled {
      iconImageView.tintColor = disabledColor
    } else if hasErrorMessage {
      iconImageView.tintColor = errorColor
    } else {
      iconImageView.tintColor = editingOrSelected ? selectedIconColor : iconColor
    }
  }

  fileprivate func updateIconLabelColor() {
    if !isEnabled {
      iconLabel?.textColor = disabledColor
    } else if hasErrorMessage {
      iconLabel?.textColor = errorColor
    } else {
      iconLabel?.textColor = editingOrSelected ? selectedIconColor : iconColor
    }
  }

  fileprivate func updateFrame() {
    let textWidth: CGFloat = bounds.size.width
    if isLTRLanguage {
      iconLabel.frame = CGRect(
        x: 0,
        y: bounds.size.height - textHeight() - iconMarginBottom,
        width: iconWidth,
        height: textHeight())
      iconImageView.frame = CGRect(
        x: 0,
        y: bounds.size.height - textHeight() - iconMarginBottom,
        width: iconWidth,
        height: textHeight())
    } else {
      iconLabel.frame = CGRect(
        x: textWidth - iconWidth,
        y: bounds.size.height - textHeight() - iconMarginBottom,
        width: iconWidth,
        height: textHeight())
      iconImageView.frame = CGRect(
        x: textWidth - iconWidth,
        y: bounds.size.height - textHeight() - iconMarginBottom,
        width: iconWidth,
        height: textHeight())
    }
  }
}

extension UITextField {
  /// Moves the caret to the correct position by removing the trailing whitespace
  func fixCaretPosition() {
    // Moving the caret to the correct position by removing the trailing whitespace
    // http://stackoverflow.com/questions/14220187/uitextfield-has-trailing-whitespace-after-securetextentry-toggle
    let beginning = beginningOfDocument
    selectedTextRange = textRange(from: beginning, to: beginning)
    let end = endOfDocument
    selectedTextRange = textRange(from: end, to: end)
  }
}
// swiftlint:disable all
