@testable import IMAP
import Testing

struct MessageTests {

}

struct MessageSetTests {
    @Test func messages() {
        let messageSet: MessageSet = [
            4: Message(components: [.uid(9)]),
            1: Message(components: [.uid(1)]),
            5: Message(components: [.uid(2)]),
            3: Message(components: [.uid(5)]),
            2: Message(components: [.uid(3)])
        ]
        #expect(messageSet.messages.compactMap { $0.components.uid } == [1, 3, 5, 9, 2])
    }
}
