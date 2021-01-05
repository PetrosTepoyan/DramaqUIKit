//
//  RepetitionPatterns.swift
//  Dramaq
//
//  Created by Петрос Тепоян on 12/22/20.
//

import Foundation

func getDistanceForNonWeekday(today: Date, pattern : NonWeekday) -> TimeInterval {
    var dateComponent = DateComponents()
    switch pattern {
    case .day: return 60 * 60 * 24
    case .twoDays: return 2 * 60 * 60 * 24
    case .threeDays: return 3 * 60 * 60 * 24
        
    case .week: return 7 * 60 * 60 * 24
    case .twoWeeks: return 2 * 7 * 60 * 60 * 24
    case .threeWeeks: return 3 * 7 * 60 * 60 * 24
        
    case .month: dateComponent.month       = 1
    case .twoMonths: dateComponent.month   = 2
    case .threeMonths: dateComponent.month = 3
    }
    let futureDate = Calendar.current.date(byAdding: dateComponent, to: today)!
    return today.distance(to: futureDate)
}

extension Date {

  static func today() -> Date {
      return Date()
  }

  func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
    return get(.next,
               weekday,
               considerToday: considerToday)
  }

  func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
    return get(.previous,
               weekday,
               considerToday: considerToday)
  }

  func get(_ direction: SearchDirection,
           _ weekDay: Weekday,
           considerToday consider: Bool = false) -> Date {

    let dayName = weekDay.rawValue

    let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }

    assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")

    let searchWeekdayIndex = weekdaysName.firstIndex(of: dayName)! + 1

    let calendar = Calendar(identifier: .gregorian)

    if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
      return self
    }

    var nextDateComponent = calendar.dateComponents([.hour, .minute, .second], from: self)
    nextDateComponent.weekday = searchWeekdayIndex

    let date = calendar.nextDate(after: self,
                                 matching: nextDateComponent,
                                 matchingPolicy: .nextTime,
                                 direction: direction.calendarSearchDirection)

    return date!
  }

}
// MARK: Helper methods
extension Date {
  func getWeekDaysInEnglish() -> [String] {
    var calendar = Calendar(identifier: .gregorian)
    calendar.locale = Locale(identifier: "en_US_POSIX")
    return calendar.weekdaySymbols
  }

  enum SearchDirection {
    case next
    case previous

    var calendarSearchDirection: Calendar.SearchDirection {
      switch self {
      case .next:
        return .forward
      case .previous:
        return .backward
      }
    }
  }
}

protocol PepetitionPattern {}

enum Weekday: String, PepetitionPattern {
  case monday, tuesday, wednesday, thursday, friday, saturday, sunday
}

enum NonWeekday: String, PepetitionPattern {
    case day, twoDays, threeDays
    
    case week, twoWeeks, threeWeeks
    
    case month, twoMonths, threeMonths
    
}

//func moneyPerDay(income: Double, forNextNDays: Int) -> Double {
//    let today = Date.today()
//    
//    let interval = DateInterval(start: today, duration: TimeInterval(forNextNDays * 24 * 60 * 60))
//    var amount = 0.0
//    for record in records {
//        for pattern in record.repetitionPattern!.split(separator: ",") {
//            if let pattern = Weekday(rawValue: String(pattern)) {
//                var current = today.next(pattern)
//                while current <= interval.end {
//                    amount += record.price
//                    current = current.next(pattern)
//                    
//                }
//            } else if let pattern = NonWeekday(rawValue: String(pattern)) {
//                let distance = getDistanceForNonWeekday(today: today, pattern: pattern)
//                var current = today.addingTimeInterval(distance)
//                while current <= interval.end {
//                    amount += record.price
//                    current = current.addingTimeInterval(distance)
//                    
//                }
//            }
//        }
//    }
//    
//    return ( Double(income) - amount ) / Double(forNextNDays)
//    
//}
//
//func moneyPerDay(income: Double, nextIncomeDate : Date) -> Double {
//    let today = Date()
//    let interval = DateInterval(start: today, end: nextIncomeDate)
//    let numberOfDays = Int(interval.duration / 60 / 60 / 24)
//    
//    return moneyPerDay(income: income, forNextNDays: numberOfDays)
//}
