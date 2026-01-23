struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money

public struct Money {
    let amount: Int
    let currency: String
    
    // initializer
    init(amount: Int, currency: String) {
        let validCurrencies = ["USD", "GBP", "EUR", "CAN"]
        
        // handle invalid currencies
        if validCurrencies.contains(currency) {
            self.currency = currency
        } else {
            self.currency = "Invalid"
        }
        self.amount = amount
    }
    
    func convert(_ target: String) -> Money {
        // normalize
        var usdAmount: Double = 0.0
        
        switch self.currency {
                case "USD": usdAmount = Double(self.amount)
                case "GBP": usdAmount = Double(self.amount) * 2.0
                case "EUR": usdAmount = Double(self.amount) / 1.5
                case "CAN": usdAmount = Double(self.amount) / 1.25
                default: usdAmount = 0.0
            }
        
        var finalAmount: Double = 0.0
        
        // convert
        switch target {
            case "USD": finalAmount = usdAmount
            case "GBP": finalAmount = usdAmount * 0.5
            case "EUR": finalAmount = usdAmount * 1.5
            case "CAN": finalAmount = usdAmount * 1.25
            default: finalAmount = 0.0
        }
        
        let roundedResult = Int(finalAmount)
        
        return Money(amount: roundedResult, currency: target)
    }
    
    func add (_ other: Money) -> Money {
        let convertedOther = other.convert(self.currency)
        return Money(amount: self.amount + convertedOther.amount, currency: self.currency)
    }
    func subtract(_ other: Money) -> Money {
        let convertedOther = other.convert(self.currency)
        return Money(amount: self.amount - convertedOther.amount, currency: self.currency)
    }
}

////////////////////////////////////
// Job
//
public class Job {
    var title: String
    var type: JobType
    
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
    
    // initializer
    init(title: String, type: JobType) {
        self.title = title
        self.type = type
    }
    
    func calculateIncome(_ hours: Int) -> Int {
        if case let .Salary(yearlyAmount) = self.type {
            return Int(yearlyAmount)
        } else if case let .Hourly(hourlyWage) = self.type {
            return Int(hourlyWage * Double(hours))
        }
        return 0 // fallback
    }
    
    // raise by amt
    func raise(byAmount: Double) {
        if case let .Hourly(wage) = self.type {
            self.type = .Hourly(wage + byAmount)
        } else if case let .Salary(amount) = self.type {
            self.type = .Salary(amount + UInt(byAmount)) // Convert to UInt since Salary takes UInt
        }
    }

    // raise by percentage
    func raise(byPercent: Double) {
        if case let .Hourly(wage) = self.type {
            self.type = .Hourly(wage + (wage * byPercent))
        } else if case let .Salary(amount) = self.type {
            let currentAmount = Double(amount)
            let newAmount = currentAmount + (currentAmount * byPercent)
            self.type = .Salary(UInt(newAmount)) // Convert to UInt since Salary takes UInt
        }
    }
}

////////////////////////////////////
// Person
//
public class Person {
    var firstName: String
    var lastName: String
    var age: Int
    var job: Job?
    var spouse: Person?
    
    // initializer
    public init(firstName: String, lastName: String, age: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    //toString
    func toString () -> String {
        // use nil if the optional properties are empty
        let jobTitle = self.job?.title ?? "nil"
        let spouseName = self.spouse?.firstName ?? "nil"
                
        return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(jobTitle) spouse:\(spouseName)]"
    }
    
}

////////////////////////////////////
// Family
// Family
/*
Finally, a family is a group of people, some of whom have jobs, some don't, but whose total income is what's taxed come April 1. Create a class called Family that has one property, members, which is a collection of Persons. US law dictates that a family consists of two Persons at a minimum (spouse1 and spouse2), so create an initializer that takes two Person parameters (called spouse1 and spouse2 to avoid genderfying parameter names). However, US law also frowns on being married more than once at the same time, so make sure your two parameters each have no spouse, and set their respective spouse fields to each other.

Next, flesh out the haveChild method, which takes a Person parameter to add to the family. However, US law also frowns on minors having children, so let's make sure that at least one Person of the two spouses is over the age of 21. If the Family cannot have a child, then this method should return false; this method should return true only if the child can be successfully added to the Family.

Finally, the householdIncome method will calculate the complete income for the Family. */

public class Family {
    var members: [Person]
    public init(spouse1: Person, spouse2: Person) {
        if spouse1.spouse == nil && spouse2.spouse == nil {
            spouse1.spouse = spouse2
            spouse2.spouse = spouse1
            
            self.members = [spouse1, spouse2]
        } else {
            // Provide a default empty state to satisfy the compiler
            self.members = []
        }
    }
    
    func haveChild(_ child: Person) -> Bool {
        // get spouses from members arr
        let spouse1 = members[0]
        let spouse2 = members[1]

        // check if at least one spouse is over 21
        if spouse1.age > 21 || spouse2.age > 21 {
            members.append(child)
            return true
        } else {
            return false
        }
    }
    
    func householdIncome() -> Int {
        var total = 0
        for member in members {
            total += member.job?.calculateIncome(2000) ?? 0
        }
        return total
    }
}
