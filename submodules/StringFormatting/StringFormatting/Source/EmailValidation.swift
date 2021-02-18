//
//  EmailValidation.swift
//  StringFormatting
//
//  Created by Алексей Смирнов on 22.12.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

public func isValidEmail(_ email: String?) -> Bool {
  
  guard let email = email else {
    return false
  }
  
  let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
  let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
  return emailPred.evaluate(with: email)
}
