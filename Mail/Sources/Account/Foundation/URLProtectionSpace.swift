import Foundation

extension URLProtectionSpace {
    
    ///  Named secure realm for Thunderbird accounts
    static let account: URLProtectionSpace = URLProtectionSpace(host: "net.thunderbird")
    
    convenience init(host: String) {
        self.init(host: host, port: 0, protocol: nil, realm: nil, authenticationMethod: nil)
    }
}
