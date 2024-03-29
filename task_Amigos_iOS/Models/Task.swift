//
//  Task.swift
//  task_Amigos_iOS
//
//  Created by Daniel Miolan on 1/11/22.
//

import UIKit
import Foundation

class Task {
    // Attributes
    private var id: Int
    private var name: String
    private var description: String
    private var category: Category
    private var status: Status
    private var subTask: [Int] // Array of task ID
    private var images: [String]
    private var audios: [String]
    private var dueDate: Date
    private var createdDate: Date
    private var isSubtask: Bool
    
    // Constructor
    init(id: Int, name: String, description: String, category: Category, status: Status, subTask: [Int], images: [String], audios: [String], dueDate: Date, createdDate: Date, isSub: Bool) {
        self.id = id
        self.name = name
        self.description = description
        self.category = category
        self.status = status
        self.subTask = subTask
        self.images = images
        self.audios = audios
        self.dueDate = dueDate
        self.createdDate = createdDate
        self.isSubtask = isSub
    }
    
    // Setters
    public func setId(id: Int) -> Void {
        self.id = id
    }
    
    public func setName(name: String) -> Void {
        self.name = name
    }
    
    public func setDescription(description: String) -> Void {
        self.description = description
    }
    
    public func setCategory(category: Category) -> Void {
        self.category = category
    }
    
    public func setStatus(status: Status) -> Void {
        self.status = status
    }
    
    public func setSubTask(subTask: [Int]) -> Void {
        self.subTask = subTask
    }
    
    public func setImages(images: [String]) -> Void {
        self.images = images
    }
    
    public func setAudios(audios: [String]) -> Void {
        self.audios = audios
    }
    
    public func setDueDate(dueDate: Date) -> Void {
        self.dueDate = dueDate
    }
    
    public func setCreatedDate(createdDate: Date) -> Void {
        self.createdDate = createdDate
    }
    
    public func setissub(isSub: Bool) -> Void {
        self.isSubtask = isSub
    }
    
    // Getters
    public func getId() -> Int {
        return id
    }
    
    public func getName() -> String {
        return name
    }
    
    public func getDescription() -> String {
        return description
    }
    
    public func getCategory() -> Category {
        return category
    }
    
    public func getStatus() -> Status {
        return status
    }
    
    public func getSubTask() -> [Int] {
        return subTask
    }
    
    public func getImages() -> [String] {
        return images
    }
    
    public func getAudios() -> [String] {
        return audios
    }
    
    public func getDueDate() -> Date {
        return dueDate
    }
    
    public func getCreatedDate() -> Date {
        return createdDate
    }
    
    public func appendSubtask(subId: Int){
        subTask.append(subId)
    }
    
    public func getIsSub() -> Bool{
        return isSubtask
    }
}
