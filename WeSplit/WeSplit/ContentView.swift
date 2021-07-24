//
//  ContentView.swift
//  WeSplit
//
//  Created by Антон Кашников on 08.04.2021.
//
import SwiftUI
extension String {
    static let numberFormatter = NumberFormatter()
    var doubleValue: Double {
        String.numberFormatter.decimalSeparator = "."
        if let result =  String.numberFormatter.number(from: self) {
            return result.doubleValue
        } else {
            String.numberFormatter.decimalSeparator = ","
            if let result = String.numberFormatter.number(from: self) {
                return result.doubleValue
            }
        }
        return 0
    }
}
struct ContentView: View {
    @State private var checkAmount = ""
    @State private var stringNumberOfPeople = ""
    @State private var tipPercentage = 2
    let tipPercentages = [0, 10, 15, 20, 25]
    func amountAndTip(_ amount: String, _ tip: Int) -> (Double, Double) {
        let dotCheckAmount = String(format:"%.2f", checkAmount.doubleValue)
        return (Double(dotCheckAmount) ?? 0, Double(tipPercentages[tipPercentage]))
    }
    var totalPerPerson: Double {
        let peopleCount = Double(Double(stringNumberOfPeople) ?? 2)
        let (orderAmount, tipSelection) = amountAndTip(checkAmount, tipPercentages[tipPercentage])
        let tipValue = orderAmount / 100 * tipSelection
        let grandTotal = orderAmount + tipValue
        let amountPerPerson = grandTotal / peopleCount
        return amountPerPerson
    }
    var totalAmount: Double {
        let (orderAmount, tipSelection) = amountAndTip(checkAmount, tipPercentages[tipPercentage])
        return orderAmount + orderAmount * tipSelection / 100
    }
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Enter check amount and number of people")) {
                    TextField("Amount", text: $checkAmount).keyboardType(.decimalPad)
                    TextField("Number of people", text: $stringNumberOfPeople).keyboardType(.numberPad)
                }
                Section(header: Text("How much tip do you want to leave?")) {
                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach(0..<tipPercentages.count) {
                            Text("\(tipPercentages[$0])%")
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
                Section(header: Text("Amount per person")) {
                    Text("$\((stringNumberOfPeople == "" || totalPerPerson.isNaN) ? 0 : totalPerPerson, specifier: "%.2f")")
                }
                Section(header: Text("Total amount for the check")) {
                    Text("$\(totalAmount, specifier: "%.2f")")
                }
            }.navigationBarTitle("WeSplit")
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
