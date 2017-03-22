/*
 Copyright 2016-present Google Inc. All Rights Reserved.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
*/

import XCTest
import MDFTextAccessibility

class MDFTextAccessibilityUnitTests: XCTestCase {
  let alphaEpsilon:CGFloat = 0.01

  // MARK: Text color from choices

  // Test large text
  // Test that no-modify-alpha properly skips a color with low alpha that would be otherwise ok.

  func testBasicChoices() {
    let textColors = [ UIColor.white, UIColor.black ]
    let backgroundColor = UIColor.white
    let textColor = MDFTextAccessibility.textColor(fromChoices: textColors,
        onBackgroundColor: backgroundColor,
        options: MDFTextAccessibilityOptions())
    XCTAssertEqual(textColor, UIColor.black)
  }

  func testChoiceFromEmptyChoicesReturnsNil() {
    let textColors:[UIColor] = []
    let backgroundColor = UIColor.white
    let textColor = MDFTextAccessibility.textColor(fromChoices: textColors,
        onBackgroundColor: backgroundColor,
        options: MDFTextAccessibilityOptions())
    XCTAssertNil(textColor)
  }

  func testChoiceObservesLighterPreferences() {
    // Both lighterColor and darkerColor are acceptable in terms of contrast ratios.
    let lighterColor = UIColor(white: 0.1, alpha: 1)
    let darkerColor = UIColor.black
    let textColors = [ darkerColor, lighterColor ]
    let backgroundColor = UIColor.white
    let textColor = MDFTextAccessibility.textColor(fromChoices: textColors,
        onBackgroundColor: backgroundColor,
        options: MDFTextAccessibilityOptions.preferLighter)
    XCTAssertEqual(textColor, lighterColor)
  }

  func testChoiceObservesDarkerPreferences() {
    // Both lighterColor and darkerColor are acceptable in terms of contrast ratios.
    let lighterColor = UIColor(white: 0.1, alpha: 1)
    let darkerColor = UIColor.black
    let textColors = [ darkerColor, lighterColor ]
    let backgroundColor = UIColor.white
    let textColor = MDFTextAccessibility.textColor(fromChoices: textColors,
        onBackgroundColor: backgroundColor,
        options: MDFTextAccessibilityOptions.preferDarker)
    XCTAssertEqual(textColor, darkerColor)
  }

  // MARK: Minimum alpha values

  func testSameColorsHaveNoMinAlpha() {
    let color = UIColor.white
    let minAlpha = MDFTextAccessibility.minAlpha(ofTextColor: color,
        onBackgroundColor:color,
        options:MDFTextAccessibilityOptions())
    XCTAssertEqual(minAlpha, -1)
  }

  func testBlackOnWhiteMinAlpha() {
    let textColor = UIColor.black
    let backgroundColor = UIColor.white
    let minAlpha = MDFTextAccessibility.minAlpha(ofTextColor: textColor,
        onBackgroundColor:backgroundColor,
        options:MDFTextAccessibilityOptions())
    XCTAssertEqualWithAccuracy(minAlpha, 0.54, accuracy: alphaEpsilon)
  }

  func testLargeTextBlackOnWhiteMinAlpha() {
    let textColor = UIColor.black
    let backgroundColor = UIColor.white
    let minAlpha = MDFTextAccessibility.minAlpha(ofTextColor: textColor,
        onBackgroundColor:backgroundColor,
        options:MDFTextAccessibilityOptions.largeFont)
    XCTAssertEqualWithAccuracy(minAlpha, 0.42, accuracy: alphaEpsilon)
  }

  func testMinAlphaIgnoresColorAlpha() {
    let textColor = UIColor.black
    let backgroundColor = UIColor.white
    let minAlpha = MDFTextAccessibility.minAlpha(ofTextColor: textColor,
        onBackgroundColor:backgroundColor,
        options:MDFTextAccessibilityOptions())

    let textColorWithAlpha = UIColor(white: 0, alpha: 0.5)
    let minAlphaWithColorWithAlpha = MDFTextAccessibility.minAlpha(ofTextColor: textColorWithAlpha,
        onBackgroundColor:backgroundColor,
        options:MDFTextAccessibilityOptions())

    XCTAssertEqualWithAccuracy(minAlpha, minAlphaWithColorWithAlpha, accuracy: alphaEpsilon)
  }

  // MARK: Accessibility standard tests

  func testPassesStandards() {
    let backgroundColor = UIColor.white
    let grey70 = UIColor(white: 0, alpha: 0.7)  // Passes everything.
    let grey60 = UIColor(white: 0, alpha: 0.6)  // Passes everything except normal text at level AAA.
    let grey50 = UIColor(white: 0, alpha: 0.5)  // Only passes for large text at level AA.
    let grey40 = UIColor(white: 0, alpha: 0.4)  // Fails everything.

    // Normal text at the AA level, has to be above ~0.54.
    XCTAssertTrue(MDFTextAccessibility.textColor(grey70, passesOnBackgroundColor: backgroundColor, options: MDFTextAccessibilityOptions()))
    XCTAssertTrue(MDFTextAccessibility.textColor(grey60, passesOnBackgroundColor: backgroundColor, options: MDFTextAccessibilityOptions()))
    XCTAssertFalse(MDFTextAccessibility.textColor(grey50, passesOnBackgroundColor: backgroundColor, options: MDFTextAccessibilityOptions()))
    XCTAssertFalse(MDFTextAccessibility.textColor(grey40, passesOnBackgroundColor: backgroundColor, options: MDFTextAccessibilityOptions()))

    // Large text at the AA level, has to be above ~0.42.
    XCTAssertTrue(MDFTextAccessibility.textColor(grey70, passesOnBackgroundColor: backgroundColor, options: .largeFont))
    XCTAssertTrue(MDFTextAccessibility.textColor(grey60, passesOnBackgroundColor: backgroundColor, options: .largeFont))
    XCTAssertTrue(MDFTextAccessibility.textColor(grey50, passesOnBackgroundColor: backgroundColor, options: .largeFont))
    XCTAssertFalse(MDFTextAccessibility.textColor(grey40, passesOnBackgroundColor: backgroundColor, options: .largeFont))

    // Normal text at the AAA level, has to be above ~0.67.
    XCTAssertTrue(MDFTextAccessibility.textColor(grey70, passesOnBackgroundColor: backgroundColor, options: .enhancedContrast))
    XCTAssertFalse(MDFTextAccessibility.textColor(grey60, passesOnBackgroundColor: backgroundColor, options: .enhancedContrast))
    XCTAssertFalse(MDFTextAccessibility.textColor(grey50, passesOnBackgroundColor: backgroundColor, options: .enhancedContrast))
    XCTAssertFalse(MDFTextAccessibility.textColor(grey40, passesOnBackgroundColor: backgroundColor, options: .enhancedContrast))

    // Large text at the AAA level, has to be above ~0.54.
    XCTAssertTrue(MDFTextAccessibility.textColor(grey70, passesOnBackgroundColor: backgroundColor, options: [.enhancedContrast, .largeFont]))
    XCTAssertTrue(MDFTextAccessibility.textColor(grey60, passesOnBackgroundColor: backgroundColor, options: [.enhancedContrast, .largeFont]))
    XCTAssertFalse(MDFTextAccessibility.textColor(grey50, passesOnBackgroundColor: backgroundColor, options: [.enhancedContrast, .largeFont]))
    XCTAssertFalse(MDFTextAccessibility.textColor(grey40, passesOnBackgroundColor: backgroundColor, options: [.enhancedContrast, .largeFont]))
  }

  // MARK: "Large" fonts.

  func testNormalFontIsNotLarge() {
    let font = UIFont.systemFont(ofSize: 14)
    XCTAssertFalse(MDFTextAccessibility.isLarge(forContrastRatios: font))
  }

  func testLargeFontIsLarge() {
    let font = UIFont.systemFont(ofSize: 18)
    XCTAssertTrue(MDFTextAccessibility.isLarge(forContrastRatios: font))
  }

  func testSmallBoldFontIsNotLarge() {
    let font = UIFont.boldSystemFont(ofSize: 13)
    XCTAssertFalse(MDFTextAccessibility.isLarge(forContrastRatios: font))
  }

  func testBoldFontIsLarge() {
    let font = UIFont.boldSystemFont(ofSize: 14)
    XCTAssertTrue(MDFTextAccessibility.isLarge(forContrastRatios: font))
  }
  
  func testNilFontIsNotLarge() {
    XCTAssertFalse(MDFTextAccessibility.isLarge(forContrastRatios: nil))
  }

  // MARK: textColorOnBackgroundImage
  
  func testTextColorOnEmptyBackgroundImage() {
    let color = MDFTextAccessibility.textColor(onBackgroundImage: UIImage.init(), inRegion:CGRect(x: 0, y: 0, width: 10, height: 10), targetTextAlpha: 1.0, font: UIFont.boldSystemFont(ofSize: 13))
    XCTAssertNil(color)
  }
  
  func testTextColorOnNonEmptyBackgroundImageOffRegion() {
    let image = UIImage.init(named: "100_100_gray", in: Bundle.init(for: type(of: self)), compatibleWith: nil)!
    let color = MDFTextAccessibility.textColor(onBackgroundImage: image, inRegion:CGRect(x: -10, y: -10, width: 10, height: 10), targetTextAlpha: 1.0, font: UIFont.boldSystemFont(ofSize: 13))
    XCTAssertNil(color)
  }
  
  func testTextColorOnNonEmptyBackgroundImageZeroRect() {
    let image = UIImage.init(named: "100_100_gray", in: Bundle.init(for: type(of: self)), compatibleWith: nil)!
    let color = MDFTextAccessibility.textColor(onBackgroundImage: image, inRegion:CGRect.zero, targetTextAlpha: 1.0, font: UIFont.boldSystemFont(ofSize: 13))
    XCTAssertNil(color)
  }
  
  func testTextColorOnNonEmptyBackgroundImage() {
    let image = UIImage.init(named: "100_100_gray", in: Bundle.init(for: type(of: self)), compatibleWith: nil)!
    let color = MDFTextAccessibility.textColor(onBackgroundImage: image, inRegion:CGRect(x: 0, y: 0, width: 10, height: 10), targetTextAlpha: 1.0, font: UIFont.boldSystemFont(ofSize: 13))
    XCTAssertNotNil(color)
  }
  
  func testWhiteBackgroundImage() {
    let alpha:CGFloat = 1.0
    let image = UIImage.init(named: "100_100_white", in: Bundle.init(for: type(of: self)), compatibleWith: nil)!
    let color = MDFTextAccessibility.textColor(onBackgroundImage: image, inRegion:CGRect(x: 0, y: 0, width: 10, height: 10), targetTextAlpha: alpha, font: UIFont.boldSystemFont(ofSize: 13))
    let components = (color?.cgColor)?.components
    // 0 here for the first element in the components array represents a black color to give the most contrast against a fully white background image
    XCTAssertTrue(components?[0] == 0)
    XCTAssertTrue(components?[1] == alpha)
  }
  
  func testBlackBackgroundImage() {
    let alpha:CGFloat = 1
    let image = UIImage.init(named: "100_100_black", in: Bundle.init(for: type(of: self)), compatibleWith: nil)!
    let color = MDFTextAccessibility.textColor(onBackgroundImage: image, inRegion:CGRect(x: 0, y: 0, width: 10, height: 10), targetTextAlpha: alpha, font: UIFont.boldSystemFont(ofSize: 13))
    let components = (color?.cgColor)?.components
    // 1 here for the first element in the components array represents a white color to give the most contrast against a fully black background image
    XCTAssertTrue(components?[0] == 1)
    XCTAssertTrue(components?[1] == alpha)
  }

  func testIsLargeFontContrastRatios() {
    XCTAssertTrue(MDFTextAccessibility.isLarge(forContrastRatios: UIFont.boldSystemFont(ofSize: 14)))
    XCTAssertTrue(MDFTextAccessibility.isLarge(forContrastRatios: UIFont.systemFont(ofSize: 18)))
    XCTAssertTrue(MDFTextAccessibility.isLarge(forContrastRatios: UIFont.systemFont(ofSize: 20)))

    XCTAssertFalse(MDFTextAccessibility.isLarge(forContrastRatios: UIFont.boldSystemFont(ofSize: 13)))
    XCTAssertFalse(MDFTextAccessibility.isLarge(forContrastRatios: UIFont.systemFont(ofSize: 17)))
    XCTAssertFalse(MDFTextAccessibility.isLarge(forContrastRatios: UIFont.systemFont(ofSize: 10)))

    // Bold and thicker fonts are considered large at a lower font size than nonbold fonts.
    XCTAssertTrue(MDFTextAccessibility.isLarge(forContrastRatios: UIFont.systemFont(ofSize: 15, weight: UIFontWeightBlack)))
    XCTAssertTrue(MDFTextAccessibility.isLarge(forContrastRatios: UIFont.systemFont(ofSize: 15, weight: UIFontWeightHeavy)))
    XCTAssertTrue(MDFTextAccessibility.isLarge(forContrastRatios: UIFont.systemFont(ofSize: 15, weight: UIFontWeightBold)))
    // Semibold is considered bold by iOS font-weight APIs: fontDescriptor.symbolicTraits & UIFontDescriptorTraitBold.
    XCTAssertTrue(MDFTextAccessibility.isLarge(forContrastRatios: UIFont.systemFont(ofSize: 15, weight: UIFontWeightSemibold)))

    // Non-bold fonts are not considered large at the lower font size threshold.
    XCTAssertFalse(MDFTextAccessibility.isLarge(forContrastRatios: UIFont.systemFont(ofSize: 15, weight: UIFontWeightMedium)))
    XCTAssertFalse(MDFTextAccessibility.isLarge(forContrastRatios: UIFont.systemFont(ofSize: 15, weight: UIFontWeightRegular)))
    XCTAssertFalse(MDFTextAccessibility.isLarge(forContrastRatios: UIFont.systemFont(ofSize: 15, weight: UIFontWeightLight)))
    XCTAssertFalse(MDFTextAccessibility.isLarge(forContrastRatios: UIFont.systemFont(ofSize: 15, weight: UIFontWeightThin)))
    XCTAssertFalse(MDFTextAccessibility.isLarge(forContrastRatios: UIFont.systemFont(ofSize: 15, weight: UIFontWeightUltraLight)))
  }
}
