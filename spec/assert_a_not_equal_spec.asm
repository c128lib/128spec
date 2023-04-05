.import source "128spec.asm"

.eval config_128spec("print_immediate_result", false)
sfspec: :init_spec()
  :describe("assert_a_not_equal")

  :it("works for all values of A register");{
    .var a = floor(random()*256)
    .print "a = " + a + " in assert_a_not_equal_works_for_all_values_of_a test"
    .for (var expected = 0;expected < 256; expected++) {
      .if (a != expected) {
        lda #a
        :assert_a_not_equal #expected
      } else {
        lda #a
        :assert_a_not_equal #expected: _128SPEC.assertion_failed_subroutine: _128SPEC.assertion_passed_subroutine
      }
    }
  }

  :it("does not affect A register"); {
    .var a = floor(random()*256)
    .print "a = " + a + " in assert_a_not_equal_does_not_affect_a test"

    lda #a
    .for (var expected = 0;expected < 256; expected++) {
      .if (a != expected) {
        :assert_a_not_equal #expected
      } else {
        :assert_a_not_equal #expected: _128SPEC.assertion_failed_subroutine: _128SPEC.assertion_passed_subroutine
      }
      :assert_a_equal #a
    }
  }

  :finish_spec()

