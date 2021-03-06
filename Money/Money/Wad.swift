//
//  Wad.swift
//  Money
//
//  Created by Eugenio Barquín on 27/4/17.
//  Copyright © 2017 Eugenio Barquín. All rights reserved.
//

import Foundation

typealias Bills = [Bill]

struct Wad{
    var _bills = Bills()
    
    var billCount : Int {
        get{
            return _bills.count
        }
    }
}

extension Wad : Money{
    
    init(amount: Int, currency: Currency){
        _bills.append(Bill(amount: amount, currency: currency))
    }
    
    func times(_ n:Int)->Wad{
        let total = _bills.map{
            $0.times(n)
        }
        return Wad(_bills: total)
    }
    
    func plus(_ addend: Wad)-> Wad{
        return Wad(_bills: _bills + addend._bills)
    }
    
    func plus(_ addend: Bill)-> Wad{
        var bills = _bills
        bills.append(addend)
        
        return Wad(_bills: bills)
    }

    
    func reduced(to: Currency, broker: Rater) throws -> Bill{
        var tally = Bill(amount: 0, currency: to)
        for each in _bills {
            tally = try tally.reduced(to: to, broker: broker).plus(try each.reduced(to: to, broker: broker))
        }
        
        return tally
    }
}

extension Wad: Equatable {
    public static func == (lhs: Wad, rhs: Wad) -> Bool {
        
        //convertimos todo a USD y se comprar con los valores finales
        let broker = UnityBroker()
        
        let leftBill = try! lhs.reduced(to: "USD", broker: broker)
        let rightBil = try! rhs.reduced(to: "USD", broker: broker)
        
        return leftBill == rightBil
        
    }
}

extension Wad: CustomStringConvertible {
    
    public var description: String {
        get {
            if billCount == 0 {
                return "Empty"
            } else if billCount == 1 {
                return (_bills.first?.description)!
            }else {
                var total = ""
                for bill in _bills {
                    total = total + " + \(bill)"
                }
                return total
            }
        }
    }
}
