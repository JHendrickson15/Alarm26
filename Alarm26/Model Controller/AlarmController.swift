//
//  AlarmController.swift
//  Alarm26
//
//  Created by Jordan Hendrickson on 5/6/19.
//  Copyright © 2019 Jordan Hendrickson. All rights reserved.
//

import UIKit
import UserNotifications
protocol AlarmScheduler: class {
    func scheduleUserNotifications(alarm: Alarm)
    func cancelUserNotifications(alarm: Alarm)
    
}
extension AlarmScheduler {
    func scheduleUserNotifications(alarm: Alarm) {
        let content = UNMutableNotificationContent()
        content.title = "Alarm"
        content.body = "\(alarm.name)"
        content.sound = .default
        let dateComponents = Calendar.current.dateComponents([.hour , .minute], from: alarm.fireDate)
        let dateTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: alarm.uuid, content: content, trigger: dateTrigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Unable to schedule local notification request: \(error) : \(error.localizedDescription)")
            }
        }

    }
    func cancelUserNotifications(alarm: Alarm){
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.uuid])
    }
}

class AlarmController: AlarmScheduler {

    static let sharedInstance = AlarmController()
    init() {
        alarms = loadFromPersistentStore()
    }
    
    var mockAlarms: [Alarm] {
        let alarm1 = Alarm(fireDate: Date(), name: "Alarm1")
        let alarm2 = Alarm(fireDate: Date(), name: "Alarm2")
        let alarm3 = Alarm(fireDate: Date(), name: "Alarm3")
        return [alarm1 , alarm2 , alarm3]
    }
    
    var alarms: [Alarm] = []
    
    func addAlarm(fireDate: Date , name: String , enabled: Bool) {
        let newAlarm = Alarm(fireDate: fireDate, name: name , enabled: enabled)
        alarms.append(newAlarm)
        scheduleUserNotifications(alarm: newAlarm)
        saveToPersistentStorage()
    }
    func updateAlarm(alarm: Alarm ,fireDate: Date , name: String , enabled: Bool){
        guard let indexOfEntry = alarms.firstIndex(of: alarm ) else {return}
        alarms[indexOfEntry].fireDate = fireDate
        alarms[indexOfEntry].name = name
        saveToPersistentStorage()
    }
    func deleteAlarm (alarm: Alarm){
        guard let indexOfAlarmToDelete = alarms.index(of: alarm) else {return}
        alarms.remove(at: indexOfAlarmToDelete)
        saveToPersistentStorage()
        cancelUserNotifications(alarm: alarm)
        
    }
    
    func convertTime(date: Date) -> String{
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .medium
        
        return timeFormatter.string(from:date)
    }
    func toggleIsOn(alarm: Alarm) {
        if alarm.enabled == false{
            print("Scheduled Notification")
        scheduleUserNotifications(alarm: alarm)
        alarm.enabled = !alarm.enabled
    } else {
            print("Cancelled Notification")
        cancelUserNotifications(alarm: alarm)
        alarm.enabled = !alarm.enabled
    }
}
    func fileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirector = paths[0]
        let filename = "alarm26.json"
        let fullURL = documentDirector.appendingPathComponent(filename)
        
        return fullURL
    }
    func saveToPersistentStorage() {
        let jsonEncoder = JSONEncoder()
        do {
            let data = try jsonEncoder.encode(alarms)
            let url = fileURL()
            try data.write(to: url)
        }catch let error{
            print("jordanError: \(error)")
        }
    }
    func loadFromPersistentStore() -> [Alarm] {
        let jsonDecoder = JSONDecoder()
        do{
            let url = fileURL()
            let data = try Data(contentsOf: url)
            let alarms = try jsonDecoder.decode([Alarm].self, from: data)
            
            return alarms
        }catch let error{
            print("jordanError: \(error)")
        }
        return []
    }
}//end of class

