public struct EmailProvider {
    public internal(set) var domain: String = ""
    public internal(set) var displayName: String = ""
    public internal(set) var displayShortName: String = ""
    public internal(set) var incomingServers: [Any] = []
    public internal(set) var outgoingServers: [Any] = []
    public internal(set) var documentation: [Any] = []
}
