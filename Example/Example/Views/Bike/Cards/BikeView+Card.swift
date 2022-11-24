import Combine
import SwiftUI

// MARK: - BikeView+Card

extension BikeView {
    
    /// A BikeView Card
    struct Card<Value: Equatable, Background: View, Label: View, Content: View, Actions: View> {
        
        /// The optional fixed height. Default value `100`
        var fixedHeight: CGFloat? = 100
        
        /// The placeholder value.
        let placeholderValue: Value
        
        /// The Animation. Default value `.default`
        var animation: Animation = .default
        
        /// An optional asynchronous throwable closure which provides a Value.
        var provider: (() async throws -> Value)?
        
        /// A Publisher that emits a Value whenever a change occurred. Default value `Empty()`
        var publisher: AnyPublisher<Value, Never> = Empty().eraseToAnyPublisher()
        
        /// An optional closure providing the Background  for a given Value.
        @ViewBuilder
        var background: (Value) -> Background
        
        /// A ViewBuilder closure providing the Content for a given Value.
        @ViewBuilder
        var content: (Value) -> Content
        
        /// A ViewBuilder closure providing the Label for a given Value.
        @ViewBuilder
        var label: (Value) -> Label
        
        /// A ViewBuilder closure providing the Actions for a given Value.
        @ViewBuilder
        var actions: (Value) -> Actions
        
        /// The Value Result.
        @State
        private var value: Result<Value, Error>?

        /// The color scheme.
        @Environment(\.colorScheme)
        private var colorScheme
        
        /// The redaction reasons.
        @Environment(\.redactionReasons)
        private var redactionReasons
        
    }
    
}

// MARK: - Background Convenience Initializer

extension BikeView.Card where Background == EmptyView {
    
    /// Creates a new instance of `BikeView.Card`
    /// - Parameters:
    ///   - fixedHeight: The optional fixed height. Default value `100`
    ///   - placeholderValue: The placeholder value.
    ///   - animation: The Animation. Default value `.default`
    ///   - provider: An optional asynchronous throwable closure which provides a Value. Default value `nil`
    ///   - publisher: A Publisher that emits a Value whenever a change occurred. Default value `Empty()`
    ///   - content: A ViewBuilder closure providing the Content for a given Value.
    ///   - label: A ViewBuilder closure providing the Label for a given Value.
    ///   - actions: A ViewBuilder closure providing the Actions for a given Value.
    init(
        fixedHeight: CGFloat? = 100,
        placeholderValue: Value,
        animation: Animation = .default,
        provider: (() async throws -> Value)? = nil,
        publisher: AnyPublisher<Value, Never> = Empty().eraseToAnyPublisher(),
        @ViewBuilder
        content: @escaping (Value) -> Content,
        @ViewBuilder
        label: @escaping (Value) -> Label,
        @ViewBuilder
        actions: @escaping (Value) -> Actions
    ) {
        self.init(
            fixedHeight: fixedHeight,
            placeholderValue: placeholderValue,
            animation: animation,
            provider: provider,
            publisher: publisher,
            background: { _ in
                EmptyView()
            },
            content: content,
            label: label,
            actions: actions
        )
    }
    
}

// MARK: - Label Convenience Initializer

extension BikeView.Card where Label == SwiftUI.Label<Text, Image>, Background == EmptyView {
    
    /// Creates a new instance of `BikeView.Card`
    /// - Parameters:
    ///   - fixedHeight: The optional fixed height. Default value `100`
    ///   - placeholderValue: The placeholder value.
    ///   - animation: The Animation. Default value `.default`
    ///   - provider: An optional asynchronous throwable closure which provides a Value. Default value `nil`
    ///   - publisher: A Publisher that emits a Value whenever a change occurred. Default value `Empty()`
    ///   - title: The label title.
    ///   - systemImage: The label system image name.
    ///   - content: A ViewBuilder closure providing the Content for a given Value.
    ///   - actions: A ViewBuilder closure providing the Actions for a given Value.
    init(
        fixedHeight: CGFloat? = 100,
        placeholderValue: Value,
        animation: Animation = .default,
        title: String,
        systemImage: String,
        provider: (() async throws -> Value)? = nil,
        publisher: AnyPublisher<Value, Never> = Empty().eraseToAnyPublisher(),
        @ViewBuilder
        content: @escaping (Value) -> Content,
        @ViewBuilder
        actions: @escaping (Value) -> Actions
    ) {
        self.init(
            fixedHeight: fixedHeight,
            placeholderValue: placeholderValue,
            animation: animation,
            provider: provider,
            publisher: publisher,
            background: { _ in
                EmptyView()
            },
            content: content,
            label: { _ in
                SwiftUI.Label(title, systemImage: systemImage)
            },
            actions: actions
        )
    }
    
}

extension BikeView.Card where Label == EmptyView {
    
    /// Creates a new instance of `BikeView.Card`
    /// - Parameters:
    ///   - fixedHeight: The optional fixed height. Default value `100`
    ///   - placeholderValue: The placeholder value.
    ///   - animation: The Animation. Default value `.default`
    ///   - backgroundColor: An optional closure providing the background color for a given Value.. Default value `nil`
    ///   - provider: An optional asynchronous throwable closure which provides a Value. Default value `nil`
    ///   - publisher: A Publisher that emits a Value whenever a change occurred. Default value `Empty()`
    ///   - content: A ViewBuilder closure providing the Content for a given Value.
    ///   - actions: A ViewBuilder closure providing the Actions for a given Value.
    init(
        fixedHeight: CGFloat? = 100,
        placeholderValue: Value,
        animation: Animation = .default,
        provider: (() async throws -> Value)? = nil,
        publisher: AnyPublisher<Value, Never> = Empty().eraseToAnyPublisher(),
        @ViewBuilder
        background: @escaping (Value) -> Background,
        @ViewBuilder
        content: @escaping (Value) -> Content,
        @ViewBuilder
        actions: @escaping (Value) -> Actions
    ) {
        self.init(
            fixedHeight: fixedHeight,
            placeholderValue: placeholderValue,
            animation: animation,
            provider: provider,
            publisher: publisher,
            background: background,
            content: content,
            label: { _ in
                EmptyView()
            },
            actions: actions
        )
    }
    
}

// MARK: - Load Value

private extension BikeView.Card {
    
    /// Load Value
    func loadValue() async {
        // Verify a provider is available
        guard let provider = self.provider else {
            // Otherwise return out of function
            return
        }
        // Load value
        let value: Result<Value, Error> = await {
            do {
                return .success(try await provider())
            } catch {
                return .failure(error)
            }
        }()
        // Set value
        withAnimation(self.animation) {
            self.value = value
        }
    }
    
}

// MARK: - View

extension BikeView.Card: View {
    
    /// The content and behavior of the view.
    var body: some View {
        Menu {
            switch self.value {
            case .success(let value):
                self.actions(value)
            case .failure:
                if self.provider != nil {
                    Button {
                        Task {
                            await self.loadValue()
                        }
                    } label: {
                        SwiftUI.Label(
                            "Reload",
                            systemImage: "arrow.clockwise.circle.fill"
                        )
                    }
                }
            case nil:
                if self.provider == nil {
                    self.actions(self.placeholderValue)
                } else {
                    EmptyView()
                }
            }
        } label: {
            let content = VStack {
                switch self.value {
                case nil, .success:
                    let value = try? self.value?.get()
                    self.content(
                        value ?? self.placeholderValue
                    )
                    .redacted(reason: value == nil && self.provider != nil ? .placeholder : .init())
                case .failure:
                    Image(
                        systemName: "xmark.circle.fill"
                    )
                    .renderingMode(.original)
                    .font(.largeTitle)
                    .foregroundColor(.red)
                }
            }
            .frame(height: self.fixedHeight)
            if Label.self is EmptyView.Type {
                let error: Error? = {
                    switch self.value {
                    case .failure(let error):
                        return error
                    default:
                        return nil
                    }
                }()
                VStack {
                    HStack {
                        Spacer()
                        VStack {
                            Spacer()
                            content
                            Spacer()
                        }
                        Spacer()
                    }
                }
                .background(
                    error != nil ? Color.foregroundColor : nil
                )
                .background(
                    error == nil ? self.background((try? self.value?.get()) ?? self.placeholderValue) : nil
                )
                .cornerRadius(12)
            } else {
                GroupBox {
                    content.padding(.top, 1)
                } label: {
                    self.label(
                        (try? self.value?.get()) ?? self.placeholderValue
                    )
                    .opacity(self.colorScheme == .dark ? 0.8 : 1)
                }
            }
        }
        .task {
            guard self.redactionReasons.isEmpty, self.value == nil else {
                return
            }
            await self.loadValue()
        }
        .onChange(
            of: self.redactionReasons
        ) { redactionReasons in
            guard redactionReasons.isEmpty, self.value == nil else {
                return
            }
            Task {
                await self.loadValue()
            }
        }
        .onReceive(
            self.publisher
        ) { value in
            self.value = .success(value)
        }
        .animation(
            self.animation,
            value: try? self.value?.get()
        )
        .clipped()
    }
    
}
