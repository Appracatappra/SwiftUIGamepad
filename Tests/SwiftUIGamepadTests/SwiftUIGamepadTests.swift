import XCTest
@testable import SwiftUIGamepad

final class SwiftUIGamepadTests: XCTestCase {
    func testGamepadUI() throws {
        let control:GamepadMenuCardView? = GamepadMenuCardView()
        
        XCTAssert(control != nil)
    }
}
