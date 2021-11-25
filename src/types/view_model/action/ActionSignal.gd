#
#  ActionSignal.gd
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

class_name ActionSignal
extends Action

signal invoked(args)

func _init().(null, ""): pass

func invoke(args: Array = [], binds = []) -> void:
    print(["invoked"] + args + _extra + binds)
    callv("emit_signal", ["invoked"] + args + _extra + binds)
    print("ActionSignal: [", _method, "], Args: ", args, " Binds: ", binds)
