//
//  ImagerManager.swift
//  task_Amigos_iOS
//
//  Created by febinrukfan772 on 1/20/22.
//

import Foundation

class ImagesManager {
    //attributes
    private var imgName: String
    private var createdDate: Date
    
    //contstructor
    init(imgName: String,createdDate: Date){
        self.imgName = imgName
        self.createdDate = createdDate
    }
    
    //setters
    public func setImgName(imgName: String) -> Void {
        self.imgName = imgName
    }
    
    public func setCreatedSate(createdDate: Date) -> Void {
        self.createdDate = createdDate
    }
    
    //getters
    public func getImgName() -> String {
        return imgName
    }

    public func getCreatedDate() -> Date {
        return createdDate
    }
    
    func addImage(){
        
    }
    
    func saveImage(){
        
    }
    
    
}

