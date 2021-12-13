//
//  ReminderViewController.swift
//  teumsae
//
//  Created by 오수민 on 2021/12/13.
//

import Foundation
import UIKit

class ReminderDetailViewController: UITableViewController {
    
    typealias ReminderChangeAction = (Reminder) -> Void
    
    private var reminder: Reminder?
    private var tempReminder: Reminder?
    private var dataSource: UITableViewDataSource?
    private var reminderChangeAction: ReminderChangeAction?
    
    func configure(with reminder: Reminder, changeAction: @escaping ReminderChangeAction) {
        self.reminder = reminder
        self.reminderChangeAction = changeAction
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setEditing(false, animated: false)
        navigationItem.setRightBarButton(editButtonItem, animated: false)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ReminderDetailEditDataSource.dateLabelCellIdentifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let navigationController = navigationController,
           !navigationController.isToolbarHidden {
            navigationController.setToolbarHidden(true, animated: animated)
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        guard let reminder = reminder else {
            fatalError("No reminder found for detail view")
        }
        if editing {
            dataSource = ReminderDetailEditDataSource(reminder: reminder) { reminder in
                self.tempReminder = reminder
                self.editButtonItem.isEnabled = true
            }
            navigationItem.title = NSLocalizedString("Edit Reminder", comment: "edit reminder nav title")
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTrigger))
        } else {
            if let tempReminder = tempReminder {
                self.reminder = tempReminder
                self.tempReminder = nil
                reminderEditAction?(tempReminder)
                dataSource = ReminderDetailViewDataSource(reminder: tempReminder)
            } else {
                dataSource = ReminderDetailViewDataSource(reminder: reminder)
            }
            navigationItem.title = NSLocalizedString("View Reminder", comment: "view reminder nav title")
            navigationItem.leftBarButtonItem = nil
            editButtonItem.isEnabled = true
        }
        tableView.dataSource = dataSource
        tableView.reloadData()
    }
    
    @objc
    func cancelButtonTrigger() {
        tempReminder = nil
        setEditing(false, animated: true)
    }
}
