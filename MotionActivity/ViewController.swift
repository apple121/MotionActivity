//
//  ViewController.swift
//  MotionActivity
//
//  Created by g-2016 on 2015/04/01.
//  Copyright (c) 2015年 aki120121. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

    var errorLabel = UILabel(frame: CGRectMake(0, 0, 100, 20))
    var todayLabel = UILabel(frame: CGRectMake(0, 30, 320, 20))
    
    var stepsLabel = UILabel(frame: CGRectMake(60, 70, 100, 40))
    var distanceLabel = UILabel(frame: CGRectMake(60, 100, 200, 40))
    var speedLabel = UILabel(frame: CGRectMake(60, 130, 200, 40))
    var floorsAscendedLabel = UILabel(frame: CGRectMake(60, 160, 200, 40))
    var floorsDescendedLabel = UILabel(frame: CGRectMake(60, 190, 200, 40))
    
    let now:NSDate = NSDate()
    let pedometer = CMPedometer()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        startStepCounting()
        
        // フォーマット
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        
        // 日時表示
        self.todayLabel.text = "\(dateFormatter.stringFromDate(now))の計測結果"
        todayLabel.textAlignment = NSTextAlignment.Center
        self.view.addSubview(self.todayLabel)
            }
    
    func startStepCounting() {
        //             CMPedometerが利用出来るか確認
        if CMPedometer.isStepCountingAvailable() {
            
            // 時間取得
            let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
            let comp = calendar.components(NSCalendarUnit.CalendarUnitHour   |
                NSCalendarUnit.CalendarUnitMinute |
                NSCalendarUnit.CalendarUnitSecond,
                fromDate: now)
            // NSTimeInterval型にして今日の秒数格納
            let totalSecond = NSTimeInterval(comp.hour * 60 * 60 + comp.minute * 60 + comp.second)
            println("\(comp.hour)時\(comp.minute)分\(comp.second)秒 Total : \(totalSecond)")
            
            // 本日の0:00から
            let fromDate = NSDate(timeIntervalSinceNow: -totalSecond)
            // 現在まで
            pedometer.queryPedometerDataFromDate(fromDate, toDate: now, withHandler: {
                /*[unowned self]*/ data,error in
                dispatch_async(dispatch_get_main_queue(),{
                    println("updata")
                    if error != nil {
                        // エラー
                        self.errorLabel.text = "エラー : \(error)"
                        println("エラー : \(error)")
                    } else {
                        println("測定")
                       
                        
                        let lengthFormatter = NSLengthFormatter()
                        // 歩数
                        let steps = data.numberOfSteps
                        // 距離
                        let distance = data.distance.doubleValue
                        // 早さ
                        let time = data.endDate.timeIntervalSinceDate(data.startDate)
                        let speed = distance / time
                        // 上った回数
                        let floorsAscended = data.floorsAscended
                        // 降りた回数
                        let floorsDescended = data.floorsDescended
                        // 結果をラベルに出力
                        self.stepsLabel.text = "歩数 : \(steps)"
                        self.distanceLabel.text = "距離 : \(lengthFormatter.stringFromMeters(distance))"
                        self.speedLabel.text = "速さ : \(lengthFormatter.stringFromMeters(speed)) / s"
                        self.floorsAscendedLabel.text = "上った回数 : \(floorsAscended)"
                        self.floorsDescendedLabel.text = "降りた回数 : \(floorsDescended)"
                        self.view.addSubview(self.stepsLabel)
                        self.view.addSubview(self.distanceLabel)
                        self.view.addSubview(self.speedLabel)
                        self.view.addSubview(self.floorsAscendedLabel)
                        self.view.addSubview(self.floorsDescendedLabel)
                    }
                })
            })
        }
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

