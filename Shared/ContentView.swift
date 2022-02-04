//
//  ContentView.swift
//  Shared
//
//  Created by Matthew Malaker on 2/3/22.
//

import SwiftUI
//This is going to be similar to the previous problem, where we have several large arrays of numbers being created by a user-determined set of parameters
struct ContentView: View {
    @State var xValueString = ""
    @ObservedObject var  sinusoid = sineFunction()
    @State var sineValue: Double = 0.0
    @State var termSeries = [Double]()
    @State var sumSeries = [Double]()
    @State var cancellationSeries = [Double]()
    @State var xValue = 0.0
    @State var editorText = ""
    
    
    var body: some View {
        HStack{
        VStack{
            
            HStack{
                Text("Enter x")
                    .padding(.horizontal)
                    .frame(width: 150)
                    .padding(.top, 30)
                    .padding(.bottom)
                TextField("",text: $xValueString, onCommit: {xValue = Double(xValueString) ?? 0})
                    .padding(.horizontal)
                    .frame(width: 150)
                    .padding(.top, 30)
                    .padding(.bottom)
            }
            
            Button("Calculate", action: {sineValue = sinusoid.calculateSine(xInit: xValue); (termSeries, sumSeries) = sinusoid.calculateSineTerms(xInit: xValue); cancellationSeries = sinusoid.calculateSubtractiveCancellation(terms: termSeries, sumTerms: sumSeries); editorText = calculateEditorText(x: xValue, value: sineValue, terms: termSeries, cancellationTerms: cancellationSeries);print(termSeries);print(sumSeries)})
                .padding(.bottom)
                .padding()
            //This is an insurance policy
//            Button("Force Display",action: {editorText = calculateEditorText(x: xValue, value: sineValue, terms: termSeries, cancellationTerms: cancellationSeries)})
            
        }
            TextEditor(text: $editorText)
                .padding(.horizontal)
                .frame(width: 1000)
                .padding(.top, 30)
                .padding(.bottom)
        
        }
    }
    
    func calculateEditorText(x: Double, value: Double, terms: [Double], cancellationTerms: [Double]) -> String {
        
        var createdText = ""
        createdText += "sin(\(x))=\(value) according to our method. The  real value is: \(sin(x)) \n"
        for i in stride(from: 0, to: terms.count, by: 1){
            createdText += "Term \(i) = \(terms[i]): cancellation error at term \(i) = \(cancellationTerms[i]) \n"
        }
        
        return createdText
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
