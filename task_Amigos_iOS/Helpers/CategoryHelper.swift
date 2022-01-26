//
//  CategoryHelper.swift
//  task_Amigos_iOS
//
//  Created by Daniel Miolan on 1/20/22.
//

import Foundation
import UIKit

public class CategoryHelper {
    static func getCategoryColor(category: Category) -> UIColor {
        switch category {
            case Category.work:
            return UIColor(red: 254/255, green: 115/255, blue: 71/255, alpha: 1.0)
            case Category.school:
            return UIColor(red: 105/255, green: 239/255, blue: 245/255, alpha: 1.0)
            case Category.shopping:
            return UIColor(red: 50/255, green: 104/255, blue: 222/255, alpha: 1.0)
            case Category.groceries:
            return UIColor(red: 194/255, green: 57/255, blue: 87/255, alpha: 1.0)
        }
    }
    
    static func getCategoryString(category: Category) -> String {
        switch category {
            case Category.work:
                return "Work"
            case Category.school:
                return "School"
            case Category.shopping:
                return "Shopping"
            case Category.groceries:
                return "Groceries"
        }
    }
    
    static func getCategoryByString(category: String) -> Category {
        switch category.lowercased() {
            case "work":
                return Category.work
            case "school":
                return Category.school
            case "shopping":
                return Category.shopping
            case "groceries":
                return Category.groceries
            default:
                return Category.work
        }
    }
}
