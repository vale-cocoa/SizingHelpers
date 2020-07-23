//
//  InternalAPI.swift
//  SizingHelpers
//
//  Created by Valeriano Della Longa on 23/07/2020.
//  Copyright © 2020 Valeriano Della Longa. All rights reserved.
//

import SwiftUI

// MARK: - EqualSideSize & EqualSideSizes
struct EqualSideSize: ViewModifier {
    @Environment(\.sideSize) private var sideSize
    
    func body(content: Content) -> some View {
        content
            .geometryPreference(
                ViewSideSizePreference.self,
                value: { [max($0.size.width, $0.size.height)] }
        )
            .frame(width: self.sideSize, height: self.sideSize)
    }
    
}

struct EqualSideSizes: ViewModifier {
    func body(content: Content) -> some View {
        Preferenced(
            ViewSideSizePreference.self,
            content: { sideSizes in
                content
                    .environment(
                        \.sideSize,
                        sideSizes.max()
                )
        })
    }
    
}

extension EnvironmentValues {
    public var sideSize: CGFloat? {
        get { self[SideSizeKey.self] }
        set { self[SideSizeKey.self] = newValue }
    }
    
}

struct SideSizeKey: EnvironmentKey {
    typealias Value = CGFloat?
    
    static var defaultValue: Value { nil }
    
}

// MARK: - EqualSize & EqualSizes
struct EqualViewSize: ViewModifier {
    @Environment(\.viewSize) private var viewSize
    
    func body(content: Content) -> some View {
        content
            .geometryPreference(
                ViewSizePreference.self,
                value: { [$0.size] }
        )
            .frame(
                width: self.viewSize?.width,
                height: self.viewSize?.height
        )
    }
    
}

struct EqualViewSizes: ViewModifier {
    func body(content: Content) -> some View {
        Preferenced(
            ViewSizePreference.self,
            content: { sizes in
                content
                    .environment(\.viewSize, sizes.maxSize)
        })
    }
    
}

extension EnvironmentValues {
    public var viewSize: CGSize? {
        get { self[ViewSizeKey.self] }
        set { self[ViewSizeKey.self] = newValue }
    }
    
}

struct ViewSizeKey: EnvironmentKey {
    typealias Value = CGSize?
    
    static var defaultValue: Value { nil }
}

// MARK: - Helpers
extension Collection where Self.Iterator.Element == CGSize {
    var maxSize: CGSize? {
        guard
            let maxWidth = map({ $0.width }).max(),
            let maxHeight = map({ $0.height }).max()
            else { return nil }
        
        return CGSize(width: maxWidth, height: maxHeight)
    }
    
}
