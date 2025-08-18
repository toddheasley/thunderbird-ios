@testable import Autoconfiguration
import Testing
import Foundation

struct ParserTests {
    @Test func dictionary() {
        print(Parser(fastmail).dictionary)
        print(Parser(freenet).dictionary)
    }
}

private let fastmail: Data = """
<?xml version="1.0" encoding="UTF-8"?>

<clientConfig version="1.1">
  <emailProvider id="MessagingEngine">
    <domain>fastmail.com</domain>
    <displayName>Fastmail</displayName>
    <displayShortName>Fastmail</displayShortName>
    <incomingServer type="imap">
      <hostname>imap.fastmail.com</hostname>
      <port>993</port>
      <socketType>SSL</socketType>
      <authentication>OAuth2</authentication>
      <username>%EMAILADDRESS%</username>
    </incomingServer>
    <incomingServer type="pop3">
      <hostname>pop.fastmail.com</hostname>
      <port>995</port>
      <socketType>SSL</socketType>
      <authentication>OAuth2</authentication>
      <username>%EMAILADDRESS%</username>
    </incomingServer>
    <outgoingServer type="smtp">
      <hostname>smtp.fastmail.com</hostname>
      <port>465</port>
      <socketType>SSL</socketType>
      <authentication>OAuth2</authentication>
      <username>%EMAILADDRESS%</username>
    </outgoingServer>
    <instruction url="https://www.fastmail.help/hc/en-us/articles/1500000278342">
      <descr lang="en">Server Names and Ports</descr>
    </instruction>
    <instruction url="https://www.fastmail.help/hc/en-us/articles/360058753054">
      <descr lang="en">Using Fastmail with Mozilla Thunderbird</descr>
    </instruction>
  </emailProvider>
  <webMail>
    <loginPage url="https://app.fastmail.com/login/?domain=%EMAILDOMAIN%" />
  </webMail>
</clientConfig>
""".data(using: .utf8)!

private let freenet: Data = """
<?xml version="1.0" encoding="UTF-8"?>

<clientConfig version="1.1">
  <emailProvider id="freenet.de">
    <domain>freenet.de</domain>
    <displayName>Freenet Mail</displayName>
    <displayShortName>Freenet</displayShortName>
    <incomingServer type="imap">
      <hostname>imap.freenet.de</hostname>
      <port>993</port>
      <socketType>SSL</socketType>
      <authentication>password-encrypted</authentication>
      <username>%EMAILADDRESS%</username>
    </incomingServer>
    <incomingServer type="imap">
      <hostname>imap.freenet.de</hostname>
      <port>143</port>
      <socketType>STARTTLS</socketType>
      <authentication>password-encrypted</authentication>
      <username>%EMAILADDRESS%</username>
    </incomingServer>
    <incomingServer type="pop3">
      <hostname>pop.freenet.de</hostname>
      <port>995</port>
      <socketType>SSL</socketType>
      <authentication>password-cleartext</authentication>
      <username>%EMAILADDRESS%</username>
    </incomingServer>
    <incomingServer type="pop3">
      <hostname>pop.freenet.de</hostname>
      <port>110</port>
      <socketType>STARTTLS</socketType>
      <authentication>password-cleartext</authentication>
      <username>%EMAILADDRESS%</username>
    </incomingServer>
    <outgoingServer type="smtp">
      <hostname>smtp.freenet.de</hostname>
      <port>465</port>
      <socketType>SSL</socketType>
      <authentication>password-encrypted</authentication>
      <username>%EMAILADDRESS%</username>
    </outgoingServer>
    <outgoingServer type="smtp">
      <hostname>smtp.freenet.de</hostname>
      <port>587</port>
      <socketType>STARTTLS</socketType>
      <authentication>password-encrypted</authentication>
      <username>%EMAILADDRESS%</username>
    </outgoingServer>
    <documentation url="http://kundenservice.freenet.de/hilfe/email/programme/config/index.html">
      <descr lang="de">Allgemeine Beschreibung der Einstellungen</descr>
      <descr lang="en">Generic settings page</descr>
    </documentation>
    <documentation url="http://kundenservice.freenet.de/hilfe/email/programme/config/thunderbird/imap-thunderbird/imap/index.html">
      <descr lang="de">TB 2.0 IMAP-Einstellungen</descr>
      <descr lang="en">TB 2.0 IMAP settings</descr>
    </documentation>
  </emailProvider>
</clientConfig>
""".data(using: .utf8)!
