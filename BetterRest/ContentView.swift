//
//  ContentView.swift
//  BetterRest
//
//  Created by Austin Hill on 12/25/20.
//

import SwiftUI

struct ContentView: View {
    @State private var wakeUp = dafaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    var computedBedtime: String {
        let model = SleepCalculator()
        
        let componets = Calendar.current.dateComponents([.hour, .minute,], from: wakeUp)
        let hour = (componets.hour ?? 0) * 60 * 60
        let minute = (componets.minute ?? 0) * 60
        var bedtime = ""
        do {
            let perdiction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeAmount))
            
            let sleepTime = wakeUp - perdiction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            bedtime = formatter.string(from: sleepTime)
            alertTitle = "Your ideal bedtime is..."
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calulcating your bedtime."
            
        }
        //showingAlert = true
        
        return bedtime
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("When do you want to wake up?").font(.headline)) {
                    
                    
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                }
                
                Section(header: Text("Desired amount of sleep").font(.headline)) {
       
                 
                    
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                }
                
                Section(header: Text("Daily coffee intake").font(.headline)) {
                    
                    Picker("Cups", selection: $coffeAmount){ ForEach(1..<21){ cups in
                            if cups == 1 {
                                Text("1 cup")
                            } else {
                                Text("\(cups) cups")
                            }
                        }
                    }
                }
                Text("your optimal sleepTime is \(computedBedtime)")
            }
            .navigationBarTitle("BetterRest")
            
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    static var dafaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    func calculateBedtime() -> String {
        let model = SleepCalculator()
        
        let componets = Calendar.current.dateComponents([.hour, .minute,], from: wakeUp)
        let hour = (componets.hour ?? 0) * 60 * 60
        let minute = (componets.minute ?? 0) * 60
        
        do {
            let perdiction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeAmount))
            
            let sleepTime = wakeUp - perdiction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            alertMessage = formatter.string(from: sleepTime)
            alertTitle = "Your ideal bedtime is..."
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calulcating your bedtime."
            
        }
        //showingAlert = true
        
        return alertMessage
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
