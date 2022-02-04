//
//  Sine Function.swift
//  Homework 2 Problem 3: Sine function
//
//  Created by Matthew Malaker on 2/3/22.
//

import Foundation

class sineFunction: NSObject, ObservableObject{
    
    func factorial(n: Int)->Double{
        var result: UInt64 = 1
        if n>0{
            
            for i in stride(from: 2, through: n, by: 1){
                result *= UInt64(i)
//                print(result)
            }
            return Double(result)
        }
        else{
            if n==0{
                result = 1
            }
        }
        return Double(result)
    }
    
    func calculateSine(xInit: Double)-> Double{
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
            error = pow(-1,Double(n-1))*pow(x,Double(2*n-1))/factorial(n: 2*n-1)
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
        
        return endValue
        
    }
    //The assignment calls for the comparison of terms. We could add them as a return of the sine function, such as in a tuple, but then we have to deal with the fact the return is a tuple every time we impliment the function, which can get cumbersome. I figured it was better to have a separate function for these terms, that way we can get them when desired but are not burdened with them when we don't
    func calculateSineTerms(xInit: Double)-> (eachTerm: [Double], termSum: [Double]){
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
        // If x is in region 2, we need to subtract pi/2
        //If x is in region 3, we need to subtract pi and negate the output
        //If x is in region 4, we need to subtract 3pi/2 and negate teh output
        

        x = xInit - (2*Double.pi*((xInit/(2*Double.pi)).rounded(.towardZero)))
        if x > 3*Double.pi/2{
            negateOutput = true
            x = abs(Double.pi - x)
        }
        else{
            if x > Double.pi{
                negateOutput = true
                x = x - Double.pi
            }
            else{
                if x > Double.pi/2{
                    x = abs((Double.pi/2)-x)
                }
            }
        }
        var endValue = 0.0
        var error = 0.0

        var seriesTerms: [Double] = [0.0]
        var sumOfTerms: [Double] = [0.0]
        for n in stride(from: 1, through: 1000, by: 1){
            print(n)
            
            error = pow(-1,Double(n-1))*pow(x,Double(2*n-1))/factorial(n: 2*n-1)
            endValue += error
                       
            
            
            if negateOutput == true{
                sumOfTerms.append(-1*endValue)
                seriesTerms.append(-1*error)
            }
            else{
                sumOfTerms.append(endValue)
                seriesTerms.append(error)
                
            }

            if(abs(error) < 0.00000001){

                break
            }
        }
        print("Term Series = \(seriesTerms)")
        print("Sum Series = \(sumOfTerms)")
        return (seriesTerms,sumOfTerms)
    }


    func calculateSubtractiveCancellation(terms: [Double], sumTerms: [Double]) -> [Double]{
        var cancellationArray = [0.0]
        var previousValue = 0.0//The terms are in indeces starting at 1, so we need to start the array off with a dummy value
        //We need to calculate the subtraction error at each term, which is the difference between the PREVIOUS VALUE OF THE SUM and the n'th value
        
        for i in stride(from: 1, to: terms.count, by: 1){
            previousValue = terms[i-1]-sumTerms[i-1]
            cancellationArray.append((terms[i]-sumTerms[i])-previousValue)
            
        }
        return cancellationArray
    }
    
    func compareValues(x: Double)->String{
        var comparison = ""
        let builtIn = sin(x)
        let calculated = calculateSine(xInit: x)
        
        comparison += "x= \(x), Built-in = \(builtIn), Project = \(calculated)"
        
        return comparison
    }
    
}
