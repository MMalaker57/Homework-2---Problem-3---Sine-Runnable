//
//  Tests_macOS.swift
//  Tests macOS
//
//  Created by Matthew Malaker on 2/3/22.
//

import XCTest
import SwiftUI

class Tests_macOS: XCTestCase {
    
    
    @ObservedObject var sinusoid = sineFunction()
    func testSineCalculation(){
        var xInit = 1.0
        var x = 0.0
        var negateOutput = false
        //We need to make it so x is between 0 and pi to conserve precision
        //We first need to get x within a range of 0 to 2pi. This can be done with the mod function, but % is not available
        //There are two important regions of 0<x<2pi
        //1) 0<x<pi/2
        //2) pi/2<x<pi
        //3) pi<x<3pi/2
        //4) 3pi/2<x<2pi
        //sin(pi/2<x<pi) = sin(0<x<pi/2)
        //sin(pi<x<3pi/2) = sin(3pi/2<x<2pi)
        //
        //So after we reduce x to its value between 0 and 2pi, we need to determine if it is in region 1, 2, 3, or 4
        // If x is in region 2, we need to mirror across x = pi/2
        //If x is in region 3, subtract pi, and then we negate the output
        //If x is in region 4, we need to mirror across pi and negate the output
        
        x = xInit - (2*Double.pi*((xInit/(2*Double.pi)).rounded(.towardZero)))
        //Going in decending order simplifies the if conditions
        
        if x > 3*Double.pi/2{
            negateOutput = true
            x = abs(Double.pi - x)
            print("x= \(x)")
        }
        else{
            if x > Double.pi{
                negateOutput = true
                x = x - Double.pi
                print("x= \(x)")
            }
            else{
                if x > Double.pi/2{
                    x = abs((Double.pi/2)-x)
                    print("x= \(x)")
                }
                else{
                    print("x= \(x)")
                }
            }
        }
        

       
        

        var endValue = 0.0
        var error = 999999999.0
//        var seriesTerms: [Double] = [0.0,0.0,0.0]
        for n in stride(from: 1, through: 1000, by: 1){
            error = pow(-1,Double(n-1))*pow(x,Double(2*n-1))/sinusoid.factorial(n: 2*n-1)
            endValue += error
            print(n)

            if(abs(error) < 0.00000001){
                print("BREAKING AT N= \(n) BECAUSE ERROR = \(error)")
                break
            }
        }
        if negateOutput == true{
            endValue = -1*endValue
        }
        
        XCTAssertEqual(endValue, sinusoid.calculateSine(xInit: xInit), accuracy: 1.0E-7, "Sine function accuracy failure.")
        
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
