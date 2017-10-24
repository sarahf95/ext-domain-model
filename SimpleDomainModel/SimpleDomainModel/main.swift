//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
    return "I have been tested"
}

open class TestMe {
    open func Please() -> String {
        return "I have been tested"
    }
}

////////////////////////////////////
// Money
//
public struct Money {
    public var amount : Double
    public var currency : String
    public func add(amt: Double) -> Double {
        return self.amount + amt
    }
    public func sub(amt: Double) -> Double {
        return self.amount - amt
    }
    
    protocol Mathematics {
        func add(amt: Double) -> Double
        func sub(amt: Double) -> Double
        
    }
    
    init(amount: Double, currency: String){
        self.amount = amount
        self.currency = currency
        return
    }
    
    public func convert(_ to: String) -> Money {
        switch self.currency {
        case "USD":
            switch to {
            case "GBP":
                return Money(amount: self.amount * 0.5, currency: "GBP")
            case "EUR":
                return Money(amount: self.amount * 1.5, currency: "EUR")
            case "CAN":
                return Money(amount: self.amount * 1.25, currency: "CAN")
            default:
                return Money(amount: 0, currency : "Unidentified currency")
            }
        case "GBP":
            switch to {
            case "USD":
                return Money(amount: self.amount * 2, currency: "USD")
            case "EUR":
                return Money(amount: self.amount * 3, currency: "EUR")
            case "CAN":
                return Money(amount: self.amount * 1.64, currency: "CAN")
            default:
                return Money(amount: 0, currency: "Unidentified currency")
            }
        case "EUR":
            switch to {
            case "USD":
                return Money(amount: self.amount * (2/3), currency: "USD")
            case "GBP":
                return Money(amount: self.amount * 0.9, currency: "GBP")
            case "CAN":
                return Money(amount: self.amount * 0.83, currency: "CAN")
            default:
                return Money(amount: 0, currency: "Unidentified currency")
            }
        case "CAN":
            switch to {
            case "GBP":
                return Money(amount: self.amount * (1/3), currency: "GBP")
            case "EUR":
                return Money(amount: self.amount * 1.2, currency: "EUR")
            case "USD":
                return Money(amount: self.amount * 0.8, currency: "USD")
            default:
                return Money(amount: 0, currency: "Unidentified currency")
            }
        default:
            return self
        }
    }
    
    
    public func add(_ to: Money) -> Money {
        if(to.currency == self.currency) {
            return Money(amount: self.amount + to.amount, currency: self.currency)
        } else {
            let converted = self.convert(to.currency)
            return Money(amount: to.amount + converted.amount, currency: to.currency)
        }
    }
    
    public func subtract(_ from: Money) -> Money {
        let money : Money = Money(amount: from.amount - self.amount, currency: self.currency)
        return money
    }
    
}



////////////////////////////////////
// Job
//
open class Job {
    fileprivate var title : String
    fileprivate var type : JobType
    
    public enum JobType {
        case Hourly(Double)
        case Salary(Int)
    }
    public init(title : String, type : JobType) {
        self.title = title
        self.type = type
        return
    }
    
    open func calculateIncome(_ hours: Int) -> Int {
        switch self.type {
        case .Hourly(let pay) :
            return Int(pay * Double(hours))
        case .Salary(let pay) :
            return pay
        }
    }
    
    open func raise(_ amt : Double) {
            switch self.type {
            case .Hourly(var pay) :
                 self.type = .Hourly(pay + amt)
            case .Salary(var pay) :
                 self.type = .Salary(Int(amt + Double(pay)))
         }
        
    }
}


////////////////////////////////////
// Person
//

open class Person {
    fileprivate var firstName : String = ""
    fileprivate var lastName : String = ""
    fileprivate var age : Int = 0
    
    fileprivate var _job : Job? = nil
    open var job : Job? {
        get { return self._job }
        set(value) {
            if(self.age >= 16){
                self._job = value
            }
        }
    }
    
    fileprivate var _spouse : Person? = nil
    open var spouse : Person? {
        get { return self._spouse }
        set(value) {
            if(self.age >= 18){
                self._spouse = value
            }
        }
    }
    
    public init(firstName : String, lastName: String, age : Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        return
    }
    
    open func toString() -> String {
        return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(self.job) spouse:\(self.spouse)]"
    }
}


////////////////////////////////////
// Family
//
open class Family {
    fileprivate var members : [Person] = []
    
    public init(spouse1: Person, spouse2: Person) {
        if(spouse1.spouse == nil && spouse2.spouse == nil){
            spouse1.spouse = spouse2
            spouse2.spouse = spouse1
            members.append(spouse1)
            members.append(spouse2)
        }
    }
    
    open func haveChild(_ child: Person) -> Bool {
        for i in 0...members.count-1 {
            if(members[i].age >= 21){
                let newChild = child;
                newChild.age = 0;
                self.members.append(newChild)
                return true
            }
        }
        return false
    }
    
    open func householdIncome() -> Int {
        var total = 0
        for i in 0...members.count-1 {
            if(members[i]._job != nil){
                total += members[i]._job!.calculateIncome(200)
            }
        }
        return total
    }
}


