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
        #expect(flags.allowRemote == true)
        flags.setAllowRemoteFlags(allowRemote: false)
        #expect(flags.allowRemote == false)

    }
    @MainActor @Test func flagForKeyTest() {
        let flags: FeatureFlags = FeatureFlags(distribution: .current)
        #expect(flags.flagForKey(key: .featureX) == false)

    }

    @MainActor @Test func setFlagForKeyTest() {
        let flags: FeatureFlags = FeatureFlags(distribution: .current)
        #expect(flags.flagForKey(key: .featureX) == false)
        flags.setFlagForKey(key: .featureX, val: true)
        #expect(flags.flagForKey(key: .featureX) == true)

    }
}
