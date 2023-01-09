//
//  ContentView.swift
//  BetterRest
//
//  Created by Ngô Nam on 08/01/2023.
//

import CoreML
import SwiftUI

struct ContentView: View {
    
    static var defaultWakeUpTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    @State private var wakeUp = defaultWakeUpTime
    @State private var sleepAmount = 8.0
    @State private var coffeAmount = 1
    
    var formatter: DateFormatter {
        let df = DateFormatter()
        df.timeStyle = .short
        return df
    }
    
    var timeCalculte: String {
        var sleepTime = Date.now
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeAmount))
            
            sleepTime = wakeUp - prediction.actualSleep
            
            return formatter.string(from: sleepTime)
            
        } catch {
            return "Error"
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                VStack {
                    Group {
                        Spacer()
                    }
                    Text("When do you want to wake up")
                        .font(.headline)
                    
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(.wheel)
                    
                    Text("Desired amount of sleep")
                        .font(.headline)
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                    
                    Text("Daily coffee intake")
                    Stepper(coffeAmount == 1 ? "1 cup" : "\(coffeAmount) cups", value: $coffeAmount, in: 1...20)
                    
                    Spacer()
                    
                    Text("Your ideal bedtime is: \(timeCalculte)")
                        .font(.headline)
                    
                    Spacer()
                }
                .padding()
                .navigationTitle("Better Rest")
//                .toolbar {
//                    Button("Calculate", action: calculateBedtime)
//                        .font(.headline)
//                        .frame(width: 100, height: 40, alignment: .center)
//                        .foregroundColor(Color.white)
//                        .background(.cyan)
//                        .clipShape(RoundedRectangle(cornerRadius: 10))
//                }
//                .alert(alertTitle, isPresented: $showingAlert) {
//                    Button("Ok") {}
//                } message: {
//                    Text(alertMessage)
//                }
            }
        }
    }
    
//    func calculateBedtime() {
//        do {
//            let config = MLModelConfiguration()
//            let model = try SleepCalculator(configuration: config)
//            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
//            let hour = (components.hour ?? 0) * 60 * 60
//            let minute = (components.minute ?? 0) * 60
//
//            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeAmount))
//
//            let sleepTime = wakeUp - prediction.actualSleep
//            timeCalculate = sleepTime
//
//            alertTitle = "Your ideal bedtime is: "
//            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
//
//        } catch {
//            alertTitle = "Error"
//            alertMessage = "Sorry, there was a problem calculating your bedtime"
//        }
//
//        showingAlert = true
//    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
