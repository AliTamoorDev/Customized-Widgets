//
//  ContentView.swift
//  Test
//
//  Created by Raj Lunia on 11/30/23.
//

enum Field: Hashable {
    case firstName, lastName, email, phone, iccid, subject, message, otp
}

import SwiftUI
import Combine

struct ContentView: View {
    
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: Field?
    
    @State var firstName = "John"
    @State var lastName = ""
    @State var email = "yolo2115678@gmail.com"
    @State var phone = ""
    @State var iccid = ""
    @State var subject = ""
    @State var message = ""
    
    var allFieldsFilled: Bool {
        // Add logic to check if all required fields are filled
        // For example:
        !firstName.isEmpty && !phone.isEmpty && !subject.isEmpty && !message.isEmpty
    }
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            VStack {
                ZStack {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "chevron.left")
                            .font(.body.bold())
                            .foregroundColor(.secondary)
                            .padding(8)
                            .background(.ultraThinMaterial, in: Circle())
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                    })
                    Text("Contact Us")
                        .font(.title3.bold())
                        .frame(alignment: .top)
                        .frame(maxWidth: .infinity, alignment: .center)
                }.padding(.bottom, 5)
                    .background(.ultraThinMaterial.opacity(0.5))
                
                ScrollView (showsIndicators: false) {
                    VStack {
                        Text("We're here for you, and our team would be happy to help with any questions or issues you might have.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                            .padding(.top)
                        
                        FloatingTextField(title: "First Name", text: $firstName, focusedField: $focusedField, field: .firstName)
                            .id(Field.firstName)
                            .submitLabel(.next)
                            .onSubmit { focusedField = .lastName }
                        
                        FloatingTextField(title: "Last Name (Optional)", text: $lastName, focusedField: $focusedField, field: .lastName)
                            .id(Field.lastName)
                            .submitLabel(.next)
                            .onSubmit { focusedField = .email }
                        
                        FloatingTextField(title: "Email", text: $email, focusedField: $focusedField, field: .email)
                            .id(Field.email)
                            .keyboardType(.emailAddress)
                            .submitLabel(.next)
                            .onSubmit { focusedField = .phone }
                        
                        FloatingTextField(title: "Phone Number", text: $phone, focusedField: $focusedField, field: .phone)
                            .id(Field.phone)
                            .keyboardType(.phonePad)
                            .submitLabel(.next)
                            .onSubmit { focusedField = .iccid }
                        
                        FloatingTextField(title: "eSIM ICCID (Optional)", text: $iccid, focusedField: $focusedField, field: .iccid)
                            .id(Field.iccid)
                            .keyboardType(.numberPad)
                            .submitLabel(.next)
                            .onSubmit { focusedField = .subject }
                        
                        FloatingTextField(title: "Subject", text: $subject, focusedField: $focusedField, field: .subject)
                            .id(Field.subject)
                            .submitLabel(.next)
                            .onSubmit { focusedField = .message }
                        
                        FloatingTextField(title: "Message", text: $message, focusedField: $focusedField, field: .message, axis: .vertical)
                            .id(Field.message)
                            .lineLimit(4...4)
                    }.padding(.horizontal)
                }
                
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        
                        Button("Done") {
                            focusedField = nil
                        }
                    }
                }
                
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    ContentView()
        .colorScheme(.dark)
}


struct FloatingTextField: View {
    let title: String
    let text: Binding<String>
    let axis: Axis
    var focusedField: FocusState<Field?>.Binding
    let field: Field
    @State var isTapped = true
    
    init(title: String, text: Binding<String>, focusedField: FocusState<Field?>.Binding, field: Field, axis: Axis = .horizontal) {
        self.title = title
        self.text = text
        self.axis = axis
        self.focusedField = focusedField
        self.field = field
    }
    
    var body: some View {
        
        ZStack(alignment: .topLeading) {
            Text(title)
                .font(.caption)
                .foregroundColor(Color(.placeholderText))
                .opacity((isTapped) ? 0 : 1)
                .offset(y: isTapped ? 0 : -10)
            
            TextField(isTapped ? title : "", text: text, onEditingChanged: getFocus)
                .focused(focusedField, equals: field)
                .offset(y: isTapped ? 0 : 5)
        }
        
//        ZStack(alignment: .topLeading) {
//            Text(title)
//                .font(.caption)
//                .foregroundColor(Color(.placeholderText))
//                .opacity(text.wrappedValue.isEmpty ? 0 : 1)
//                .offset(y: text.wrappedValue.isEmpty ? 0 : -10)
//            TextField(title, text: text, axis: axis)
//                .focused(focusedField, equals: field)
//                .offset(y: text.wrappedValue.isEmpty ? 0 : 5)
//        }
        
        .onTapGesture {
            focusedField.wrappedValue = field
        }
        .animation(.default, value: isTapped)
        .padding(.vertical, 5)
        .padding(10)
        .background(.ultraThinMaterial.opacity(0.8))
        .cornerRadius(8)
    }
    
    func getFocus(focused:Bool) {
        isTapped = (!focused && text.wrappedValue.isEmpty)
    }
}
