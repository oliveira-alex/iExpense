//
//  AddView.swift
//  iExpense
//
//  Created by Alex Oliveira on 08/05/2021.
//

import SwiftUI

struct AddView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var expenses: Expenses
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = ""
    static let types = ["Business", "Personal"]
    
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                
                Picker("Type", selection: $type) {
                    ForEach(Self.types, id: \.self) {
                        Text($0)
                    }
                }
                
                TextField("Amount", text: $amount)
                    .keyboardType(.numberPad)
            }
            .navigationBarTitle("Add new expense")
            .navigationBarItems(
                leading: Button("Cancel") { self.presentationMode.wrappedValue.dismiss() },
                trailing: Button("Save") {
                    if let actualAmount = Int(self.amount) {
                        let item = ExpenseItem(name: self.name, type: self.type, amount: actualAmount)
                        
                        self.expenses.items.append(item)
                        self.presentationMode.wrappedValue.dismiss()
                    } else if self.amount == "" {
                        self.alertTitle = "Missing value"
                        self.alertMessage = "Please inform the amount of the expense"
                        self.showingAlert.toggle()
                    } else {
                        self.alertTitle = "Only integers"
                        self.alertMessage = "'\(self.amount)' is not an integer"
                        self.showingAlert.toggle()
                    }
                }
            )
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
