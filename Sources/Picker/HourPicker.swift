//
//  The MIT License (MIT)
//
//  Copyright © 2024 Stephan Heilner
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the  Software), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED  AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import SwiftUI

public struct HourPicker: View {
    private let titleKey: LocalizedStringKey
    private let titleColor: Color

    @Binding private var selection: Int?
    @Binding private var error: String?

    @State private var isShowingPicker: Bool = false
    @State private var hours: Int

    public init(_ titleKey: LocalizedStringKey, selection: Binding<Int?>, error: Binding<String?>? = nil, titleColor: Color = .secondary) {
        self.titleKey = titleKey
        _selection = selection
        _error = error ?? Binding.constant(nil)
        self.titleColor = titleColor

        if let hour = selection.wrappedValue {
            _hours = State(initialValue: hour)
        } else {
            _hours = State(initialValue: -1)
        }
    }

    public var body: some View {
        VStack(alignment: .leading) {
            Text(titleKey)
                .font(.caption)
                .foregroundColor(error != nil ? .red : titleColor)

            Button(action: {
                isShowingPicker.toggle()
            }, label: {
                let title = (hours == -1 ? "--" : String(format: "%02d", hours)) + " "
                Text(title) + Text(Image(systemName: "chevron.up.chevron.down"))
            })
            .buttonStyle(.plain)
            .foregroundColor(error != nil ? .red : .accentColor)

            if let error, !error.isEmpty {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
        .sheet(isPresented: $isShowingPicker) {
            hourPickerView()
        }
        .onChange(of: hours) { newValue in
            if newValue != _selection.wrappedValue {
                selection = newValue
            }
        }
    }

    @ViewBuilder
    func hourPickerView() -> some View {
        ScrollView {
            ZStack(alignment: .topLeading) {
                HStack(alignment: .top) {
                    cancelButton()
                    Spacer()
                }
                HStack(alignment: .top) {
                    Spacer()
                    Text(titleKey)
                        .font(.title2)
                    Spacer()
                }
            }
//            LazyVGrid(columns: [.init(.adaptive(minimum: 45, maximum: 50), alignment: .top)]) {

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))], spacing: 10) {
                ForEach(0 ... 48, id: \.self) { hour in
                    Button(String(format: "%02d", hour)) {
                        hours = hour
                        isShowingPicker = false
                    }
                    .buttonStyle(PickerButtonStyle())
                }
            }
        }
        .padding(20)
        .background(Color(UIColor.systemBackground))
    }

    @ViewBuilder
    func cancelButton() -> some View {
        Button("Cancel") {
            isShowingPicker = false
        }
        .buttonStyle(.plain)
    }
}
