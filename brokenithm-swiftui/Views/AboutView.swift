//
//  AboutView.swift
//  brokenithm-swiftui
//
//  Created by Owen Cramer on 9/15/24.
//

import SwiftUI

struct AboutView: View {
    @Binding var isPresented: Bool

    var body: some View {
        VStack(){
            HStack {
                Button {
                    isPresented.toggle()
                } label: {
                    Image(systemName: "xmark.circle")
                        .font(.title)
                        .padding(20)
                }

                Spacer()
            }
            HStack {
                Image("BrokenithmImage")
                    .resizable()
                    .scaledToFit()
                    .background(Color.white)
                    .frame(height: 144)
                    .clipShape(RoundedRectangle(cornerRadius: 25.263))
                    .overlay(
                        RoundedRectangle(cornerRadius: 25.263)
                            .stroke(.black, lineWidth: 1)
                    )
                VStack {
                    Spacer()
                    VStack (alignment: .leading) {
                        Text("Brokenithm")
                        Text("Made with ❤️ by: Owen Cramer")
                        Text("Original Concept by: esterTion")
                    }
                }
                .padding()
                .frame(height: 150)
            }
            HStack {
                Text("My Links:")
                Link("GitHub", destination: URL(string: "https://github.com/OWCramer")!)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 5)
                    .background(Color.black.mix(with: .blue, by: 0.7))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                Link("Website", destination: URL(string: "https://ocramer.com")!)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 5)
                    .background(Color.black.mix(with: .blue, by: 0.7))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                Link("Ko-fi", destination: URL(string: "https://ko-fi.com/owen1218")!)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 5)
                    .background(Color.black.mix(with: .blue, by: 0.7))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
            }
            Spacer()
        }
    }
}

#Preview {
    AboutView(isPresented: .constant(true))
}
