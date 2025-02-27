//
//  AssignmentText.swift
//  Assignment
//
//  Created by Kunal on 10/01/25.
//

import Foundation
import SwiftUI

struct AssignmentText: View {
    let text: String
    let color: String?
    let capacity: String?
 
    var body: some View {
        VStack(alignment: .leading) {
            Text(text)
                .font(.headline)
            if let color = color {
                Text("Color: \(color)")
            }
            if let capacity = capacity {
                Text("Capacity: \(capacity)")
            }
        }
        .foregroundColor(.black)
    }
}
