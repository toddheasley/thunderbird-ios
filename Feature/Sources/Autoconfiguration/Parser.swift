import Foundation

class Parser: NSObject, XMLParserDelegate {
    var dictionary: [String: Any] {
        var dictionary: [String: Any] = [:]
        if let emailProvider {
            dictionary[Key.emailProvider.stringValue] = emailProvider
        }
        if let webMail {
            dictionary[Key.webMail.stringValue] = webMail
        }
        return [
            Key.clientConfig.stringValue: dictionary
        ]
    }

    var data: Data {
        get throws {
            try JSONSerialization.data(withJSONObject: dictionary)
        }
    }

    enum Key: CodingKey {
        case clientConfig, emailProvider, domain, displayName, displayShortName, incomingServer, outgoingServer, hostname, username, port, socketType, authentication, instruction, documentation, webMail, loginPage
    }

    init(_ data: Data) {
        parser = XMLParser(data: data)
        super.init()
        parser.delegate = self
        parser.parse()
    }

    private let parser: XMLParser
    private var emailProvider: [String: Any]? = nil
    private var webMail: [String: Any]? = nil

    // MARK: XMLParserDelegate
    func parserDidStartDocument(_ parser: XMLParser) {

    }

    func parser(
        _ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String : String] = [:]
    ) {
        switch elementName {
        case Key.emailProvider.stringValue:
            emailProvider = [:]
        case Key.webMail.stringValue:
            webMail = [:]
        case Key.loginPage.stringValue:
            webMail = nil

            if let url: URL = URL(string: "") {
                webMail = [
                    Key.loginPage.stringValue: url
                ]
            }
        default:
            break
        }
        print("didStartElement: \(elementName)")
        print(attributeDict)
        print("=====")
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let string: String = string.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !string.isEmpty else { return }
        print("foundCharacters: \(string)")
    }

    func parser(
        _ parser: XMLParser,
        didEndElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?
    ) {

    }

    func parserDidEndDocument(_ parser: XMLParser) {

    }
}


