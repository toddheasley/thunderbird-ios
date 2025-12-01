@testable import SMTP
import Testing

struct EmailAddressTests {
    @Test func host() {
        #expect(EmailAddress("user@example.com").host == "example.com")
        #expect(EmailAddress("h@x0r@192.168.1.1").host == "192.168.1.1")
        #expect(EmailAddress("abc@").host == nil)
        #expect(EmailAddress(" ").host == nil)
    }

    @Test func valueInit() {
        #expect(EmailAddress("name@example.com", label: "Example Name").value == "name@example.com")
        #expect(EmailAddress("name@example.com", label: "Example Name").label == "Example Name")
        #expect(EmailAddress("name@example.com", label: "").label == nil)
        #expect(EmailAddress("name@example.com").label == nil)
    }

    @Test func stringLiteralInit() {
        let labeledEmailAddress: EmailAddress = "Example Name <name@example.com>"
        #expect(labeledEmailAddress.value == "name@example.com")
        #expect(labeledEmailAddress.label == "Example Name")
        let emailAddress: EmailAddress = "name@example.com"
        #expect(emailAddress.value == "name@example.com")
        #expect(emailAddress.label == nil)
    }

    @Test func description() {
        #expect(EmailAddress("name@example.com", label: "Example Name").description == "Example Name <name@example.com>")
        #expect(EmailAddress("name@example.com").description == "name@example.com")
    }
}
