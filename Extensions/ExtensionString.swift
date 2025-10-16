//
//  LabelExtensions.swift
//  sahibindenVitrin
//
//  Created by Ibrahim Alperen Kurum on 7.10.2025.
//
import UIKit

extension String {
    func capitalizingFirstLetter() -> String {
        guard let firstCharacter = first else {
            return self
        }
        return String(firstCharacter).uppercased() + dropFirst()
    }
}

