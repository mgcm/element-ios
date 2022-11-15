//
// Copyright 2022 New Vector Ltd
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import SwiftUI

struct ComposerCreateActionList: View {
    // MARK: - Properties
    
    // MARK: Private
    
    @Environment(\.theme) private var theme: ThemeSwiftUI

    private var textFormattingIcon: String {
        viewModel.textFormattingEnabled
        ? Asset.Images.actionFormattingEnabled.name
        : Asset.Images.actionFormattingDisabled.name
    }
    
    // MARK: Public
    
    @ObservedObject var viewModel: ComposerCreateActionListViewModel.Context

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(viewModel.viewState.actions) { action in
                    HStack(spacing: 16) {
                        Image(action.icon)
                            .renderingMode(.template)
                            .foregroundColor(theme.colors.accent)
                        Text(action.title)
                            .foregroundColor(theme.colors.primaryContent)
                            .font(theme.fonts.body)
                            .accessibilityIdentifier(action.accessibilityIdentifier)
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.send(viewAction: .selectAction(action))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
                if viewModel.viewState.wysiwygEnabled {
                    SeparatorLine()
                    HStack(spacing: 16) {
                        Image(textFormattingIcon)
                            .renderingMode(.template)
                            .foregroundColor(theme.colors.accent)
                        Text(VectorL10n.wysiwygComposerStartActionTextFormatting)
                            .foregroundColor(theme.colors.primaryContent)
                            .font(theme.fonts.body)
                            .accessibilityIdentifier("textFormatting")
                        Spacer()
                        Toggle("", isOn: $viewModel.textFormattingEnabled)
                            .toggleStyle(ComposerToggleActionStyle())
                            .labelsHidden()
                            .onChange(of: viewModel.textFormattingEnabled) { isOn in
                                viewModel.send(viewAction: .toggleTextFormatting(isOn))
                            }
                    }
                    .contentShape(Rectangle())
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)

                }
            }
            .padding(.top, 8)
            Spacer()
        }.background(theme.colors.background.ignoresSafeArea())
    }
}

// MARK: - Previews

struct ComposerCreateActionList_Previews: PreviewProvider {
    static let stateRenderer = MockComposerCreateActionListScreenState.stateRenderer
    static var previews: some View {
        stateRenderer.screenGroup()
    }
}

struct ComposerToggleActionStyle: ToggleStyle {
    @Environment(\.theme) private var theme

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 50, height: 30, alignment: .center)
                .overlay(
                    Rectangle()
                        .foregroundColor(configuration.isOn
                                         ? theme.colors.accent.opacity(0.5)
                                         : theme.colors.primaryContent.opacity(0.25))
                        .cornerRadius(7)
                        .padding(.all, 8)
                )
                .overlay(
                    Circle()
                        .foregroundColor(configuration.isOn
                                         ? theme.colors.accent
                                         : theme.colors.background)
                        .padding(.all, 3)
                        .offset(x: configuration.isOn ? 11 : -11, y: 0)
                        .shadow(radius: configuration.isOn ? 0.0 : 2.0)
                        .animation(Animation.linear(duration: 0.1))

                ).cornerRadius(20)
                .onTapGesture { configuration.isOn.toggle() }
        }
    }
}
