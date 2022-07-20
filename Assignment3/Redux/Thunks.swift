//
//  Thunks.swift
//  Assignment3
//
//  Created by Jignesh on 11/07/22.
//

import ReSwift
import ReSwiftThunk

let fetchTasksThunk = Thunk<AppState> { dispatch, getState in
    
    guard let state = getState(),
          let data = JSONDataManager.load("test", with: [Task].self) else { return }
    
    DispatchQueue.main.async {
        dispatch(
            AppAction.fetchTaskData(tasks: data)
        )
    }
    
}
