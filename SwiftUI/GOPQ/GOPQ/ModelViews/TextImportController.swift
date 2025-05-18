// pagi(location): 10.00 - 12.30
// siang: 14.00 - 18.00
// babi: 10.00 - 15.00

// shawn andrew : pagi
// adeline charlotte : siang, pagi
// raphael : babi

import Foundation

final class TextToScheduleItemsParser {
    private struct TimeGroup {
        let startHour: Int
        let startMinute: Int
        let endHour: Int
        let endMinute: Int
        let location: String
    }

    private var buffer: String
    init(_ source: String) {
        buffer = source
    }
    private func parseTimeGroup() -> [String: TimeGroup] {
        let regex =
            /^([a-zA-Z0-9 ]*)\s*(\([a-zA-Z0-9 ]*\))?\s*:\s*([0-9]{2}):([0-9]{2})\s*-\s*([0-9]{2}):([0-9]{2})\s*/
        let groups: [(String, TimeGroup)?] =
            buffer
            .components(separatedBy: .newlines)
            .compactMap { line in
                if let match = line.wholeMatch(of: regex) {
                    return (
                        String(match.1)
                            .trimmingCharacters(in: .whitespaces),
                        TimeGroup(
                            startHour: Int(match.3) ?? 0,
                            startMinute: Int(match.4) ?? 0,
                            endHour: Int(match.5) ?? 0,
                            endMinute: Int(match.6) ?? 0,
                            location: String(match.2 ?? "")
                                .trimmingCharacters(in: CharacterSet(charactersIn: "()"))
                                .trimmingCharacters(in: .whitespaces)
                        )
                    )
                }
                return nil
            }
        var res = [String: TimeGroup]()
        for group in groups {
            if let (groupName, timeGroup) = group {
                res[groupName] = timeGroup
            }
        }
        return res
    }
    private func parsePerson() -> [(String, [String])] {
        let regex = /^([a-zA-Z0-9 ]*)\s*:\s*([a-zA-Z0-9 ,]*)\s*$/
        let lines =
            buffer
            .components(separatedBy: .newlines)
        var res = [(String, [String])]()
        for line in lines {
            if let match = line.wholeMatch(of: regex) {
                res.append(
                    (
                        String(match.1)
                            .trimmingCharacters(in: .whitespaces) ,
                        String(match.2)
                            .split(separator: ",")
                            .map { str in
                                return str.trimmingCharacters(in: .whitespaces)
                            }
                    )
                )
            }
        }
        return res
    }
    func parse() -> [ScheduleItemData] {
        let groups = parseTimeGroup()
        let employees = parsePerson()
        var res = [ScheduleItemData]()
        for (name, assignedGroups) in employees {
            for group in assignedGroups {
                res.append(
                    ScheduleItemData(
                        employeeName: name,
                        startTime: makeTime(
                            hour: groups[group]?.startHour ?? 0,
                            min: groups[group]?.startMinute ?? 0),
                        endTime: makeTime(
                            hour: groups[group]?.endHour ?? 0,
                            min: groups[group]?.endMinute ?? 0),
                        location: groups[group]?.location ?? "",
                        message: group,
                        soundName: ""
                    )
                )
            }
        }
        return res
    }
}
