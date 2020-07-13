//
//  CoreDataManager.swift
//  Registration
//
//  Created by Gleb Uvarkin on 13.07.2020.
//  Copyright © 2020 Gleb Uvarkin. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager: NSObject {
    
//    MARK: - Shared instance
    
    static let shared = {
        return CoreDataManager()
    } ()
    
    private override init() {
        super.init()
    }
    
//    MARK: - Add objects into Core Data
    
    func addUserRecordIntoCoreData(user: UserInfo) {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let viewContext = appdelegate.persistentContainer.viewContext
        
        let userObj = User(context: viewContext)
        userObj.name = user.name
        userObj.surName = user.surName
        userObj.login = user.login
        userObj.password = user.password
        
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch let error as NSError {
                print("Error in saving core data: ",
                error)
            }
        }
    }
    
    func addCarRecordIntoCoreData(car: CarInfo) {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let viewContext = appdelegate.persistentContainer.viewContext
        
        let carObj = Car(context: viewContext)
        carObj.name = car.name
        carObj.toUser = fetchUser()
        
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch let error as NSError {
                print("Error in saving core data: ",
                      error)
            }
        }
    }
    
//    MARK: - Fetch objects from Core Data
    
    func fetchUserInfo()->UserInfo? {
        let user = fetchUser()
        
        if let name = user?.name, let surName = user?.surName, let login = user?.login, let password = user?.password {
            return UserInfo(name: name, surName: surName, login: login, password: password)
        } else {
            return nil
        }
    }
    
    func fetchCarsOfUser()->[CarInfo]? {
        var cars: [CarInfo] = Array<CarInfo>()
        if let carsObj = fetchUser()?.toCar as? Set<Car> {
            carsObj.forEach({ (carObj) in
                if let name = carObj.name {
                    let car = CarInfo(name: name)
                    cars.append(car)
                }
            })
        }
        return cars.sorted { (carInfoFirst, carInfoSecond) -> Bool in
            carInfoFirst.name < carInfoSecond.name
        }
    }
    
//    MARK: - Delete objects in Core Data
    
    func deleteUserInfo() {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let viewContext = appdelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        
        do {
            let users = try viewContext.fetch(fetchRequest)
            for user in users {
                viewContext.delete(user)
            }
        } catch let error as NSError {
            print("Core data deleting error: ", error)
        }
        
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch let error as NSError {
                print("Core data saving error: ", error)
            }
        }
    }
    
    func deleteCarsInfo() {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let viewContext = appdelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        
        do {
            let cars = try viewContext.fetch(fetchRequest)
            for car in cars {
                viewContext.delete(car)
            }
        } catch let error as NSError {
            print("Core data deleting error: ", error)
        }
        
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch let error as NSError {
                print("Core data saving error: ", error)
            }
        }
    }
    
    func deleteCarInfo(car: CarInfo) {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let viewContext = appdelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        let predicate = NSPredicate(format: "name == %@", car.name)
        fetchRequest.predicate = predicate
        
        do {
            let cars = try viewContext.fetch(fetchRequest)
            for car in cars {
                viewContext.delete(car)
            }
        } catch let error as NSError {
            print("Core data deleting error: ", error)
        }
        
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch let error as NSError {
                print("Core data saving error: ", error)
            }
        }
    }
    
//    MARK: - Take user entity
    
    private func fetchUser()->User? {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        
        let viewContext = appdelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.fetchLimit = 1
        do {
            let users = try viewContext.fetch(fetchRequest)
            if let user = users.first {
                return user
            } else {
                return nil
            }
            
        } catch let error as NSError {
            print("Error in fetching core data: ", error)
            return nil
        }
    }
}
