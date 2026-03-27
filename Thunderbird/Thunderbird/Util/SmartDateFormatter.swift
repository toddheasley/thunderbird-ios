//
//  SmartDateFormatter.swift
//  Thunderbird
//
//  Created by Ashley Soucar on 3/6/26.
//
import SwiftUI

@MainActor
public struct SmartDateFormatter {

    func dateFormatter(date: Date, isSmartDate: Bool) -> String {
        if isSmartDate {
            return smartDate(date: date)
        }
        return fullDateFormatter(date: date)
    }

    private func fullDateFormatter(date: Date) -> String {
        return date.formatted(date: .numeric, time: .omitted)
    }

    private func smartDate(date: Date) -> String {
        if Calendar.autoupdatingCurrent.isDateInToday(date) {
            return date.formatted(date: .omitted, time: .shortened)
        } else if Calendar.autoupdatingCurrent.isDateInYesterday(date) {
            let relativeDateFormatter = RelativeDateTimeFormatter()
            return relativeDateFormatter.localizedString(for: date, relativeTo: Date())
        } else if !Calendar.autoupdatingCurrent.isDate(date, equalTo: Date(), toGranularity: .year) {
            return date.formatted(.dateTime.month(.abbreviated).day().year())
        } else {
            return date.formatted(.dateTime.month(.abbreviated).day())
        }
    }

}
