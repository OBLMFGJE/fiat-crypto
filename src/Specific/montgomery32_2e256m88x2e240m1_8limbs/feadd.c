static void feadd(uint32_t out[8], const uint32_t in1[8], const uint32_t in2[8]) {
  { const uint32_t x16 = in1[7];
  { const uint32_t x17 = in1[6];
  { const uint32_t x15 = in1[5];
  { const uint32_t x13 = in1[4];
  { const uint32_t x11 = in1[3];
  { const uint32_t x9 = in1[2];
  { const uint32_t x7 = in1[1];
  { const uint32_t x5 = in1[0];
  { const uint32_t x30 = in2[7];
  { const uint32_t x31 = in2[6];
  { const uint32_t x29 = in2[5];
  { const uint32_t x27 = in2[4];
  { const uint32_t x25 = in2[3];
  { const uint32_t x23 = in2[2];
  { const uint32_t x21 = in2[1];
  { const uint32_t x19 = in2[0];
  { uint32_t x33; uint8_t x34 = _addcarryx_u32(0x0, x5, x19, &x33);
  { uint32_t x36; uint8_t x37 = _addcarryx_u32(x34, x7, x21, &x36);
  { uint32_t x39; uint8_t x40 = _addcarryx_u32(x37, x9, x23, &x39);
  { uint32_t x42; uint8_t x43 = _addcarryx_u32(x40, x11, x25, &x42);
  { uint32_t x45; uint8_t x46 = _addcarryx_u32(x43, x13, x27, &x45);
  { uint32_t x48; uint8_t x49 = _addcarryx_u32(x46, x15, x29, &x48);
  { uint32_t x51; uint8_t x52 = _addcarryx_u32(x49, x17, x31, &x51);
  { uint32_t x54; uint8_t x55 = _addcarryx_u32(x52, x16, x30, &x54);
  { uint32_t x57; uint8_t x58 = _subborrow_u32(0x0, x33, 0xffffffff, &x57);
  { uint32_t x60; uint8_t x61 = _subborrow_u32(x58, x36, 0xffffffff, &x60);
  { uint32_t x63; uint8_t x64 = _subborrow_u32(x61, x39, 0xffffffff, &x63);
  { uint32_t x66; uint8_t x67 = _subborrow_u32(x64, x42, 0xffffffff, &x66);
  { uint32_t x69; uint8_t x70 = _subborrow_u32(x67, x45, 0xffffffff, &x69);
  { uint32_t x72; uint8_t x73 = _subborrow_u32(x70, x48, 0xffffffff, &x72);
  { uint32_t x75; uint8_t x76 = _subborrow_u32(x73, x51, 0xffffffff, &x75);
  { uint32_t x78; uint8_t x79 = _subborrow_u32(x76, x54, 0xffa7ffff, &x78);
  { uint32_t _; uint8_t x82 = _subborrow_u32(x79, x55, 0x0, &_);
  { uint32_t x83 = cmovznz32(x82, x78, x54);
  { uint32_t x84 = cmovznz32(x82, x75, x51);
  { uint32_t x85 = cmovznz32(x82, x72, x48);
  { uint32_t x86 = cmovznz32(x82, x69, x45);
  { uint32_t x87 = cmovznz32(x82, x66, x42);
  { uint32_t x88 = cmovznz32(x82, x63, x39);
  { uint32_t x89 = cmovznz32(x82, x60, x36);
  { uint32_t x90 = cmovznz32(x82, x57, x33);
  out[0] = x90;
  out[1] = x89;
  out[2] = x88;
  out[3] = x87;
  out[4] = x86;
  out[5] = x85;
  out[6] = x84;
  out[7] = x83;
  }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}
}
