.importonce

// The MIT License (MIT)
// 
// Copyright (c) 2015 Michał Taszycki
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

.const _128SPEC_VERSION_MAJOR = 0
.const _128SPEC_VERSION_MINOR = 7
.const _128SPEC_VERSION_PATCH = 2

.function _128spec_version() {
  .return "" + _128SPEC_VERSION_MAJOR + "." + _128SPEC_VERSION_MINOR + "." + _128SPEC_VERSION_PATCH
}

.const _TEXT_COLOR = $F1
.const _BORDER = $d020
.const _BACKGROUND = $d021
.const _CHROUT = $ffd2
.const _CHKOUT = $FFC9
.const _PLOT = $fff0
.const _SETLFS = $FFBA
.const _OPEN = $FFC0
.const _CLOSE = $FFC3
.const _SETBNK = $FF68
.const _SETNAM = $FFBD
.const _CLRCHN = $FFCC
.const _CLRSCR = $c142
.const _PRINTWORD = $8e2e
.const _CR=13
.const _CLS = 147
.const _UPPERCASE = 142
.const _LOWERCASE = 14


.struct _128SPEC_CONFIG {
  print_header,
  clear_screen_at_initialization,
  change_character_set,
  on_exit,
  success_color,
  failure_color,
  change_text_color,
  change_text_color_on_final_result,
  change_text_color_on_immediate_result,
  text_color,
  revert_to_initial_text_color,
  change_background_color,
  change_background_color_on_final_result,
  background_color,
  change_border_color,
  border_color,
  change_border_color_on_final_result,
  print_immediate_result,
  immediate_result_success_character,
  immediate_result_failure_character,
  print_final_results,
  write_final_results_to_file,
  result_file_name,
  assertion_passed_subroutine,
  assertion_failed_subroutine,
  result_all_passed_message,
  result_some_passed_message,
  result_all_failed_message,
  print_configuration,
  print_command_line_options,
  print_context_description,
  print_example_description,
  change_context_description_text_color,
  change_example_description_text_color,
  print_context_results,
  print_example_results,

  _use_custom_result_all_passed_message,
  _use_custom_result_some_passed_message,
  _use_custom_result_all_failed_message,
  _use_custom_assertion_passed_subroutine,
  _use_custom_assertion_failed_subroutine
}

// Default configuration
.const _128SPEC = _128SPEC_CONFIG()
.eval config_128spec("print_header", true)
.eval config_128spec("clear_screen_at_initialization", true)
.eval config_128spec("change_character_set", "lowercase")
.eval config_128spec("on_exit", "rts")

.eval config_128spec("success_color", GREEN)
.eval config_128spec("failure_color", RED)

.eval config_128spec("change_text_color", true)
.eval config_128spec("change_text_color_on_immediate_result", true)
.eval config_128spec("change_text_color_on_final_result", true)
.eval config_128spec("text_color", DARK_GRAY)
.eval config_128spec("revert_to_initial_text_color", false)

.eval config_128spec("change_background_color", true)
.eval config_128spec("change_background_color_on_final_result", false)
.eval config_128spec("background_color", BLACK)

.eval config_128spec("change_border_color", true)
.eval config_128spec("change_border_color_on_final_result", true)
.eval config_128spec("border_color", BLACK)

.eval config_128spec("print_context_description", true)
.eval config_128spec("print_example_description", true)
// TODO: Fix color printing when screen scrolls, and change defaults to true.
.eval config_128spec("change_context_description_text_color", false)
.eval config_128spec("change_example_description_text_color", false)
.eval config_128spec("print_context_results", true)
.eval config_128spec("print_example_results", true)

.eval config_128spec("print_immediate_result", true)
.eval config_128spec("immediate_result_success_character", "default")
.eval config_128spec("immediate_result_failure_character", "default")
.eval config_128spec("print_final_results", true)
.eval config_128spec("write_final_results_to_file", false)
.eval config_128spec("result_file_name", "result.txt")


.eval config_128spec("print_configuration", false)
.eval config_128spec("print_command_line_options", false)

// Overridable addresses. Set at initialization time.
.eval config_128spec("assertion_passed_subroutine", "default")
.eval config_128spec("assertion_failed_subroutine", "default")
.eval config_128spec("result_all_passed_message", "default")
.eval config_128spec("result_some_passed_message", "default")
.eval config_128spec("result_all_failed_message", "default")

// Custom memory markers. 
// Some labels cannot be resolved in the first pass and we can't use them in .if statements.
// Therefore additional boolean variables are used to signify if user customized an address.
.eval _128SPEC.set("_use_custom_result_all_passed_message", false)
.eval _128SPEC.set("_use_custom_result_some_passed_message", false)
.eval _128SPEC.set("_use_custom_result_all_failed_message", false)
.eval _128SPEC.set("_use_custom_assertion_passed_subroutine", false)
.eval _128SPEC.set("_use_custom_assertion_failed_subroutine", false)

.function config_128spec(key, value) {
  .if (validate_boolean_option("print_header", key, value)) .return null
  .if (validate_boolean_option("clear_screen_at_initialization", key, value)) .return null
  .if (validate_boolean_option("change_text_color", key, value)) .return null
  .if (validate_boolean_option("change_text_color_on_immediate_result", key, value)) .return null
  .if (validate_boolean_option("change_text_color_on_final_result", key, value)) .return null
  .if (validate_boolean_option("revert_to_initial_text_color", key, value)) .return null
  .if (validate_boolean_option("change_background_color", key, value)) .return null
  .if (validate_boolean_option("change_background_color_on_final_result", key, value)) .return null
  .if (validate_boolean_option("change_border_color", key, value)) .return null
  .if (validate_boolean_option("change_border_color_on_final_result", key, value)) .return null
  .if (validate_boolean_option("print_immediate_result", key, value)) .return null
  .if (validate_boolean_option("print_final_results", key, value)) .return null
  .if (validate_boolean_option("write_final_results_to_file", key, value)) .return null
  .if (validate_boolean_option("print_configuration", key, value)) .return null
  .if (validate_boolean_option("print_command_line_options", key, value)) .return null
  .if (validate_boolean_option("print_context_description", key, value)) .return null
  .if (validate_boolean_option("print_example_description", key, value)) .return null
  .if (validate_boolean_option("change_context_description_text_color", key, value)) .return null
  .if (validate_boolean_option("change_example_description_text_color", key, value)) .return null
  .if (validate_boolean_option("print_context_results", key, value)) .return null
  .if (validate_boolean_option("print_example_results", key, value)) .return null

  .if (validate_color_option("success_color", key, value)) .return null
  .if (validate_color_option("failure_color", key, value)) .return null
  .if (validate_color_option("text_color", key, value)) .return null
  .if (validate_color_option("background_color", key, value)) .return null
  .if (validate_color_option("border_color", key, value)) .return null

  .if (validate_character_option("immediate_result_success_character", key, value)) .return null
  .if (validate_character_option("immediate_result_failure_character", key, value)) .return null

  .if (validate_non_empty_string_option("result_file_name", key, value)) .return null

  .if (validate_set_option("change_character_set", List().add(
    _128SPEC_SET_OPTION(@"\"lowercase\"", "lowercase"),
    _128SPEC_SET_OPTION(@"\"uppercase\"", "uppercase"),
    _128SPEC_SET_OPTION("false", false)
  ), key, value)) .return null

  .if (validate_set_option("on_exit", List().add(
    _128SPEC_SET_OPTION(@"\"rts\"", "rts"),
    _128SPEC_SET_OPTION(@"\"loop\"", "loop"),
    _128SPEC_SET_OPTION(@"\"jam\"", "jam")
  ), key, value)) .return null

  .if (mark_custom_memory_address_option("assertion_passed_subroutine", key, value)) .return null
  .if (mark_custom_memory_address_option("assertion_failed_subroutine", key, value)) .return null
  .if (mark_custom_memory_address_option("result_all_passed_message", key, value)) .return null
  .if (mark_custom_memory_address_option("result_some_passed_message", key, value)) .return null
  .if (mark_custom_memory_address_option("result_all_failed_message", key, value)) .return null

  .error @"Unrecognized _128SPEC configuration option - \"" + key + @"\""
}
.function mark_custom_memory_address_option(expected_key, key, value) {
  .if (key != expected_key) .return false

  .eval _128SPEC.set("_use_custom_" + expected_key, true)
  .eval _128SPEC.set(key, value)
  .return true
}
.function validate_color_option(expected_key, key, value) {
  .if (key != expected_key) .return false

  .if(value < 0 || value > 15) {
    .error @"_128SPEC configuration option - \"" + expected_key + @"\" has to be a valid color index in a range [0..15]."
  }

  .eval _128SPEC.set(key, value)
  .return true
}
.function validate_boolean_option(expected_key, key, value) {
  .if (key != expected_key) .return false

  .if (value != true && value != false) {
    .error @"_128SPEC configuration option - \"" + expected_key + @"\" has to be either be true or false."
  }

  .eval _128SPEC.set(key, value)
  .return true
}

.function validate_non_empty_string_option(expected_key, key, value) {
  .if (key != expected_key) .return false

  .if (value == "") {
    .error @"_128SPEC configuration option - \"" + expected_key + @"\" cannot be an empty string."
  }

  .eval _128SPEC.set(key, value)
  .return true
}

.function validate_character_option(expected_key, key, value) {
  .if (key != expected_key) .return false

  .if (value != "default" && [value < 0 || value > 255]) {
    .error @"_128SPEC configuration option - \"" + expected_key + @"\" has to be a one byte value representing PETSCII character or \"default\"."
  }

  .eval _128SPEC.set(key, value)
  .return true
}
.struct _128SPEC_SET_OPTION {name, value} 
.function validate_set_option(expected_key, allowed_values, key, value) {
  .if (key != expected_key) .return false

  .var options_string = ""
  .for (var i = 0; i < allowed_values.size(); i++) {
    .eval options_string += allowed_values.get(i).name
    .if (i < allowed_values.size() - 1) {
      .eval options_string += ", "
    }
    .if (value == allowed_values.get(i).value) {
      .eval _128SPEC.set(key, value)
      .return true
    } 
  } 

  .error @"_128SPEC configuration option - \"" + expected_key + @"\" has to be a one of: " + options_string
}

.macro init_spec() {

.if (cmdLineVars.containsKey("on_exit")) {
  .eval _128SPEC.set("on_exit", cmdLineVars.get("on_exit"))
}
.if (cmdLineVars.containsKey("write_final_results_to_file")) {
  .eval _128SPEC.set("write_final_results_to_file", cmdLineVars.get("write_final_results_to_file").asBoolean())
}
.if (cmdLineVars.containsKey("result_file_name")) {
  .eval _128SPEC.set("result_file_name", cmdLineVars.get("result_file_name"))
}

.if (_128SPEC.immediate_result_failure_character == "default") {
  .eval _128SPEC.set("immediate_result_failure_character", [_128SPEC.change_character_set == "lowercase"] ? _128spec_scr_to_pet('x') : _128spec_scr_to_pet('x'))
}
.if (_128SPEC.immediate_result_success_character == "default") {
  .eval _128SPEC.set("immediate_result_success_character", [_128SPEC.change_character_set == "lowercase"] ? _128spec_scr_to_pet('.') : _128spec_scr_to_pet('.'))
}

.if (_128SPEC.print_configuration) {
  .print "128Spec Configuration:"
  .for (var i = 0;i < _128SPEC.getNoOfFields(); i++) {
    .print "  " + _128SPEC.getFieldNames().get(i) + " = " +_128SPEC.get(i)
  }
}

.if (_128SPEC.print_command_line_options) {
  .print "Command Line Options:"
  .for (var i = 0;i < cmdLineVars.keys().size(); i++) {
    .var key = cmdLineVars.keys().get(i)
    .print "  " + key + " = " + cmdLineVars.get(key)
  }
}

    .pc = $1c01 "C128 Basic"
    .word upstartEnd  // link address
    .word 10   // line num
    .byte $9e  // sys
    .text toIntString(tests_init)
    .byte 0
upstartEnd:
    .word 0  // empty link signals the end of the program
    .pc = $1c0e "Basic End"

.pc = * "Tests Data"
  _version_major: .byte _128SPEC_VERSION_MAJOR
  _version_minor: .byte _128SPEC_VERSION_MINOR
  _version_patch: .byte _128SPEC_VERSION_PATCH
  _total_assertions_count: .word 0
  _passed_assertions_count: .word 0
  _tests_result: .word 0
  _stored_a: .byte 0
  _stored_x: .byte 0
  _stored_y: .byte 0
  _stored_p: .byte 0
  _initial_text_color: .if (_128SPEC.change_text_color && _128SPEC.revert_to_initial_text_color) .byte 0
  _header: :_128spec_declare_header(_128SPEC.print_header, _128SPEC.change_character_set == "lowercase")
  _rowCount: .byte 0

.if(!_128SPEC._use_custom_result_all_failed_message) {
  .eval _128SPEC.set("result_all_failed_message", *)
  .if (_128SPEC.change_character_set == "lowercase") {
    :_128spec_pet_text("All Tests FAILED: ")
  } else {
    :_128spec_pet_text("all tests failed: ")
  }
    .byte 0
}
.if(!_128SPEC._use_custom_result_some_passed_message) {
  .eval _128SPEC.set("result_some_passed_message", *)
  .if (_128SPEC.change_character_set == "lowercase") {
    :_128spec_pet_text("Some tests PASSED: ")
  } else {
    :_128spec_pet_text("some tests passed: ")
  }
    .byte 0
}
.if(!_128SPEC._use_custom_result_all_passed_message) {
  .eval _128SPEC.set("result_all_passed_message", *)
  .if (_128SPEC.change_character_set == "lowercase") {
    :_128spec_pet_text("All tests PASSED: ")
  } else {
    :_128spec_pet_text("all tests passed: ")
  }
    .byte 0
}
_last_context: :_128spec_declare_common_context_and_example_metadata(_128SPEC.print_context_description)
_last_example: :_128spec_declare_common_context_and_example_metadata(_128SPEC.print_example_description)
_description_data: :_128spec_declare_description_data(_128SPEC.print_context_description || _128SPEC.print_example_description)

.pc = * "Tests Subroutines"
.if(!_128SPEC._use_custom_assertion_passed_subroutine) {
  .eval _128SPEC.set("assertion_passed_subroutine", *)
    :_assertion_passed()
    rts
}
.if(!_128SPEC._use_custom_assertion_failed_subroutine) {
  .eval _128SPEC.set("assertion_failed_subroutine", *)
    :_assertion_failed()
    rts
}
  _print_string:
    :_print_string($ffff)
    rts
.pc = * "Test Initialization"
tests_init:
.if (_128SPEC.clear_screen_at_initialization) {
  :_print_char #_CLS
}
.if (_128SPEC.change_character_set != false) {
  :_print_char #[[_128SPEC.change_character_set == "lowercase"] ? _LOWERCASE : _UPPERCASE]
} 
.if (_128SPEC.change_text_color && _128SPEC.revert_to_initial_text_color) {
  :_128spec_mov _TEXT_COLOR : _initial_text_color
}
:_set_text_color #_128SPEC.text_color
.if (_128SPEC.change_background_color) {
  :_128spec_mov #_128SPEC.background_color : _BACKGROUND
}
.if (_128SPEC.change_border_color) {
  :_128spec_mov #_128SPEC.border_color : _BORDER
}
.if (_128SPEC.print_header) {
  :_print_string #sfspec._header
}
:_reset_tests_result(sfspec)

.pc = * "Specification"
specification:
}

.macro finish_spec() {
.pc = * "Spec Results Rendering" 
    :_finalize_last_context()
    :_finalize_last_example()
    :render_results()
    .if (_128SPEC.revert_to_initial_text_color) {
      :_set_text_color sfspec._initial_text_color
    } else {
      :_set_text_color #_128SPEC.text_color
    }
    .if (_128SPEC.on_exit == "rts") {
        rts
    } else .if (_128SPEC.on_exit == "loop") {
      end:
        jmp end
    } else /* jam */ {
        .byte $02 
    }
}

.macro _assertion_failed() {
    :_increment_test_result(sfspec, false)
  .if (_128SPEC.print_context_description) {
    :_increment_test_result(sfspec._last_context, false)
  }
  .if (_128SPEC.print_example_description) {
    :_increment_test_result(sfspec._last_example, false)
  }
  .if (_128SPEC.print_immediate_result) {
    .if (_128SPEC.change_text_color_on_immediate_result) {
      :_set_text_color #_128SPEC.failure_color
    }
    :_print_char #_128SPEC.immediate_result_failure_character
  }
}

.macro _assertion_passed() {
    :_increment_test_result(sfspec, true)
  .if (_128SPEC.print_context_description) {
    :_increment_test_result(sfspec._last_context, true)
  }
  .if (_128SPEC.print_example_description) {
    :_increment_test_result(sfspec._last_example, true)
  }
  .if (_128SPEC.print_immediate_result) {
    .if (_128SPEC.change_text_color_on_immediate_result) {
      :_set_text_color #_128SPEC.success_color
    }
    :_print_char #_128SPEC.immediate_result_success_character
  }
}

.macro _increment_test_result(namespace, passed) {
  :_128spec_inc16 namespace._total_assertions_count
  .if (passed) {
    :_128spec_inc16 namespace._passed_assertions_count
  }
}
.macro _reset_tests_result(namespace) {
  :_128spec_mov16 #$0000 : namespace._total_assertions_count
  :_128spec_mov16 #$0000 : namespace._passed_assertions_count
}
.macro _calculate_tests_result(namespace) {
    lda namespace._total_assertions_count
    cmp namespace._passed_assertions_count
    bne !fail+
    lda namespace._total_assertions_count + 1
    cmp namespace._passed_assertions_count + 1
    bne !fail+
  !pass:
    // We are "overflowing" with success
    lda #%01000000
    sta namespace._tests_result
    jmp !end+
  !fail:
    lda namespace._passed_assertions_count
    bne !incomplete_fail+
    lda namespace._passed_assertions_count + 1
    bne !incomplete_fail+
  !complete_fail:
    // We are "not overflowing" with success
    lda #%00000000
    sta namespace._tests_result
    jmp !end+
  !incomplete_fail:
    // This is "MInor" failure
    lda #%10000000
    sta namespace._tests_result
  !end:
}

.macro render_results() {
  :_calculate_tests_result(sfspec)
  :_set_screen_colors()
  :_change_text_color_on_final_result()
  .if (_128SPEC.print_final_results) {
    :_print_final_results()
  }
  .if (_128SPEC.write_final_results_to_file) {
    :_write_final_results_to_file()
  }
}

.macro _write_final_results_to_file() {
  :_128spec_open_file_for_writing(_128SPEC.result_file_name, 13)
  :_128spec_set_file_output(13)
  :_print_final_results()
  :_128spec_close_file(13)
  :_128spec_set_screen_output()
}

.macro _change_text_color_on_final_result() {
  .if (_128SPEC.change_text_color_on_final_result) {
    bit sfspec._tests_result
    bvs success 
    failure:
      :_set_text_color #_128SPEC.failure_color
    jmp end
    success:
      :_set_text_color #_128SPEC.success_color
    end:
  } else {
    :_set_text_color #_128SPEC.text_color
  }
}

.macro _set_screen_colors() {
  .if ([_128SPEC.change_border_color && _128SPEC.change_border_color_on_final_result] || [_128SPEC.change_background_color && _128SPEC.change_background_color_on_final_result]) {
      bit sfspec._tests_result
      bvs success 
  failure:
      lda #_128SPEC.failure_color
      jmp end
  success:
      lda #_128SPEC.success_color
  end:
    .if (_128SPEC.change_border_color && _128SPEC.change_border_color_on_final_result) {
      sta _BORDER
    }
    .if (_128SPEC.change_background_color && _128SPEC.change_background_color_on_final_result) {
      sta _BACKGROUND
    }
  }
}

.macro _print_result_numbers(namespace) {
  :_print_char #'(' 
  :_print_int16 namespace._passed_assertions_count
  :_print_char #'/' 
  :_print_int16 namespace._total_assertions_count
  :_print_char #')' 
  :_print_char #_CR
}

.macro _print_final_results() {
    :_print_char #_CR
    bit sfspec._tests_result
    bvs success 
    bmi partial_failure
  failure:
    :_print_string #_128SPEC.result_all_failed_message
    jmp end
  partial_failure:
    :_print_string #_128SPEC.result_some_passed_message
    jmp end
  success:
    :_print_string #_128SPEC.result_all_passed_message
  end:
    :_print_result_numbers(sfspec)
}

// Assertions
.pseudocommand assert_i_cleared pass_subroutine : fail_subroutine {
  :assert_i_set _given_or_default(fail_subroutine, _128SPEC.assertion_failed_subroutine) : _given_or_default(pass_subroutine, _128SPEC.assertion_passed_subroutine)
}

.pseudocommand assert_i_set pass_subroutine : fail_subroutine {
  :assert_p_has_masked_bits_set #%00000100 : _given_or_default(pass_subroutine, _128SPEC.assertion_passed_subroutine) : _given_or_default(fail_subroutine, _128SPEC.assertion_failed_subroutine)
}

.pseudocommand assert_d_cleared pass_subroutine : fail_subroutine {
  :assert_d_set _given_or_default(fail_subroutine, _128SPEC.assertion_failed_subroutine) : _given_or_default(pass_subroutine, _128SPEC.assertion_passed_subroutine)
}

.pseudocommand assert_d_set pass_subroutine : fail_subroutine {
  :assert_p_has_masked_bits_set #%00001000 : _given_or_default(pass_subroutine, _128SPEC.assertion_passed_subroutine) : _given_or_default(fail_subroutine, _128SPEC.assertion_failed_subroutine)
}

.pseudocommand assert_p_has_masked_bits_cleared mask : pass_subroutine : fail_subroutine {
  :assert_masked_bits_cleared sfspec._stored_p : mask : pass_subroutine : fail_subroutine
}
.pseudocommand assert_p_has_masked_bits_set mask : pass_subroutine : fail_subroutine {
  :assert_masked_bits_set sfspec._stored_p : mask : pass_subroutine : fail_subroutine
}
.pseudocommand assert_masked_bits_cleared actual : mask : pass_subroutine : fail_subroutine {
    :_store_state()
    lda actual
    eor $ff
    and mask 
    bne pass_or_fail.fail
  pass_or_fail: :_pass_or_fail pass_subroutine : fail_subroutine
    :_restore_state()
}
.pseudocommand assert_masked_bits_set actual : mask : pass_subroutine : fail_subroutine {
    :_store_state()
    lda actual
    and mask
    cmp mask 
    bne pass_or_fail.fail
  pass_or_fail: :_pass_or_fail pass_subroutine : fail_subroutine
    :_restore_state()
}
.pseudocommand assert_p_equal expected : pass_subroutine : fail_subroutine {
  :assert_equal sfspec._stored_p : expected : pass_subroutine : fail_subroutine
}

.pseudocommand assert_v_cleared pass_subroutine : fail_subroutine {
  :assert_v_set _given_or_default(fail_subroutine, _128SPEC.assertion_failed_subroutine) : _given_or_default(pass_subroutine, _128SPEC.assertion_passed_subroutine)
}

.pseudocommand assert_v_set pass_subroutine : fail_subroutine {
  :assert_p_has_masked_bits_set #%01000000 : pass_subroutine : fail_subroutine
}

.pseudocommand assert_n_cleared pass_subroutine : fail_subroutine {
  :assert_n_set _given_or_default(fail_subroutine, _128SPEC.assertion_failed_subroutine) : _given_or_default(pass_subroutine, _128SPEC.assertion_passed_subroutine)
}

.pseudocommand assert_n_set pass_subroutine : fail_subroutine {

  :assert_p_has_masked_bits_set #%10000000 : pass_subroutine : fail_subroutine
}
.pseudocommand assert_c_cleared pass_subroutine : fail_subroutine {
  :assert_c_set _given_or_default(fail_subroutine, _128SPEC.assertion_failed_subroutine) : _given_or_default(pass_subroutine, _128SPEC.assertion_passed_subroutine)
}

.pseudocommand assert_c_set pass_subroutine  : fail_subroutine {
  :assert_p_has_masked_bits_set #%00000001 : pass_subroutine : fail_subroutine
}

.pseudocommand assert_z_cleared pass_subroutine : fail_subroutine {
  :assert_z_set _given_or_default(fail_subroutine, _128SPEC.assertion_failed_subroutine) : _given_or_default(pass_subroutine, _128SPEC.assertion_passed_subroutine)
}

.pseudocommand assert_z_set pass_subroutine : fail_subroutine {
  :assert_p_has_masked_bits_set #%00000010 : pass_subroutine : fail_subroutine
}

.pseudocommand assert_y_not_zero pass_subroutine : fail_subroutine {
  :assert_y_zero _given_or_default(fail_subroutine, _128SPEC.assertion_failed_subroutine) : _given_or_default(pass_subroutine, _128SPEC.assertion_passed_subroutine)
}

.pseudocommand assert_y_zero pass_subroutine : fail_subroutine {
  :assert_y_equal #0 : pass_subroutine : fail_subroutine
}

.pseudocommand assert_y_not_equal expected : pass_subroutine : fail_subroutine {
  :assert_y_equal expected : _given_or_default(fail_subroutine, _128SPEC.assertion_failed_subroutine) : _given_or_default(pass_subroutine, _128SPEC.assertion_passed_subroutine)
}

.pseudocommand assert_y_equal expected : pass_subroutine : fail_subroutine {
  :assert_equal sfspec._stored_y : expected : pass_subroutine : fail_subroutine
}

.pseudocommand assert_x_not_zero pass_subroutine : fail_subroutine {
  :assert_x_zero _given_or_default(fail_subroutine, _128SPEC.assertion_failed_subroutine) : _given_or_default(pass_subroutine, _128SPEC.assertion_passed_subroutine)
}

.pseudocommand assert_x_zero pass_subroutine : fail_subroutine {
  :assert_x_equal #0 : pass_subroutine : fail_subroutine
}

.pseudocommand assert_x_not_equal expected : pass_subroutine : fail_subroutine {
  :assert_x_equal expected : _given_or_default(fail_subroutine, _128SPEC.assertion_failed_subroutine) : _given_or_default(pass_subroutine, _128SPEC.assertion_passed_subroutine)
}
.pseudocommand assert_x_equal expected : pass_subroutine : fail_subroutine {
  :assert_equal sfspec._stored_x : expected : pass_subroutine : fail_subroutine
}

.pseudocommand assert_xy_equal pass_subroutine : fail_subroutine {
  :assert_equal sfspec._stored_x : sfspec._stored_y : pass_subroutine : fail_subroutine
}
.pseudocommand assert_a_not_zero pass_subroutine : fail_subroutine {
  :assert_a_zero _given_or_default(fail_subroutine, _128SPEC.assertion_failed_subroutine) : _given_or_default(pass_subroutine, _128SPEC.assertion_passed_subroutine)
}

.pseudocommand assert_a_zero pass_subroutine : fail_subroutine {
  :assert_a_equal #0 : pass_subroutine : fail_subroutine
}

.pseudocommand assert_a_not_equal expected : pass_subroutine : fail_subroutine {
  :assert_a_equal expected : _given_or_default(fail_subroutine, _128SPEC.assertion_failed_subroutine) : _given_or_default(pass_subroutine, _128SPEC.assertion_passed_subroutine)
}

.pseudocommand assert_a_equal expected : pass_subroutine : fail_subroutine {
  :assert_equal sfspec._stored_a : expected : pass_subroutine : fail_subroutine
}

.pseudocommand assert_not_equal actual : expected : pass_subroutine : fail_subroutine {
  :assert_equal actual : expected : _given_or_default(fail_subroutine, _128SPEC.assertion_failed_subroutine) : _given_or_default(pass_subroutine, _128SPEC.assertion_passed_subroutine)
}
.pseudocommand assert_not_equal16 actual : expected : pass_subroutine : fail_subroutine {
  :assert_equal16 actual : expected : _given_or_default(fail_subroutine, _128SPEC.assertion_failed_subroutine) : _given_or_default(pass_subroutine, _128SPEC.assertion_passed_subroutine)
}
.pseudocommand assert_not_equal24 actual : expected : pass_subroutine : fail_subroutine {
  :assert_equal24 actual : expected : _given_or_default(fail_subroutine, _128SPEC.assertion_failed_subroutine) : _given_or_default(pass_subroutine, _128SPEC.assertion_passed_subroutine)
}
.pseudocommand assert_not_equal32 actual : expected : pass_subroutine : fail_subroutine {
  :assert_equal32 actual : expected : _given_or_default(fail_subroutine, _128SPEC.assertion_failed_subroutine) : _given_or_default(pass_subroutine, _128SPEC.assertion_passed_subroutine)
}

.macro assert_bytes_not_equal(bytes_count, actual, expected, pass_subroutine, fail_subroutine) {
  :assert_bytes_equal(bytes_count, actual, expected, _given_or_default(fail_subroutine, _128SPEC.assertion_failed_subroutine), _given_or_default(pass_subroutine, _128SPEC.assertion_passed_subroutine))
}
.pseudocommand assert_bytes_not_equal bytes_count : actual : expected : pass_subroutine : fail_subroutine {
  :assert_bytes_equal bytes_count : actual : expected : _given_or_default(fail_subroutine, _128SPEC.assertion_failed_subroutine) : _given_or_default(pass_subroutine, _128SPEC.assertion_passed_subroutine)
}

.pseudocommand assert_equal actual : expected : pass_subroutine : fail_subroutine {
   :_assert_equal _bits_to_bytes(8) : actual : expected : pass_subroutine : fail_subroutine
}
.pseudocommand assert_equal16 actual : expected : pass_subroutine : fail_subroutine {
   :_assert_equal _bits_to_bytes(16) : actual : expected : pass_subroutine : fail_subroutine
}
.pseudocommand assert_equal24 actual : expected : pass_subroutine : fail_subroutine {
   :_assert_equal _bits_to_bytes(24) : actual : expected : pass_subroutine : fail_subroutine
}
.pseudocommand assert_equal32 actual : expected : pass_subroutine : fail_subroutine {
   :_assert_equal _bits_to_bytes(32) : actual : expected : pass_subroutine : fail_subroutine
}


.pseudocommand _assert_equal bytes_count : actual : expected : pass_subroutine : fail_subroutine {
  :_store_state()  
  .for (var byte_id = 0; byte_id < bytes_count.getValue(); byte_id++) {
    lda _128spec_extract_byte_argument(actual, byte_id)
    cmp _128spec_extract_byte_argument(expected, byte_id)
    bne pass_or_fail.fail
  } 
  pass_or_fail: :_pass_or_fail pass_subroutine : fail_subroutine
  :_restore_state()
}

.pseudocommand assert_unsigned_greater_or_equal actual : expected : pass_subroutine : fail_subroutine {
  :assert_unsigned_less actual : expected : _given_or_default(fail_subroutine, _128SPEC.assertion_failed_subroutine) : _given_or_default(pass_subroutine, _128SPEC.assertion_passed_subroutine)
}

.pseudocommand assert_unsigned_less actual : expected : pass_subroutine : fail_subroutine {
  :_store_state()  
    lda actual
    cmp expected
    bcs pass_or_fail.fail
  pass_or_fail: :_pass_or_fail pass_subroutine : fail_subroutine
  :_restore_state()
}

.pseudocommand assert_unsigned_less_or_equal actual : expected : pass_subroutine : fail_subroutine {
  :assert_unsigned_greater actual : expected : _given_or_default(fail_subroutine, _128SPEC.assertion_failed_subroutine) : _given_or_default(pass_subroutine, _128SPEC.assertion_passed_subroutine)
}

.pseudocommand assert_unsigned_greater actual : expected : pass_subroutine : fail_subroutine {
  :_store_state()  
    lda actual
    cmp expected
    bcc pass_or_fail.fail
    beq pass_or_fail.fail
  pass_or_fail: :_pass_or_fail pass_subroutine : fail_subroutine
  :_restore_state()
}

.macro _store_state() {
    php
    sta sfspec._stored_a
    stx sfspec._stored_x
    sty sfspec._stored_y
    pla 
    sta sfspec._stored_p
}

.macro _restore_state() {
    lda sfspec._stored_p
    pha
    ldy sfspec._stored_y
    ldx sfspec._stored_x
    lda sfspec._stored_a
    plp // restore p
}

.macro assert_bytes_equal(bytes_count, actual, expected, pass_subroutine, fail_subroutine) {
  :assert_bytes_equal bytes_count : actual : expected : _given_or_default(pass_subroutine, _128SPEC.assertion_passed_subroutine) :  _given_or_default(fail_subroutine, _128SPEC.assertion_failed_subroutine)
}
.pseudocommand assert_bytes_equal bytes_count : actual : expected : pass_subroutine : fail_subroutine {
  // TODO: remove pages and remainder branches
  .var remainder = mod(bytes_count.getValue(), 256)
  .var offset = bytes_count.getValue() - remainder
  .var pages = offset / 256
    ldy #pages
    beq !end+
  loopy:
    ldx #0
  loopx:
    .label actual_hi = * + 2
    lda actual.getValue(), X
    .label expected_hi = * + 2
    cmp expected.getValue(), X
    bne pass_or_fail.fail 
    inx
    bne loopx
    inc actual_hi 
    inc expected_hi
    dey
    bne loopy
  !end:
    ldy #remainder
    beq !end+
    ldx #0
  loop:
    lda offset + actual.getValue(), X
    cmp offset + expected.getValue(), X
    bne pass_or_fail.fail 
    inx
    cpx #remainder
    bne loop
  !end:
  pass_or_fail: :_pass_or_fail pass_subroutine : fail_subroutine
}
.pseudocommand assert_pass pass_subroutine : fail_subroutine {
  :_store_state()
  jsr _given_or_default(pass_subroutine, _128SPEC.assertion_passed_subroutine)
  :_restore_state()
}

.pseudocommand assert_fail pass_subroutine : fail_subroutine {
  :_store_state()
  jsr _given_or_default(fail_subroutine, _128SPEC.assertion_failed_subroutine)
  :_restore_state()
}

.pseudocommand _pass_or_fail pass_subroutine : fail_subroutine {
  pass:
    jsr _given_or_default(pass_subroutine, _128SPEC.assertion_passed_subroutine)
    jmp end
  fail:
    jsr _given_or_default(fail_subroutine, _128SPEC.assertion_failed_subroutine)
  end:
}

.macro describe(subject) {
  .if (_128SPEC.print_context_description) {
    jmp end_text
    text:
      .if (_128SPEC.print_immediate_result || _128SPEC.print_example_description) {
        .byte _CR
      }
      :_128spec_pet_text(subject)
      .byte ' '
      .byte 0
    scoring:
      .text "           " 
      .byte _CR
      .byte 0
    end_text:
    :_finalize_last_context()
    lda sfspec._description_data + 2
    ora #%10000000
    sta sfspec._description_data + 2
    :_128spec_mov16 #text : sfspec._last_context
    :_128spec_kernal_plot_get(sfspec._last_context._cursor_position)
    :_set_text_color #_128SPEC.text_color
    :_print_string #text
    :_print_string #scoring
  }
}

.macro _finalize_last_context() {
  .if (_128SPEC.print_context_description ) {
    .if (_128SPEC.change_context_description_text_color) {
      :_calculate_tests_result(sfspec._last_context)
    
      bit sfspec._last_context._tests_result
      bvs pass
    fail:
      :_set_text_color #_128SPEC.failure_color
      jmp end_color
    pass:
      :_set_text_color #_128SPEC.success_color
    end_color:
    }
    .if (_128SPEC.change_context_description_text_color || _128SPEC.print_context_results) {
      bit sfspec._description_data + 2
      bvc end
      :_128spec_kernal_plot_get(sfspec._description_data._cursor_position)
      :_128spec_kernal_plot_set(sfspec._last_context._cursor_position)
      :_print_string sfspec._last_context
      :_print_result_numbers(sfspec._last_context)

      :_128spec_kernal_plot_set(sfspec._description_data._cursor_position)
      :_reset_tests_result(sfspec._last_context)
    end:
    }
  }
}

.macro it(description) {
  .if (_128SPEC.print_example_description) {
    .if (!_128SPEC.write_final_results_to_file) {
        inc sfspec._rowCount
    }
    jmp end_text
    text:
      .if (_128SPEC.print_immediate_result) {
        .byte _CR
      }
      .byte ' '
      :_128spec_pet_text(description)
      .byte ' '
      .byte 0
    scoring:
      .text "           " 
      .byte _CR
      .byte 0
    press_space:
      .byte _CR
      :_128spec_pet_text("Press SPACE to continue")
      .byte _CR
      .byte 0
    end_text:
      :_finalize_last_example()
      lda sfspec._description_data + 2
      ora #%01000000
      sta sfspec._description_data + 2
      :_128spec_mov16 #text : sfspec._last_example
      :_128spec_kernal_plot_get(sfspec._last_example._cursor_position)
      :_set_text_color #_128SPEC.text_color
      :_print_string #text
      :_print_string #scoring

      lda sfspec._rowCount
      cmp #4
      bne !ExitNow+
      :_print_string #press_space
      lda #0
      sta sfspec._rowCount

      WaitSpacePressed()
    !ExitNow:
  }
}

.macro WaitSpacePressed() {
    lda #%01111111
    sta MaskOnPortA
    lda #%00010000
    sta MaskOnPortB
    sei
  !Start:
    lda #%11111111
    sta $dc02
    lda #%00000000
    sta $dc03

    lda MaskOnPortA
    sta $dc00
    lda $dc01
    and MaskOnPortB
    bne !Start-
    cli
    jmp !+

  MaskOnPortA:    .byte $00
  MaskOnPortB:    .byte $00
  !:
}

.macro _finalize_last_example() {
  .if (_128SPEC.print_example_description) {
    .if (_128SPEC.change_example_description_text_color) {
      :_calculate_tests_result(sfspec._last_example)
      bit sfspec._last_example + 8
      bvs pass
    fail:
      :_set_text_color #_128SPEC.failure_color
      jmp end_color
    pass:
      :_set_text_color #_128SPEC.success_color
    end_color:
    }
    .if (_128SPEC.change_example_description_text_color || _128SPEC.print_example_results) {
      bit sfspec._description_data + 2
      bvc end
      :_128spec_kernal_plot_get(sfspec._description_data._cursor_position)
      :_128spec_kernal_plot_set(sfspec._last_example._cursor_position)
      :_print_string sfspec._last_example
      :_print_result_numbers(sfspec._last_example)
      :_128spec_kernal_plot_set(sfspec._description_data._cursor_position)
      :_reset_tests_result(sfspec._last_example)
    end:
    }
  }
}

// helper functions

.function _given_or_default(given, default) {
  .if (given.getType() == AT_NONE) {
    .return CmdArgument(AT_ABSOLUTE, default)
  } else {
    .return given
  }
}
.function _128spec_extract_byte_argument(arg, byte_id) {
  .if (arg.getType()==AT_IMMEDIATE) {
    .return CmdArgument(arg.getType(), _extract_byte(arg.getValue(), byte_id))
  } else {
    .return CmdArgument(arg.getType(), arg.getValue() + byte_id)
  }
}

.function _extract_byte(value, byte_id) {
  .var bits = _bytes_to_bits(byte_id)
  .eval value = value >> bits
  .return value & $ff
}
.function _bytes_to_bits(bytes) {
  .return bytes * 8
}

.function _bits_to_bytes(bits) {
  .return bits / 8
}

.pseudocommand _print_string string {
  :_128spec_mov16 string : sfspec._print_string.string_address
  jsr sfspec._print_string
}
.macro _print_string(string) {
  ldy #0
loop:
.label string_address = * + 1
  lda string, Y
  beq end
  jsr _CHROUT
  iny
  jmp loop
end:
}

.pseudocommand _print_char char {
  lda char
  jsr _CHROUT
}

.pseudocommand _print_int8 value {
  ldx value
  stx $3b
  lda #0
  sta $3c
  jsr _PRINTWORD
}

.pseudocommand _print_int16 value {
  ldx _128spec_extract_byte_argument(value, 0)
  stx $3b
  lda _128spec_extract_byte_argument(value, 1)
  sta $3c
  jsr _PRINTWORD
}


.pseudocommand _set_text_color color {
  .if (_128SPEC.change_text_color) {
    :_128spec_mov color : _TEXT_COLOR
  }
}

.pseudocommand _128spec_mov source : destination {
  :_128spec__mov _bits_to_bytes(8) : source : destination
}

.pseudocommand _128spec_mov16 source : destination {
  :_128spec__mov _bits_to_bytes(16) : source : destination
}

.pseudocommand _128spec__mov bytes_count : source : destination {
  .for (var i = 0; i < bytes_count.getValue(); i++) {
    lda _128spec_extract_byte_argument(source, i) 
    sta _128spec_extract_byte_argument(destination, i) 
  } 
}

.pseudocommand _128spec_inc16 arg {
  :_128spec__inc _bits_to_bytes(16) : arg
}

.pseudocommand _128spec__inc bytes : arg {
  .for (var byte_id = 0;byte_id < bytes.getValue(); byte_id++) {
    inc _128spec_extract_byte_argument(arg, byte_id)
    bne end 
  }
  end:
}
.macro _128spec_pet_text(string) {
  .fill string.size(), _128spec_scr_to_pet(string.charAt(i))
}

.function _128spec_scr_to_pet(screencode) {
  .var result = screencode
  .if (screencode < 32) {
    .return result + 64
  } 
  .if (screencode < 64) {
    .return result
  }
  .if (screencode < 95) {
    .return result + 128
  }
  .if (screencode == 95) { // underscore
    .return 164
  }
  .if (screencode < 128) {
    .return result + 64
  } 
  .if (screencode < 160) {
    .return result - 128
  } 
  .if (screencode < 224) {
    .return result - 64
  } 
  .return result
}

.macro _128spec_open_file_for_writing(string, logical_file_number) {
  jmp end_filename
filename:
  :_128spec_pet_text(string)
  :_128spec_pet_text(",p,w")
end_filename:
  _128spec_kernal_setbnk
  :_128spec_kernal_setnam #[end_filename - filename] : #filename
  :_128spec_kernal_setlfs #logical_file_number : #8 : #2
  :_128spec_kernal_open
}

.macro _128spec_close_file(logical_file_number) {
  lda #logical_file_number
  jsr _CLOSE
}

.macro _128spec_set_file_output(logical_file_number) {
  ldx #logical_file_number
  jsr _CHKOUT
}

.macro _128spec_set_screen_output() {
  jsr _CLRCHN
}


.pseudocommand _128spec_kernal_setbnk {
  lda #0
  tax
  jsr _SETBNK
}
.pseudocommand _128spec_kernal_setnam length : string_address {
  lda length
  ldx _128spec_extract_byte_argument(string_address, 0)
  ldy _128spec_extract_byte_argument(string_address, 1)
  jsr _SETNAM
}
.pseudocommand _128spec_kernal_setlfs logical_file_number : device_number : command {
  lda logical_file_number
  ldx device_number
  ldy command
  jsr _SETLFS
}


.pseudocommand _128spec_kernal_open {
  jsr _OPEN
}

.macro _128spec_kernal_plot_get(cursor_position) {
  sec
  jsr _PLOT
  stx cursor_position._row
  sty cursor_position._column
}
.macro _128spec_kernal_plot_set(cursor_position) {
  clc
  ldx cursor_position._row
  ldy cursor_position._column
  jsr _PLOT
}

.macro _128spec_declare_common_context_and_example_metadata(allocate_data) {
    _text_pointer: .if (allocate_data) .word 0
    _cursor_position: :_128spec_declare_cursor_position(allocate_data)
    _total_assertions_count: .if (allocate_data) .word 0
    _passed_assertions_count: .if (allocate_data) .word 0
    _tests_result: .if (allocate_data) .byte 0 
}

.macro _128spec_declare_description_data(allocate_data) {
  _cursor_position: :_128spec_declare_cursor_position(allocate_data) 
  _flags: .if (allocate_data) .byte 0 // - 7 cleared - first context, 6 cleared - first example
}

.macro _128spec_declare_cursor_position(allocate_data) {
  _column: .if (allocate_data) .byte 0
  _row: .if (allocate_data) .byte 0
}

.macro _128spec_declare_header(allocate_data, charset_is_lowercase) {
  .if (allocate_data) {
    .var lines = List()
      .if (charset_is_lowercase) {
        .eval lines.add("****** 128spec v" + _128spec_version() + " ******")
          .eval lines.add("Testing Framework by Michal Taszycki")
          .eval lines.add("Porting to c128 by Raffaele Intorcia")
          .eval lines.add("Docs at http://64bites.com/64spec")
          .eval lines.add("Docs at https://c128lib.github.io")
      } else {
        .eval lines.add("****** 128spec v" + _128spec_version() + " ******")
          .eval lines.add("testing framework by michal taszycki")
          .eval lines.add("porting to c128 by raffaele intorcia")
          .eval lines.add("docs at http://64bites.com/64spec")
          .eval lines.add("docs at https://c128lib.github.io")
      }
    .byte _CR
      .for (var i = 0; i < lines.size(); i++) {
        .fill [40 - lines.get(i).size()] / 2, ' '
          :_128spec_pet_text(lines.get(i))
          .byte _CR
          .byte _CR
      }
    .byte 0
  }
}

#import "helper.asm"
