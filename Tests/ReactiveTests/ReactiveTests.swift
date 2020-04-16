import XCTest
@testable import Reactive

final class ReactiveTests: XCTestCase {

    class DataObject {
        @Reactive var title: String?
        @Reactive var text: String?

        init(title: String?, text: String?) {
            self.title = title
            self.text = text
        }
    }

    func testHandleInitialValue() {
        let text = "text"
        let title = "title"
        let text2 = "title2"
        let data = DataObject(title: title, text: text)
        let label = UILabel()
        let label2 = UILabel()
        label2.text = text2

        data.$title.bind(label) { (aLabel, string) in
            aLabel.text = string
        }

        data.$text.bind(label2, skipInitialValue: true) { (aLabel, string) in
            aLabel.text = string
        }

        XCTAssert(label.text == data.title)
        XCTAssert(label2.text == text2)
    }

    func testHandleNewValue() {
        let text = Reactive("")
        let label = UILabel()
        let label2 = UILabel()
        let appendToLabel2 = " 2"

        text.bind(label) { (aLabel, string) in
            aLabel.text = string
        }
        text.bind(label2) { (aLabel, string) in
            aLabel.text = string + appendToLabel2
        }

        text.update("Initial Text")

        XCTAssert(label.text == text.value)
        XCTAssert(label2.text == text.value + appendToLabel2)
    }

    func testPruning() {
        let initialText = "Initial Text"
        let text = Reactive(initialText)

        let dataObject = DataObject(title: nil, text: nil)
        let label = UILabel()
        var label2: UILabel? = UILabel()

        text.bind(label) { (aLabel, string) in
            aLabel.text = string
            dataObject.title = string
        }
        text.bind(label2) { (aLabel, string) in
            aLabel.text = string
            dataObject.text = string
        }

        XCTAssert(dataObject.title == text.value)
        XCTAssert(dataObject.text == text.value)

        label2 = nil

        let updatedText = ""
        text.update(updatedText)

        XCTAssert(dataObject.title == updatedText)
        XCTAssert(dataObject.text != updatedText)
        XCTAssert(dataObject.text == initialText)

    }

    func testUnbind() {
        let title = "title"
        let text = "text"
        let data = DataObject(title: title, text: text)
        let label = UILabel()
        let label2 = UILabel()

        label.text = nil
        label2.text = nil

        data.$text.bind(label) { (aLabel, string) in
            aLabel.text = string
        }
        data.$text.bind(label) { (aLabel, string) in
            aLabel.text = string
        }
        data.$text.bind(label) { (aLabel, string) in
            aLabel.text = string
        }

        data.$text.bind(label2) { (aLabel, string) in
            aLabel.text = string
        }

        data.$text.unbind(label)
        data.title = nil
        data.text = nil

        XCTAssert(label.text == text)
        XCTAssert(label2.text == nil)
    }

    static var allTests = [
        ("testHandleInitialValue", testHandleInitialValue),
        ("testHandleNewValue", testHandleNewValue),
        ("testPruning", testPruning),
        ("testUnbind", testUnbind),
    ]
}
