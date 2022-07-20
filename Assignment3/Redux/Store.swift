//
//  Store.swift
//  Assignment3
//
//  Created by Jignesh on 11/07/22.
//

import ReSwift
import ReSwiftThunk

// Redux Store is configured with Thunk Middleware to use it
let thunksMiddleware: Middleware<AppState> = createThunkMiddleware()

//Global Store
let mainStore = Store(
    reducer: appReducer,
    state: AppState(),
    middleware: [thunksMiddleware]
)

