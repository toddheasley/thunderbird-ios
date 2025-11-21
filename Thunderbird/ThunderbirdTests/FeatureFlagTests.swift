//
//  FeatureFlagTests.swift
//  ThunderbirdTests
//
//  Created by Ashley Soucar on 11/19/25.
//

import Testing

struct FeatureFlagTests {

    @MainActor @Test func allowRemoteFlagsTest() {
        let flags: FeatureFlags = FeatureFlags(distribution: .current)
        #expect(flags.allowRemote == false)
        flags.setAllowRemoteFlags(allowRemote: true)
        #expect(flags.allowRemote == true)

    }
    @MainActor @Test func flagForKeyTest() {
        let flags: FeatureFlags = FeatureFlags(distribution: .current)
        #expect(flags.flagForKey(key: .featureX) == true)

    }

    @MainActor @Test func setFlagForKeyTest() {
        let flags: FeatureFlags = FeatureFlags(distribution: .current)
        #expect(flags.flagForKey(key: .featureX) == true)
        flags.setFlagForKey(key: .featureX, val: false)
        #expect(flags.flagForKey(key: .featureX) == false)

    }
}
