.import source "128spec.asm"

sfspec: :init_spec()
  
  :assert_a_equal #42

  :finish_spec()
