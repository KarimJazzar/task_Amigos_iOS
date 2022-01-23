//
//  TaskManager.swift
//  task_Amigos_iOS
//
//  Created by Daniel Miolan on 1/20/22.
//

import Foundation

class TaskManager {
    private var taskList: [Task]
    private var incompleteTasks: [Task]
    private var completeTasks: [Task]
    
    init() {
        taskList = [Task]()
        incompleteTasks = [Task]()
        completeTasks = [Task]()
    }
    
    func LoadData() {
        // HERE WE NEED TO EXECUTE THE CODE TO LOAD PERSISTEN DATA
    }
    
    func GetTaskByIndex(index: Int) -> Task {
        return taskList[index]
    }
}
