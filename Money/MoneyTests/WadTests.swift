//
//  WadTests.swift
//  Money
//
//  Created by Eugenio Barquín on 27/4/17.
//  Copyright © 2017 Eugenio Barquín. All rights reserved.
//

import XCTest
@testable import Money

class WadTests: XCTestCase {
    let emptyWad: Wad = Wad()
    let singleBillWad = Wad(amount: 42, currency: "USD")
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testCanCreateWad(){
        XCTAssertNotNil(Wad())
    }
    
    func testStringConversion() {
        XCTAssertEqual("\(emptyWad)", "Empty")
        XCTAssertEqual("\(singleBillWad)", "USD 42")
    }

    func testEquality(){
        
        // identity
        XCTAssertEqual(emptyWad, emptyWad)
        XCTAssertEqual(singleBillWad, singleBillWad)
        
        XCTAssertNotEqual(emptyWad, singleBillWad)
        
        // equivalence
        let tenEuros = Wad(amount: 10, currency: "EUR")
        let tenDollars = Wad(amount: 10, currency: "USD")
        
        let fifty1 = Wad(amount: 50, currency: "USD")
        let fifty2 = Wad(amount: 10, currency: "EUR").plus(tenEuros).plus(tenDollars).plus(tenDollars).plus(tenEuros)
        let fifty3 = Wad(amount: 30, currency: "EUR").plus(tenEuros).plus(tenDollars)
        
        XCTAssertEqual(fifty1, fifty2)
        XCTAssertEqual(fifty1, fifty3)
        XCTAssertEqual(fifty2, fifty3)
        
    }
    
    func testSimpleAddition(){
        
        XCTAssertEqual(singleBillWad.plus( Wad(amount: 8, currency: "USD")), Wad(amount: 50, currency: "USD"))
        
    }
    
    func testSimpleMultiplication(){
        let eightyFour = singleBillWad.times(2)
        XCTAssertEqual(eightyFour, Wad(amount: 84, currency: "USD"))
    }
    
    func testSimpleCrossAddition(){
        
        var broker = Broker()
        broker.addRate(from: "EUR", to: "USD", rate: 2)
        
        let sum = Wad()
            .plus(Bill(amount: 10, currency: "USD"))
            .plus(Bill(amount: 5, currency: "EUR"))
        
        
        XCTAssertEqual(sum.billCount, 2)
        XCTAssertEqual(sum._bills,
                       [Bill(amount: 10, currency: "USD"),
                        Bill(amount: 5, currency: "EUR")] )
        
        XCTAssertNotEqual(sum._bills,
                          [Bill(amount: 4, currency: "USD"),
                           Bill(amount: 15, currency: "EUR")] )
        
        XCTAssertNotEqual(sum.billCount, 1)
    }


    

}
