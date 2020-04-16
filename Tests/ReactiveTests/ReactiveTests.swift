import XCTest
@testable import Reactive

final class ReactiveTests: XCTestCase {

    class DataObject {
        var title: String?
        var text: String?
    }

    func testHandleInitialValue() {
        let text = Reactive("Initial Text")
        let label = UILabel()
        let label2 = UILabel()

        text.bind(label, skipInitialValue: true) { (aLabel, string) in
            aLabel.text = string
        }

        text.bind(label2, skipInitialValue: false) { (aLabel, string) in
            aLabel.text = string
        }

        XCTAssert(label.text != text.value)
        XCTAssert(label2.text == text.value)
    }

    func testHandleNewValue() {
        let text = Reactive("")
        let label = UILabel()
        let label2 = UILabel()
        let appendToLabel2 = " 2"

        text.bind(label, skipInitialValue: false) { (aLabel, string) in
            aLabel.text = string
        }

        text.bind(label2, skipInitialValue: false) { (aLabel, string) in
            aLabel.text = string + appendToLabel2
        }

        text.update("Initial Text")

        XCTAssert(label.text == text.value)
        XCTAssert(label2.text == text.value + appendToLabel2)
    }

    func testPruning() {
        let initialText = "Initial Text"
        let text = Reactive(initialText)

        let dataObject = DataObject()
        let label = UILabel()
        var label2: UILabel? = UILabel()

        text.bind(label, skipInitialValue: false) { (aLabel, string) in
            aLabel.text = string
            dataObject.title = string
        }

        text.bind(label2, skipInitialValue: false) { (aLabel, string) in
            aLabel.text = string
            dataObject.text = string
        }

        XCTAssert(dataObject.title == text.value)
        XCTAssert(dataObject.text == text.value)

        label2 = nil

        text.update("")

        XCTAssert(dataObject.title == "")
        XCTAssert(dataObject.text == initialText)

    }

    static var allTests = [
        ("testHandleInitialValue", testHandleInitialValue),
        ("testHandleNewValue", testHandleNewValue),
        ("testPruning", testPruning),
    ]
}
