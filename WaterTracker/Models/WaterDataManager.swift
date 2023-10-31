//
//  WaterDataManager.swift
//  WaterTracker
//
//  Created by 김우현 on 2023/06/07.
//

import UIKit

struct WaterManager {
    
    private var oneDrinkWater:[Int] = []
    private var oneDayWater:[Double] = []
    
    let user = UserDefaults.standard
    
    var percentage = 0.0
    
    mutating func getOneDrinkWaterList() -> [Int] {
        oneDrinkWater = [100, 150, 200, 250, 300, 350, 400, 450, 500, 550, 600]
        return oneDrinkWater
    }
    
    mutating func getOneDayWaterList() -> [Double]{
        oneDayWater = [1.5, 1.6, 1.7, 1.8, 1.9, 2, 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.7, 2.8, 2.9, 3]
        return oneDayWater
    }
    
    mutating func waterPercent(ml: Double, L: Double) -> Double {
        
        let change = L * 1000
        let result = (ml / change) * 100.0
        
        percentage = user.double(forKey: "percent")
        
        percentage += result
        
        user.set(percentage, forKey: "percent")
        
        return user.double(forKey: "percent")
    }
    
    func waterProgressPercent(ml: Double, L: Double) -> Double {
        let Liter = L * 1000
        let percent = (ml / Liter) * 100.0
        
        let range = 1.0 / 100
        let result = range * percent
        
        return result
    }
}
