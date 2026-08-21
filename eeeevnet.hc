#define EEV_RECV_MAX 262144
#define EEV_CHUNK      4096

F64 EevNetOpen(U8 *host, F64 port) {
  CNetAddr *addr;
  I64 s;

  addr = NetAddrNew(host, (I64)port);
  if (!addr) return 0;

  s = NetSocketNew(4);
  if (s < 0) {
    NetAddrDel(addr);
    return 0;
  }

  NetConnect(s, addr);
  NetAddrDel(addr);
  return (F64)s;
}

U0 EevNetSend(F64 sf, U8 *data) {
  I64 s = (I64)sf;
  if (!s || !data) return;
  NetWrite(s, data, StrLen(data));
}

F64 EevNetRecv(F64 sf) {
  I64 s = (I64)sf;
  U8 *buf;
  U8 *chunk;
  I64 n;
  I64 total;

  buf = CAlloc(EEV_RECV_MAX);
  if (!s) return (F64)(I64)buf;

  chunk = CAlloc(EEV_CHUNK);
  total = 0;

  while (TRUE) {
    n = NetRead(s, chunk, EEV_CHUNK - 1);
    if (n <= 0) break;
    if (total + n >= EEV_RECV_MAX - 1) break;
    MemCpy(buf + total, chunk, n);
    total += n;
  }

  buf[total] = 0;
  Free(chunk);
  return (F64)(I64)buf;
}

U0 EevNetClose(F64 sf) {
  I64 s = (I64)sf;
  if (s) NetClose(s);
}

U0 EevPrintS(F64 pf) {
  U8 *p = (I64)pf;
  if (p) "%s\n", p;
}

F64 EevHttpGet(U8 *host, U8 *path) {
  F64 s;
  U8 *req;
  F64 res;

  s = EevNetOpen(host, 80.0);
  if (!s) return 0;

  req = MStrPrint("GET %s HTTP/1.0\r\nHost: %s\r\nConnection: close\r\n\r\n",
                  path, host);
  EevNetSend(s, req);
  Free(req);

  res = EevNetRecv(s);
  EevNetClose(s);
  return res;
}
