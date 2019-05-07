//
//  AlarmDetailTableViewController.swift
//  Alarm26
//
//  Created by Jordan Hendrickson on 5/6/19.
//  Copyright © 2019 Jordan Hendrickson. All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController {
    var alarm: Alarm? {
        didSet{
            loadViewIfNeeded()
            updateViews()
        }
    }
    var alarmIsOn: Bool = true
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var alarmLabelTextField: UITextField!
    @IBOutlet weak var enableAlarmButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }

    @IBAction func enableButtonTapped(_ sender: Any) {
        guard let alarm = alarm else {return}
        AlarmController.sharedInstance.toggleIsOn(alarm: alarm)
        updateEnabledButtonFor(alarm)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let alarmLabelTextField = alarmLabelTextField.text else {return}
        if let alarm = alarm {
            print("I am not working")
            AlarmController.sharedInstance.updateAlarm(alarm: alarm, fireDate: datePicker.date , name: alarmLabelTextField, enabled: alarmIsOn)
        }else{
            print("I am working")
            AlarmController.sharedInstance.addAlarm(fireDate: datePicker.date, name: alarmLabelTextField, enabled: alarmIsOn)
        }
        navigationController?.popViewController(animated: true)
    }
    
    private func updateViews(){
        guard let alarm = alarm else {return}
        alarmLabelTextField.text = alarm.name
        datePicker.date = alarm.fireDate
        updateEnabledButtonFor(alarm)
    }
    
    fileprivate func updateEnabledButtonFor(_ alarm: Alarm) {
        if alarm.enabled {
            enableAlarmButton.setTitle("Disable", for: .normal)
            enableAlarmButton.backgroundColor = .red
        } else {
            enableAlarmButton.setTitle("Enable", for: .normal)
            enableAlarmButton.backgroundColor = .green
        }
    }
}
