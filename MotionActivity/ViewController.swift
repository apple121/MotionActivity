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
    var stepsLabel = UILabel(frame: CGRectMake(50, 50, 100, 40))
    var resultLabel = UILabel(frame: CGRectMake(0, 30, 320, 20))
    
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
        
        let ioj = 2
        // 日時表示
        self.resultLabel.text = "\(dateFormatter.stringFromDate(now))の計測結果"
        resultLabel.textAlignment = NSTextAlignment.Center
        self.view.addSubview(self.resultLabel)
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
                            + "\n\n距離 : \(lengthFormatter.stringFromMeters(distance))"
                            + "\n\n速さ : \(lengthFormatter.stringFromMeters(speed)) / s"
                            + "\n\n上った回数 : \(floorsAscended)"
                            + "\n\n降りた回数 : \(floorsDescended)"
                        self.view.addSubview(self.stepsLabel)
                        
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

