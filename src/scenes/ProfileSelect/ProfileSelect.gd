#
#  ProfileSelect.gd
#  Copyright 2021 ItJustWorksTM
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#

class_name ProfileSelect
extends Control

const SCENE_FILE := "res://src/scenes/ProfileSelect/ProfileSelect.tscn"

var model: ViewModel

onready var profile_buttons_container: Control = $VBox/HScroll/Margin/HBox

class ViewModel:
    extends ViewModelExt.WithNode

    signal profile_selected(profile)

    func profiles(profiles: Array): return profiles

    func _init(n, profiles: Observable).(n):
        bind() \
            .profiles.dep([profiles]) \
        
        bind() \
            .profiles.to(self, "_list_profiles") \
        
    func select_new_profile():
        emit_signal("profile_selected", Profile.new("Profile"))

    func select_profile(profile):
        emit_signal("profile_selected", profile)

    # TODO: reuse?
    func _list_profiles(profiles: Array):
        var alias = node.profile_buttons_container

        var existing = alias.get_children()
        
        for node in existing: alias.remove_child(node)
        
        var buf = []
        buf.resize(profiles.size())

        for i in range(buf.size()):
            for exist in existing:
                if exist.get_meta("profile") == profiles[i]:
                    buf[i] = exist
            
            if buf[i] == null:
                var label: ProfileSelectButton = ProfileSelectButton.instance()
                label.set_meta("profile", profiles[i])
                alias.add_child(label)
                
                label.init_model(profiles[i])
                label.rect_min_size.x = 296
                conn(label.model, "pressed", "select_profile", [profiles[i]])
                buf[i] = label

                print("created new!")
            else:
                existing.erase(buf[i])
                alias.add_child(buf[i])
            
        
        for node in existing: node.queue_free()


func init_model(profiles): # Array<Profile>
    model = ViewModel.new(self, Observable.from(profiles))

func _ready():
    # Debug
    if true:
        var profiles: Observable = Observable.from([Profile.new("Profile1"), Profile.new("Profile2")])
        init_model(profiles)

        while true:
            profiles.value.append(Profile.new("Profile3"))
            profiles.emit_change()

            print(Reflect.inst2dict2(yield(model, "profile_selected")))

static func instance(): return load(SCENE_FILE).instance()
