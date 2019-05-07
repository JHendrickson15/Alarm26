//
//  SwitchTableViewCell.swift
//  Alarm26
//
//  Created by Jordan Hendrickson on 5/6/19.
//  Copyright © 2019 Jordan Hendrickson. All rights reserved.
//

import UIKit

protocol SwitchTableViewCellDelegate: class {
    func toggleAlarmFor(cell: SwitchTableViewCell)
}

class SwitchTableViewCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    weak var delegate : SwitchTableViewCellDelegate?
    
    func updateCell(alarm: Alarm) {
        timeLabel.text = alarm.fireTimeAsString
        nameLabel.text = alarm.name
        alarmSwitch.isOn = alarm.enabled
    }
    
    @IBAction func switchValueChanged(_ sender: Any) {
        delegate?.toggleAlarmFor(cell: self)
    }
    
}
