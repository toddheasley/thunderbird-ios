import Foundation

/// Filters narrow the returned responses when querying ``Email``, part of [JMAP core.](https://jmap.io/spec-core.html#query)
public struct Filter: CustomStringConvertible {
    public enum Condition: CustomStringConvertible {
        case inMailbox(String)
        case inMailboxOtherThan([String])
        case before(Date)
        case after(Date)
        case minSize(Int)
        case maxSize(Int)
        case allInThreadHaveKeyword(String)
        case someInThreadHaveKeyword(String)
        case noneInThreadHaveKeyword(String)
        case hasKeyword(String)
        case notKeyword(String)
        case hasAttachment(Bool)
        case text(String)
        case from(String)
        case to(String)
        case cc(String)
        case bcc(String)
        case subject(String)
        case body(String)
        case header([String])

        var object: [String: Any] {
            [
                key: value
            ]
        }

        private var key: String {
            switch self {
            case .inMailbox: "inMailbox"
            case .inMailboxOtherThan: "inMailboxOtherThan"
            case .before: "before"
            case .after: "after"
            case .minSize: "minSize"
            case .maxSize: "maxSize"
            case .allInThreadHaveKeyword: "allInThreadHaveKeyword"
            case .someInThreadHaveKeyword: "someInThreadHaveKeyword"
            case .noneInThreadHaveKeyword: "noneInThreadHaveKeyword"
            case .hasKeyword: "hasKeyword"
            case .notKeyword: "notKeyword"
            case .hasAttachment: "hasAttachment"
            case .text: "text"
            case .from: "from"
            case .to: "to"
            case .cc: "cc"
            case .bcc: "bcc"
            case .subject: "subject"
            case .body: "body"
            case .header: "header"
            }
        }

        private var value: Any {
            switch self {
            case .inMailbox(let string),
                .allInThreadHaveKeyword(let string),
                .someInThreadHaveKeyword(let string),
                .noneInThreadHaveKeyword(let string),
                .hasKeyword(let string),
                .notKeyword(let string),
                .text(let string),
                .from(let string),
                .to(let string),
                .cc(let string),
                .bcc(let string),
                .subject(let string),
                .body(let string):
                string
            case .inMailboxOtherThan(let strings),
                .header(let strings):
                strings
            case .before(let date),
                .after(let date):
                date
            case .minSize(let bytes),
                .maxSize(let bytes):
                bytes
            case .hasAttachment(let bool): bool
            }
        }

        // MARK: CustomStringConvertible
        public var description: String { "\(key): \(value)" }
    }

    public enum Operator: String, CaseIterable, CustomStringConvertible {
        case and = "AND"
        case or = "OR"
        case not = "NOT"

        // MARK: CustomStringConvertible
        public var description: String { rawValue }
    }

    public let conditions: [Condition]
    public let `operator`: Operator

    public init(_ conditions: [Condition], `operator`: Operator = .or) {
        self.conditions = conditions
        self.operator = `operator`
    }

    var object: [String: Any] {
        [
            "conditions": conditions.map { $0.object },
            "operator": "\(self.operator)"
        ]
    }

    // MARK: CustomStringConvertible
    public var description: String {
        "Filter: \(conditions.map { "\($0)" }.joined(separator: "\(self.operator) "))"
    }
}
