// 
// Copyright 2021 New Vector Ltd
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

struct AllChatLayoutEditor: View {

    // MARK: - Properties
    
    // MARK: Private
    
    @Environment(\.theme) private var theme: ThemeSwiftUI
    
    private let gridItemLayout = [GridItem(.fixed(46)), GridItem(.fixed(46))]
    
    // MARK: Public
    
    @ObservedObject var viewModel: AllChatLayoutEditorViewModel.Context
    
    @ViewBuilder
    var body: some View {
        mainScrollView
            .padding(.vertical)
            .background(theme.colors.navigation.ignoresSafeArea())
            .frame(maxHeight: .infinity)
            .navigationTitle(VectorL10n.allChatsEditLayout)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(VectorL10n.done) {
                        viewModel.send(viewAction: .done)
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button(VectorL10n.cancel) {
                        viewModel.send(viewAction: .cancel)
                    }
                }
            }
            .accentColor(theme.colors.accent)
    }
    
    // MARK: - Private
    
    @ViewBuilder
    private var mainScrollView: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(VectorL10n.allChatsEditLayout)
                    .font(theme.fonts.largeTitleB)
                    .foregroundColor(theme.colors.primaryContent)
                    .padding(.leading)
                    .padding(.bottom, 34)
                sections
                    .padding(.leading)
                    .padding(.bottom, 24)
                Divider()
                    .padding(.bottom)
                filters
                    .padding(.leading)
                Divider()
                    .padding(.bottom)
                pinSpaces
                    .padding(.leading)
                    .frame(height: 160)
//                    .padding(.bottom, 24)
                Divider()
                    .padding(.bottom)
                sortingOptions
                    .padding(.horizontal)
                    .padding(.bottom, 24)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    private var sections: some View {
        VStack(alignment: .leading) {
            text(VectorL10n.allChatsEditLayoutAddSectionTitle.uppercased())
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(viewModel.viewState.sections) { section in
                        AllChatLayoutEditorSectionItem(section: section)
                            .onTapGesture {
                                viewModel.send(viewAction: .tappedSectionItem(section))
                            }
                            .animation(.default, value: section.selected)
                    }
                }
            }
            text(VectorL10n.allChatsEditLayoutAddSectionMessage)
        }
    }
    
    @ViewBuilder
    private var filters: some View {
        VStack(alignment: .leading) {
            text(VectorL10n.allChatsEditLayoutAddFiltersTitle.uppercased())
            ScrollView(.horizontal) {
                LazyHGrid(rows: gridItemLayout) {
                    ForEach(viewModel.viewState.filters) { filter in
                        AllChatLayoutEditorFilterItem(filter: filter)
                            .onTapGesture {
                                viewModel.send(viewAction: .tappedFilterItem(filter))
                            }
                            .animation(.default, value: filter.selected)
                    }
                }
            }
        }
        text(VectorL10n.allChatsEditLayoutAddFiltersMessage)
            .padding(.bottom, 24)
    }
    
    @ViewBuilder
    private var pinSpaces: some View {
        VStack(alignment: .leading) {
            text(VectorL10n.allChatsEditLayoutPinSpacesTitle.uppercased())
            ScrollView(.horizontal) {
                LazyHStack(alignment: .top, spacing: 16) {
                    AllChatLayoutEditorPinnedSpaceItem(avatar: nil, image: UIImage(systemName: "plus"), displayName: "Add space", isDeletable: false)
                        .onTapGesture {
                            viewModel.send(viewAction: .addPinnedSpace)
                        }
                    ForEach(viewModel.viewState.pinnedSpaces) { item in
                        AllChatLayoutEditorPinnedSpaceItem(avatar: item.avatar, image: nil/*UIImage(systemName: "folder.fill")*/, displayName: item.displayName, isDeletable: true)
                            .onTapGesture {
                                viewModel.send(viewAction: .removePinnedSpace(item))
                            }
                    }
                }
                .animation(.default, value: viewModel.viewState.pinnedSpaces)
            }
        }
    }
    
    @ViewBuilder
    private var sortingOptions: some View {
        VStack(alignment: .leading) {
            text(VectorL10n.allChatsEditLayoutSortingOptionsTitle.uppercased())
            ForEach(viewModel.viewState.sortingOptions) { option in
                AllChatLayoutEditorSortingRow(option: option)
                    .onTapGesture {
                        viewModel.send(viewAction: .tappedSortingOption(option))
                    }
                    .animation(.default, value: option.selected)
            }
        }
    }
    
    private func text(_ text: String) -> some View {
        Text(text)
            .font(theme.fonts.footnote)
            .foregroundColor(theme.colors.secondaryContent)
    }
}

// MARK: - Previews

struct AllChatLayoutEditor_Previews: PreviewProvider {
    static let stateRenderer = MockAllChatLayoutEditorScreenState.stateRenderer
    static var previews: some View {
        Group {
            stateRenderer.screenGroup()
            stateRenderer.screenGroup()
                .theme(.dark)
                .preferredColorScheme(.dark)
        }
    }
}
