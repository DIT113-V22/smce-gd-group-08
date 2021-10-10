/*
 *  util.hxx
 *  Copyright 2021 ItJustWorksTM
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 */

#ifndef GODOT_SMCE_EXTENSIONS_HXX
#define GODOT_SMCE_EXTENSIONS_HXX

#include <string>
#include <tuple>
#include <vector>
#include <core/Godot.hpp>

template <class T> auto make_ref() -> godot::Ref<T> {
    static_assert(std::is_base_of_v<godot::Reference, T>);
    return godot::Ref<T>(T::_new());
}

template <class T, class... S> constexpr auto register_signals(S... name) {
    (register_signal<T>(name, godot::Dictionary{}), ...);
};

template <class... T> constexpr auto register_fns(std::pair<const char*, T>... func) {
    (register_method(func.first, func.second), ...);
};

template <class... T> constexpr auto register_props(T... prop) {
    (register_property(std::get<0>(prop), std::get<1>(prop), std::get<2>(prop)), ...);
};

inline std::string std_str(const godot::String& str) {
    return {str.alloc_c_string(), static_cast<size_t>(str.length())};
}

inline std::vector<std::string> std_str_vec(const godot::Array& arr) {
    auto ret = std::vector<std::string>(arr.size());

    for (size_t i = 0; i < arr.size(); ++i) {
        ret.push_back(std::move(std_str(static_cast<godot::String>(arr[i]))));
    }

    return ret;
}

template <class... Base> struct Visitor : Base... {
    template <class... Ts>
    constexpr Visitor(Ts&&... ts) noexcept((std::is_nothrow_move_constructible_v<Base> && ...))
        : Base{std::forward<Ts>(ts)}... {}
    using Base::operator()...;
};
template <class... Ts> Visitor(Ts...) -> Visitor<std::remove_cvref_t<Ts>...>;

#endif // GODOT_SMCE_EXTENSIONS_HXX