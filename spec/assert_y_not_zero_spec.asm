.import source "128spec.asm"

sfspec: :init_spec()

assert_y_not_zero_works_for_all_values_of_y: {
  .for (var y = 0; y < 256; y++) {
    .if (y != 0) {
      ldy #y
      :assert_y_not_zero 
    } else {
      ldy #y
      :assert_y_not_zero _128SPEC.assertion_failed_subroutine: _128SPEC.assertion_passed_subroutine
    }
  }
}

assert_y_does_not_affect_y:
  .for (var y = 0; y < 256; y++) {
    ldy #y
    .if (y != 0) {
      :assert_y_not_zero 
    } else {
      :assert_y_not_zero _128SPEC.assertion_failed_subroutine: _128SPEC.assertion_passed_subroutine
    }
    :assert_y_equal #y
  }

  :finish_spec()

