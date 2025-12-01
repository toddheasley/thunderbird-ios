//
//  FeatureFlagTests.swift
//  ThunderbirdTests
//
//  Created by Ashley Soucar on 11/19/25.
//

import Foundation
import Testing

struct FeatureFlagTests {
    @MainActor @Test func allowRemoteFlagsTest() {
        let allowRemote: Bool = FeatureFlags(distribution: .current).allowRemote  // Capture current setting
        FeatureFlags.resetAllowRemoteFlags()  // Reset to default value for test
        let flags: FeatureFlags = FeatureFlags(distribution: .current)
        #expect(flags.allowRemote == true)  // Expected default
        flags.setAllowRemoteFlags(allowRemote: false)
        #expect(flags.allowRemote == false)
        flags.setAllowRemoteFlags(allowRemote: allowRemote)  // Restore user setting
    }

    @MainActor @Test func flagForKeyTest() {
        FeatureFlags.resetFeatureFlags(distribution: .current)
        let flags: FeatureFlags = FeatureFlags(distribution: .current)
        #expect(flags.flagForKey(key: .featureX) == false)  // Expected default
        flags.setFlagForKey(key: .featureX, val: true)
        #expect(flags.flagForKey(key: .featureX) == true)
        FeatureFlags.resetFeatureFlags()
    }

    @MainActor @Test func setFlagForKeyTest() {
        FeatureFlags.resetFeatureFlags(distribution: .current)
        let flags: FeatureFlags = FeatureFlags(distribution: .current)
        #expect(flags.flagForKey(key: .featureX) == false)  // Expected default
        #expect(flags.flagForKey(key: .featureY) == false)  // Expected default
        flags.setFlagForKey(key: .featureX, val: true)
        #expect(flags.flagForKey(key: .featureX) == true)
        #expect(flags.flagForKey(key: .featureY) == false)
        flags.setFlagForKey(key: .featureY, val: true)
        #expect(flags.flagForKey(key: .featureX) == true)
        #expect(flags.flagForKey(key: .featureY) == true)
        flags.setFlagForKey(key: .featureX, val: false)
        #expect(flags.flagForKey(key: .featureX) == false)
        #expect(flags.flagForKey(key: .featureY) == true)
        FeatureFlags.resetFeatureFlags()
    }
}
