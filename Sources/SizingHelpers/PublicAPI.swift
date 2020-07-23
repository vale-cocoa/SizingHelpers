//
//  PublicAPI.swift
//  SizingHelpers
//
//  Created by Valeriano Della Longa on 23/07/2020.
//  Copyright © 2020 Valeriano Della Longa. All rights reserved.
//

import SwiftUI

// MARK: - Methods
extension View {
    public func geometryPreference<P: PreferenceKey>(_ key: P.Type, value: @escaping (GeometryProxy) -> P.Value) -> some View
    {
        overlay(GeometryReader { proxy in
                Color.clear
                    .preference(key: key, value: value(proxy))
        })
    }
    
    public func equalSideSize() -> some View {
        self
            .modifier(EqualSideSize())
    }
    
    public func equalSideSizes() -> some View {
        self
            .modifier(EqualSideSizes())
    }
    
    public func equalSize() -> some View {
        self
            .modifier(EqualViewSize())
    }
    
    public func equalSizes() -> some View {
        self
            .modifier(EqualViewSizes())
    }
    
}

// MARK: - Views
public struct Preferenced<P: PreferenceKey, Content: View>: View where P.Value: Equatable {
    let content: (P.Value) -> Content
    @State private var value: P.Value = P.defaultValue
    
    init(_ key: P.Type, @ViewBuilder content: @escaping (P.Value) -> Content) {
        self.content = content
    }
    
    var body: some View {
        content(value)
            .onPreferenceChange(P.self) { self.value = $0 }
    }
    
}

// MARK: - PreferenceKeys
public struct IdentifiedViewSizePreference<ID: Hashable>: PreferenceKey {
    typealias Value = [ID : CGSize]
    
    static var defaultValue: Value { Value() }
    
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
    
}

public struct ViewSizePreference: PreferenceKey {
    typealias Value = [CGSize]
    
    static let defaultValue: Value = Value()
    
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.append(contentsOf: nextValue())
    }
    
}

public struct IdentifiedViewSideSizePreference<ID: Hashable>: PreferenceKey {
    typealias Value = [ID : CGFloat]
    
    static var defaultValue: Value { Value() }
    
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

public struct ViewSideSizePreference: PreferenceKey {
    typealias Value = [CGFloat]
    
    static let defaultValue: Value = Value()
    
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.append(contentsOf: nextValue())
    }
    
}
