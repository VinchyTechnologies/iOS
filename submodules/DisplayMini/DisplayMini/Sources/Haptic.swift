//
//  Haptic.swift
//  Display
//
//  Created by Aleksei Smirnov on 20.11.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import AudioToolbox
import CoreHaptics
import UIKit

// MARK: - Constants

fileprivate enum Constants {
  static let vibrationSoundId: SystemSoundID = 1519
}

// MARK: - HapticEffect

public enum HapticEffect: Int {
  case error
  case success
  case warning
  case light
  case medium
  case heavy
  case selection

  // MARK: Public

  public func vibrate() {
    switch self {
    case .error:
      let generator = UINotificationFeedbackGenerator()
      generator.notificationOccurred(.error)

    case .success:
      let generator = UINotificationFeedbackGenerator()
      generator.notificationOccurred(.success)

    case .warning:
      let generator = UINotificationFeedbackGenerator()
      generator.notificationOccurred(.warning)

    case .light:
      let generator = UIImpactFeedbackGenerator(style: .light)
      generator.impactOccurred()

    case .medium:
      let generator = UIImpactFeedbackGenerator(style: .medium)
      generator.impactOccurred()

    case .heavy:
      let generator = UIImpactFeedbackGenerator(style: .heavy)
      generator.impactOccurred()

    case .selection:
      let generator = UISelectionFeedbackGenerator()
      generator.selectionChanged()
    }
  }
}

// MARK: - HapticEffectHelper

public class HapticEffectHelper {
  public final class func vibrate(withEffect effect: Int) {
    let aEffect = HapticEffect(rawValue: effect)
    aEffect?.vibrate()
  }

  public final class func vibrate(withEffect effect: HapticEffect) {
    if CHHapticEngine.capabilitiesForHardware().supportsHaptics {
      effect.vibrate()
    } else {
      AudioServicesPlaySystemSound(Constants.vibrationSoundId)
    }
  }
}
