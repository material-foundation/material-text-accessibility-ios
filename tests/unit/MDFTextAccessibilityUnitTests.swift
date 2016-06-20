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
    let textColors = [ UIColor.whiteColor(), UIColor.blackColor() ]
    let backgroundColor = UIColor.whiteColor()
    let textColor = MDFTextAccessibility.textColorFromChoices(textColors,
        onBackgroundColor: backgroundColor,
        options: MDFTextAccessibilityOptions.None)
    XCTAssertEqual(textColor, UIColor.blackColor())
  }

  func testChoiceFromEmptyChoicesReturnsNil() {
    let textColors:[UIColor] = []
    let backgroundColor = UIColor.whiteColor()
    let textColor = MDFTextAccessibility.textColorFromChoices(textColors,
        onBackgroundColor: backgroundColor,
        options: MDFTextAccessibilityOptions.None)
    XCTAssertNil(textColor)
  }

  func testChoiceObservesLighterPreferences() {
    // Both lighterColor and darkerColor are acceptable in terms of contrast ratios.
    let lighterColor = UIColor(white: 0.1, alpha: 1)
    let darkerColor = UIColor.blackColor()
    let textColors = [ darkerColor, lighterColor ]
    let backgroundColor = UIColor.whiteColor()
    let textColor = MDFTextAccessibility.textColorFromChoices(textColors,
        onBackgroundColor: backgroundColor,
        options: MDFTextAccessibilityOptions.PreferLighter)
    XCTAssertEqual(textColor, lighterColor)
  }

  func testChoiceObservesDarkerPreferences() {
    // Both lighterColor and darkerColor are acceptable in terms of contrast ratios.
    let lighterColor = UIColor(white: 0.1, alpha: 1)
    let darkerColor = UIColor.blackColor()
    let textColors = [ darkerColor, lighterColor ]
    let backgroundColor = UIColor.whiteColor()
    let textColor = MDFTextAccessibility.textColorFromChoices(textColors,
        onBackgroundColor: backgroundColor,
        options: MDFTextAccessibilityOptions.PreferDarker)
    XCTAssertEqual(textColor, darkerColor)
  }

  // MARK: Minimum alpha values

  func testSameColorsHaveNoMinAlpha() {
    let color = UIColor.whiteColor()
    let minAlpha = MDFTextAccessibility.minAlphaOfTextColor(color,
        onBackgroundColor:color,
        options:MDFTextAccessibilityOptions.None)
    XCTAssertEqual(minAlpha, -1)
  }

  func testBlackOnWhiteMinAlpha() {
    let textColor = UIColor.blackColor()
    let backgroundColor = UIColor.whiteColor()
    let minAlpha = MDFTextAccessibility.minAlphaOfTextColor(textColor,
        onBackgroundColor:backgroundColor,
        options:MDFTextAccessibilityOptions.None)
    XCTAssertEqualWithAccuracy(minAlpha, 0.54, accuracy: alphaEpsilon)
  }

  func testLargeTextBlackOnWhiteMinAlpha() {
    let textColor = UIColor.blackColor()
    let backgroundColor = UIColor.whiteColor()
    let minAlpha = MDFTextAccessibility.minAlphaOfTextColor(textColor,
        onBackgroundColor:backgroundColor,
        options:MDFTextAccessibilityOptions.LargeFont)
    XCTAssertEqualWithAccuracy(minAlpha, 0.42, accuracy: alphaEpsilon)
  }

  func testMinAlphaIgnoresColorAlpha() {
    let textColor = UIColor.blackColor()
    let backgroundColor = UIColor.whiteColor()
    let minAlpha = MDFTextAccessibility.minAlphaOfTextColor(textColor,
        onBackgroundColor:backgroundColor,
        options:MDFTextAccessibilityOptions.None)

    let textColorWithAlpha = UIColor(white: 0, alpha: 0.5)
    let minAlphaWithColorWithAlpha = MDFTextAccessibility.minAlphaOfTextColor(textColorWithAlpha,
        onBackgroundColor:backgroundColor,
        options:MDFTextAccessibilityOptions.None)

    XCTAssertEqualWithAccuracy(minAlpha, minAlphaWithColorWithAlpha, accuracy: alphaEpsilon)
  }

  // MARK: Accessibility standard tests

  func testPassesStandards() {
    let backgroundColor = UIColor.whiteColor()
    let grey70 = UIColor(white: 0, alpha: 0.7)  // Passes everything.
    let grey60 = UIColor(white: 0, alpha: 0.6)  // Passes everything except normal text at level AAA.
    let grey50 = UIColor(white: 0, alpha: 0.5)  // Only passes for large text at level AA.
    let grey40 = UIColor(white: 0, alpha: 0.4)  // Fails everything.

    // Normal text at the AA level, has to be above ~0.54.
    XCTAssertTrue(MDFTextAccessibility.textColor(grey70, passesOnBackgroundColor: backgroundColor, options: .None))
    XCTAssertTrue(MDFTextAccessibility.textColor(grey60, passesOnBackgroundColor: backgroundColor, options: .None))
    XCTAssertFalse(MDFTextAccessibility.textColor(grey50, passesOnBackgroundColor: backgroundColor, options: .None))
    XCTAssertFalse(MDFTextAccessibility.textColor(grey40, passesOnBackgroundColor: backgroundColor, options: .None))

    // Large text at the AA level, has to be above ~0.42.
    XCTAssertTrue(MDFTextAccessibility.textColor(grey70, passesOnBackgroundColor: backgroundColor, options: .LargeFont))
    XCTAssertTrue(MDFTextAccessibility.textColor(grey60, passesOnBackgroundColor: backgroundColor, options: .LargeFont))
    XCTAssertTrue(MDFTextAccessibility.textColor(grey50, passesOnBackgroundColor: backgroundColor, options: .LargeFont))
    XCTAssertFalse(MDFTextAccessibility.textColor(grey40, passesOnBackgroundColor: backgroundColor, options: .LargeFont))

    // Normal text at the AAA level, has to be above ~0.67.
    XCTAssertTrue(MDFTextAccessibility.textColor(grey70, passesOnBackgroundColor: backgroundColor, options: .EnhancedContrast))
    XCTAssertFalse(MDFTextAccessibility.textColor(grey60, passesOnBackgroundColor: backgroundColor, options: .EnhancedContrast))
    XCTAssertFalse(MDFTextAccessibility.textColor(grey50, passesOnBackgroundColor: backgroundColor, options: .EnhancedContrast))
    XCTAssertFalse(MDFTextAccessibility.textColor(grey40, passesOnBackgroundColor: backgroundColor, options: .EnhancedContrast))

    // Large text at the AAA level, has to be above ~0.54.
    XCTAssertTrue(MDFTextAccessibility.textColor(grey70, passesOnBackgroundColor: backgroundColor, options: [.EnhancedContrast, .LargeFont]))
    XCTAssertTrue(MDFTextAccessibility.textColor(grey60, passesOnBackgroundColor: backgroundColor, options: [.EnhancedContrast, .LargeFont]))
    XCTAssertFalse(MDFTextAccessibility.textColor(grey50, passesOnBackgroundColor: backgroundColor, options: [.EnhancedContrast, .LargeFont]))
    XCTAssertFalse(MDFTextAccessibility.textColor(grey40, passesOnBackgroundColor: backgroundColor, options: [.EnhancedContrast, .LargeFont]))
  }

  // MARK: "Large" fonts.

  func testNormalFontIsNotLarge() {
    let font = UIFont.systemFontOfSize(14)
    XCTAssertFalse(MDFTextAccessibility.isLargeForContrastRatios(font))
  }

  func testLargeFontIsLarge() {
    let font = UIFont.systemFontOfSize(18)
    XCTAssertTrue(MDFTextAccessibility.isLargeForContrastRatios(font))
  }

  func testSmallBoldFontIsNotLarge() {
    let font = UIFont.boldSystemFontOfSize(13)
    XCTAssertFalse(MDFTextAccessibility.isLargeForContrastRatios(font))
  }

  func testBoldFontIsLarge() {
    let font = UIFont.boldSystemFontOfSize(14)
    XCTAssertTrue(MDFTextAccessibility.isLargeForContrastRatios(font))
  }
  
  func testNilFontIsNotLarge() {
    XCTAssertFalse(MDFTextAccessibility.isLargeForContrastRatios(nil))
  }

}
