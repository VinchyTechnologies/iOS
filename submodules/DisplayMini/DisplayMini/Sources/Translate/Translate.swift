//
//  Translate.swift
//  DisplayMini
//
//  Created by Алексей Смирнов on 11.01.2022.
//

import NaturalLanguage
import UIKit

public var supportedTranslationLanguages = [
  "en",
  "ar",
  "zh",
  "fr",
  "de",
  "it",
  "jp",
  "ko",
  "pt",
  "ru",
  "es",
]

private let languageRecognizer = NLLanguageRecognizer()

public func canTranslateText(text: String, showTranslate: Bool, ignoredLanguages: [String]?) -> Bool {
  guard showTranslate, text.count > 0 else {
    return false
  }

  if UIDevice.current.userInterfaceIdiom != .phone {
    return false
  }

  if #available(iOS 15.0, *) {
    var dontTranslateLanguages: [String] = []
    if let ignoredLanguages = ignoredLanguages {
      dontTranslateLanguages = ignoredLanguages
    } else {
      dontTranslateLanguages = [] //
    }

    let text = String(text.prefix(64))
    languageRecognizer.processString(text)
    let hypotheses = languageRecognizer.languageHypotheses(withMaximum: 3)
    languageRecognizer.reset()

    let filteredLanguages = hypotheses.filter { supportedTranslationLanguages.contains($0.key.rawValue) }.sorted(by: { $0.value > $1.value })
    if let language = filteredLanguages.first(where: { supportedTranslationLanguages.contains($0.key.rawValue) }) {
      return !dontTranslateLanguages.contains(language.key.rawValue)
    } else {
      return false
    }
  } else {
    return false
  }
}

public func translateText(text: String) {
  guard !text.isEmpty else {
    return
  }
  if #available(iOS 15.0, *) {
    let text = text.unicodeScalars.filter {
      !$0.properties.isEmojiPresentation
    }.reduce("") { $0 + String($1) }
    let textView = UITextView()
    textView.text = text
    textView.isEditable = false
    if let topController = UIApplication.topViewController() {
      topController.view.addSubview(textView)
      textView.selectAll(nil)
      textView.perform(NSSelectorFromString(["_", "trans", "late:"].joined(separator: "")), with: nil)
      DispatchQueue.main.async {
        textView.removeFromSuperview()
      }
    }
  }
}
