//
//  Reducer.swift
//  Assignment3
//
//  Created by Jignesh on 11/07/22.
//

import ReSwift

func appReducer(action: Action, state: AppState?) -> AppState {
    var state = state ?? AppState()

    guard let action = action as? AppAction else {
        return state
    }

    switch action {
    
    case .fetchTaskData(let tasks):
        state.taskData = tasks
    case .addTask(let task):
        state.taskData.append(task)
        JSONDataManager.save(state.taskData, with: "test")
    case .makeItFinished(let index):
        state.taskData[index].isFinished = true
        JSONDataManager.save(state.taskData, with: "test")
    case .deleteTask(let index):
        state.taskData.remove(at: index)
        JSONDataManager.save(state.taskData, with: "test")
    }

    return state
}
