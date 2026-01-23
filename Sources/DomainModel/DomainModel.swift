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
        var usdAmount: Double = 0.0
        
        // normalize to USD
        switch self.currency {
            case "USD": usdAmount = Double(self.amount)
            case "GBP": usdAmount = Double(self.amount) * 2.0
            case "EUR": usdAmount = Double(self.amount) / 1.5
            case "CAN": usdAmount = Double(self.amount) / 1.25
            default: usdAmount = 0.0
        }
        
        // convert to Target
        var finalAmount: Double = 0.0
        switch target {
            case "USD": finalAmount = usdAmount
            case "GBP": finalAmount = usdAmount * 0.5
            case "EUR": finalAmount = usdAmount * 1.5
            case "CAN": finalAmount = usdAmount * 1.25
            default: finalAmount = 0.0
        }
        
        let roundedResult = Int(finalAmount.rounded())
        return Money(amount: roundedResult, currency: target)
    }

    func add(_ other: Money) -> Money {
        // convert self to other
        let convertedSelf = self.convert(other.currency)
        
        // add them together in that curr
        return Money(amount: convertedSelf.amount + other.amount, currency: other.currency)
    }
    
    func subtract(_ other: Money) -> Money {
        // convert self to the other currency
        let convertedSelf = self.convert(other.currency)
        
        // sub other in that curr
        return Money(amount: convertedSelf.amount - other.amount, currency: other.currency)
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
    
    // declare w age restrictions
    var job: Job? {
        didSet {
        if age < 16 { job = nil }
        }
    }
    
    var spouse: Person? {
        didSet {
            if age < 18 { spouse = nil }
        }
    }
    
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
