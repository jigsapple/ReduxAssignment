//
//  Action.swift
//  Assignment3
//
//  Created by Jignesh on 11/07/22.
//

import ReSwift

enum AppAction: Action {
    case fetchTaskData(tasks: [Task])
    case addTask(task: Task)
    case makeItFinished(indexAt: Int)
    case deleteTask(indexAt: Int)
}
