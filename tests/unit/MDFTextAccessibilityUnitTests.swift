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
    let grey60 = UIColor(white: 0, alpha: 0.6)  // Passes everything.
    let grey50 = UIColor(white: 0, alpha: 0.5)  // Passes for large text only.
    let grey40 = UIColor(white: 0, alpha: 0.4)  // Fails everything.

    let tests = [
      (MDFTextAccessibilityOptions.None, grey60, true),
      (MDFTextAccessibilityOptions.None, grey50, false),
      (MDFTextAccessibilityOptions.None, grey40, false),
      (MDFTextAccessibilityOptions.LargeFont, grey60, true),
      (MDFTextAccessibilityOptions.LargeFont, grey50, true),
      (MDFTextAccessibilityOptions.LargeFont, grey40, false)
    ]

    for test in tests {
      XCTAssertEqual(MDFTextAccessibility.textColor(test.1,
        passesOnBackgroundColor: backgroundColor,
        options: test.0), test.2)
    }
  }
}
