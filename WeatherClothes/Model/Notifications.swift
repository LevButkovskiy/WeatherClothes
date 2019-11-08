//
//  Notifications.swift
//  WeatherClothes
//
//  Created by Lev Butkovskiy on 29/10/2019.
//  Copyright © 2019 Lev Butkovskiy. All rights reserved.
//

import UIKit
import UserNotifications
import YandexMobileMetrica
class Notifications: NSObject, UNUserNotificationCenterDelegate {
    let notificationCenter = UNUserNotificationCenter.current()

    func requestAutorization(){
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            print("Permission granted: \(granted)")
            
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        notificationCenter.getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func scheduleNotification(title: String, body: String){
        print("clicked")
        let content = UNMutableNotificationContent()
        
        content.title = title
        content.body = body
        content.sound = .default
        content.badge = 1
        guard let path = Bundle.main.path(forResource: "1234", ofType: "png") else {
            return;
        }
        let url = URL(fileURLWithPath: path)
        do{
            let attachment = try UNNotificationAttachment(
                identifier: "1234",
                url: url,
                options: nil)
            content.attachments = [attachment]
        }
        catch{
            print("Attachment could not be loaded")
        }
        
        let date = Date()
        var timeInt = Int()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        if(hour < 9){
            timeInt = (9-hour)*60
        }
        else if(hour > 9){
            timeInt = (24-hour+9)*60*60
        }
        else{
            timeInt = 24*60
        }
        timeInt = timeInt - minutes*60
        print(timeInt)
        let newDate = Date(timeInterval: TimeInterval(timeInt), since: date)
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: newDate)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        /*let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        YMMYandexMetrica.reportEvent("В \(hour):\(minutes) было установлено уведомление, которое сработает через \(timeInt) секунд") { (error) in
            YMMYandexMetrica.reportEvent("Ошибка в reportEvent о уведомлении", onFailure: { (error) in
                print(error.localizedDescription)
            })
        }*/
        let identifier = "Local notification"
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        notificationCenter.add(request) { (error) in
            if let error = error{
                print("Error: \(error.localizedDescription)")
            }
        }
        
    }
}