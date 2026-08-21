F64 EevAlloc(F64 n) {
  I64 cnt = ToI64(n);
  I64 p;
  if (cnt < 1) cnt = 1;
  p = CAlloc(cnt * 8);
  return ToF64(p);
}

F64 EevGet(F64 base, F64 idx) {
  I64 b = ToI64(base);
  I64 i = ToI64(idx);
  F64 *p;
  if (!b) return 0;
  p = b;
  return p[i];
}

U0 EevSet(F64 base, F64 idx, F64 v) {
  I64 b = ToI64(base);
  I64 i = ToI64(idx);
  F64 *p;
  if (!b) return;
  p = b;
  p[i] = v;
}

U0 EevFree(F64 base) {
  I64 b = ToI64(base);
  if (b) Free(b);
}
