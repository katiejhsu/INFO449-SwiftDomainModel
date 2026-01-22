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
        
        let roundedResult = Int(finalAmount + 0.5)
        
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
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
}

////////////////////////////////////
// Person
//
public class Person {
}

////////////////////////////////////
// Family
//
public class Family {
}
