.importonce

.macro SetValue8Bit(variable, value) {
  lda #value
  sta variable
}
.macro SetValue16Bit(variable, value) {
  lda #<value
  sta variable
  lda #>value
  sta variable + 1
}
