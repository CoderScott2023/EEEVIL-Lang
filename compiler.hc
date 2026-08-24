#define TK_EOF       0
#define TK_VAR       1
#define TK_IDENT     2
#define TK_NUM       3
#define TK_ASSIGN    4
#define TK_PLUS      5
#define TK_MINUS     6
#define TK_MUL       7
#define TK_SEMI      8
#define TK_LPAREN    9
#define TK_RPAREN   10
#define TK_PRINT    11
#define TK_LBRACE   12
#define TK_RBRACE   13
#define TK_COMMA    14
#define TK_IF       15
#define TK_ELSE     16
#define TK_WHILE    17
#define TK_CLASS    18
#define TK_RETURN   19
#define TK_NEW      20
#define TK_DOT      21
#define TK_EQ       22 // ==
#define TK_LT       23 // <
#define TK_GT       24 // >
#define TK_DIV      25 // /
#define TK_GTE      26 // >=
#define TK_LTE      27 // <=
#define TK_NE       28 // !=
#define TK_AND      29 // &&
#define TK_OR       30 // ||
#define TK_NOT      31 // !
#define TK_TRUE     32
#define TK_FALSE    33
#define TK_STR      34
#define TK_INPUT    35
#define TK_FNUM     36
#define TK_LBRACK   37
#define TK_RBRACK   38
#define TK_FOR      39
#define TK_IMPORT   40
#define TK_PLUS_EQ  41 // +=
#define TK_MINUS_EQ 42 // -=
#define TK_MUL_EQ   43 // *=
#define TK_DIV_EQ   44 // /=

#define MAX_VAL    256

class CToken {
  I64 type;
  U8 val[MAX_VAL];
};

class CLexer {
  U8 *src;
  I64 pos;
  CToken cur;
};

I64 IsDigitCh(U8 c) {
  return c >= '0' && c <= '9';
}

I64 IsAlphaCh(U8 c) {
  return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z');
}

I64 IsAlphaNumericCh(U8 c) {
  return IsAlphaCh(c) || IsDigitCh(c);
}

U0 NextToken(CLexer *lex) {
  I64 idx;
  I64 skipping;
  I64 isflt;

  skipping = 1;
  while (skipping) {
    skipping = 0;

    while (lex->src[lex->pos] == ' ' || lex->src[lex->pos] == '\t' ||
           lex->src[lex->pos] == '\r' || lex->src[lex->pos] == '\n') {
      lex->pos++;
    }

    if (lex->src[lex->pos] == '/' && lex->src[lex->pos + 1] == '/') {
      while (lex->src[lex->pos] != 0 && lex->src[lex->pos] != '\n') lex->pos++;
      skipping = 1;
    }
    else if (lex->src[lex->pos] == '/' && lex->src[lex->pos + 1] == '*') {
      lex->pos += 2;
      while (lex->src[lex->pos] != 0 &&
             !(lex->src[lex->pos] == '*' && lex->src[lex->pos + 1] == '/')) {
        lex->pos++;
      }
      if (lex->src[lex->pos] != 0) lex->pos += 2;
      skipping = 1;
    }
  }

  U8 c = lex->src[lex->pos];
  if (c == 0) { lex->cur.type = TK_EOF; return; }

  // Multi-character operators
  if (c == '=' && lex->src[lex->pos + 1] == '=') {
    lex->cur.type = TK_EQ; lex->pos += 2; return;
  }
  if (c == '>' && lex->src[lex->pos + 1] == '=') {
    lex->cur.type = TK_GTE; lex->pos += 2; return;
  }
  if (c == '<' && lex->src[lex->pos + 1] == '=') {
    lex->cur.type = TK_LTE; lex->pos += 2; return;
  }
  if (c == '!' && lex->src[lex->pos + 1] == '=') {
    lex->cur.type = TK_NE; lex->pos += 2; return;
  }
  if (c == '&' && lex->src[lex->pos + 1] == '&') {
    lex->cur.type = TK_AND; lex->pos += 2; return;
  }
  if (c == '|' && lex->src[lex->pos + 1] == '|') {
    lex->cur.type = TK_OR; lex->pos += 2; return;
  }
  if (c == '+' && lex->src[lex->pos + 1] == '=') {
    lex->cur.type = TK_PLUS_EQ; lex->pos += 2; return;
  }
  if (c == '-' && lex->src[lex->pos + 1] == '=') {
    lex->cur.type = TK_MINUS_EQ; lex->pos += 2; return;
  }
  if (c == '*' && lex->src[lex->pos + 1] == '=') {
    lex->cur.type = TK_MUL_EQ; lex->pos += 2; return;
  }
  if (c == '/' && lex->src[lex->pos + 1] == '=') {
    lex->cur.type = TK_DIV_EQ; lex->pos += 2; return;
  }

  // Single-character punctuation & operators
  if (c == '=') { lex->cur.type = TK_ASSIGN; lex->pos++; return; }
  if (c == '+') { lex->cur.type = TK_PLUS;   lex->pos++; return; }
  if (c == '-') { lex->cur.type = TK_MINUS;  lex->pos++; return; }
  if (c == '*') { lex->cur.type = TK_MUL;    lex->pos++; return; }
  if (c == '/') { lex->cur.type = TK_DIV;    lex->pos++; return; }
  if (c == ';') { lex->cur.type = TK_SEMI;   lex->pos++; return; }
  if (c == '(') { lex->cur.type = TK_LPAREN; lex->pos++; return; }
  if (c == ')') { lex->cur.type = TK_RPAREN; lex->pos++; return; }
  if (c == '{') { lex->cur.type = TK_LBRACE; lex->pos++; return; }
  if (c == '}') { lex->cur.type = TK_RBRACE; lex->pos++; return; }
  if (c == ',') { lex->cur.type = TK_COMMA;  lex->pos++; return; }
  if (c == '.') { lex->cur.type = TK_DOT;    lex->pos++; return; }
  if (c == '<') { lex->cur.type = TK_LT;     lex->pos++; return; }
  if (c == '>') { lex->cur.type = TK_GT;     lex->pos++; return; }
  if (c == '[') { lex->cur.type = TK_LBRACK; lex->pos++; return; }
  if (c == ']') { lex->cur.type = TK_RBRACK; lex->pos++; return; }
  if (c == '!') { lex->cur.type = TK_NOT;     lex->pos++; return; }

  // Numbers
  if (IsDigitCh(c)) {
    idx = 0;
    isflt = 0;
    while (IsDigitCh(lex->src[lex->pos]) && idx < MAX_VAL - 1) {
      lex->cur.val[idx++] = lex->src[lex->pos++];
    }
    if (lex->src[lex->pos] == '.' && IsDigitCh(lex->src[lex->pos + 1])) {
      isflt = 1;
      lex->cur.val[idx++] = lex->src[lex->pos++];
      while (IsDigitCh(lex->src[lex->pos]) && idx < MAX_VAL - 1) {
        lex->cur.val[idx++] = lex->src[lex->pos++];
      }
    }
    lex->cur.val[idx] = 0;
    if (isflt) lex->cur.type = TK_FNUM;
    else lex->cur.type = TK_NUM;
    return;
  }

  // Strings

  if (c == '"') {
    lex->pos++; // Skip opening quote
    idx = 0;
    while (lex->src[lex->pos] != '"' && lex->src[lex->pos] != 0 &&
           idx < MAX_VAL - 1) {
      lex->cur.val[idx++] = lex->src[lex->pos++];
    }
    lex->cur.val[idx] = 0;
    if (lex->src[lex->pos] == '"') lex->pos++; // Skip closing quote
    lex->cur.type = TK_STR;
    return;
  }

  // Identifiers / Keywords
  if (IsAlphaCh(c) || c == '_') {
    idx = 0;
    while ((IsAlphaNumericCh(lex->src[lex->pos]) || lex->src[lex->pos] == '_') &&
           idx < MAX_VAL - 1) {
      lex->cur.val[idx++] = lex->src[lex->pos++];
    }
    lex->cur.val[idx] = 0;

    if (!StrCmp(lex->cur.val, "var"))    lex->cur.type = TK_VAR;
    else if (!StrCmp(lex->cur.val, "print"))  lex->cur.type = TK_PRINT;
    else if (!StrCmp(lex->cur.val, "if"))     lex->cur.type = TK_IF;
    else if (!StrCmp(lex->cur.val, "else"))   lex->cur.type = TK_ELSE;
    else if (!StrCmp(lex->cur.val, "while"))  lex->cur.type = TK_WHILE;
    else if (!StrCmp(lex->cur.val, "class"))  lex->cur.type = TK_CLASS;
    else if (!StrCmp(lex->cur.val, "return")) lex->cur.type = TK_RETURN;
    else if (!StrCmp(lex->cur.val, "new"))    lex->cur.type = TK_NEW;
    else if (!StrCmp(lex->cur.val, "true"))   lex->cur.type = TK_TRUE;
    else if (!StrCmp(lex->cur.val, "false"))  lex->cur.type = TK_FALSE;
    else if (!StrCmp(lex->cur.val, "input"))  lex->cur.type = TK_INPUT;
    else if (!StrCmp(lex->cur.val, "for"))    lex->cur.type = TK_FOR;
    else if (!StrCmp(lex->cur.val, "import")) lex->cur.type = TK_IMPORT;
    else lex->cur.type = TK_IDENT;
    return;
  }

  lex->pos++; // Skip unknown
}

#define AST_VAR_DECL   1
#define AST_ASSIGN     2
#define AST_PRINT      3
#define AST_NUM        4
#define AST_IDENT      5
#define AST_BINOP      6
#define AST_BLOCK      7
#define AST_IF         8
#define AST_WHILE      9
#define AST_FUNC      10
#define AST_RETURN    11
#define AST_CALL      12
#define AST_CLASS     13
#define AST_NEW       14
#define AST_MEMBER    15
#define AST_BOOL  16
#define AST_UNOP  17
#define AST_STR   18
#define AST_INPUT 19
#define AST_EXPRSTMT 20
#define AST_FNUM     21
#define AST_INDEX    22
#define AST_SETIDX   23
#define AST_FOR      24

class CASTNode {
  I64 type;
  U8 val[MAX_VAL];
  I64 op;
  CASTNode *left;
  CASTNode *right;
  CASTNode *body;
  CASTNode *else_block;
  CASTNode *next;
};

CASTNode *NewNode(I64 type) {
  CASTNode *node = CAlloc(sizeof(CASTNode));
  node->type = type;
  return node;
}
extern CASTNode *ParseExpr(CLexer *lex);
extern CASTNode *ParseStatement(CLexer *lex);
extern CASTNode *ParseBlock(CLexer *lex);

CASTNode *ParseCallArgs(CLexer *lex, U8 *name) {
  CASTNode *node;
  CASTNode *arg;

  node = NewNode(AST_CALL);
  StrCpy(node->val, name);
  NextToken(lex);
  if (lex->cur.type != TK_RPAREN) {
    arg = ParseExpr(lex);
    node->left = arg;
    while (lex->cur.type == TK_COMMA && arg) {
      NextToken(lex);
      arg->next = ParseExpr(lex);
      arg = arg->next;
    }
  }
  if (lex->cur.type == TK_RPAREN) NextToken(lex);
  return node;
}

CASTNode *ParsePrimary(CLexer *lex) {
  CASTNode *node = NULL;
  CASTNode *idxnode;
  U8 fname[128];
  U8 mname[200];

  if (lex->cur.type == TK_TRUE) {
    node = NewNode(AST_BOOL);
    StrCpy(node->val, "TRUE");
    NextToken(lex);
  } else if (lex->cur.type == TK_FALSE) {
    node = NewNode(AST_BOOL);
    StrCpy(node->val, "FALSE");
    NextToken(lex);
  } else if (lex->cur.type == TK_STR) {
    node = NewNode(AST_STR);
    StrCpy(node->val, lex->cur.val);
    NextToken(lex);
  } else if (lex->cur.type == TK_INPUT) {
    NextToken(lex);
    node = NewNode(AST_INPUT);
    if (lex->cur.type == TK_LPAREN) NextToken(lex);
    if (lex->cur.type == TK_RPAREN) NextToken(lex);
  } else if (lex->cur.type == TK_NOT) {
    NextToken(lex);
    node = NewNode(AST_UNOP);
    node->op = TK_NOT;
    node->left = ParsePrimary(lex);
  } else if (lex->cur.type == TK_MINUS) {
    NextToken(lex);
    node = NewNode(AST_UNOP);
    node->op = TK_MINUS;
    node->left = ParsePrimary(lex);
  } else if (lex->cur.type == TK_NUM) {
    node = NewNode(AST_NUM);
    StrCpy(node->val, lex->cur.val);
    NextToken(lex);
  } else if (lex->cur.type == TK_FNUM) {
    node = NewNode(AST_FNUM);
    StrCpy(node->val, lex->cur.val);
    NextToken(lex);
  } else if (lex->cur.type == TK_NEW) {
    NextToken(lex);
    node = NewNode(AST_NEW);
    StrCpy(node->val, lex->cur.val);
    NextToken(lex);
    if (lex->cur.type == TK_LPAREN) { NextToken(lex); NextToken(lex); } // Skip ()
  } else if (lex->cur.type == TK_IDENT) {
    U8 name[64];
    StrCpy(name, lex->cur.val);
    NextToken(lex);

    if (lex->cur.type == TK_LPAREN) {
      node = ParseCallArgs(lex, name);
    }
    else if (lex->cur.type == TK_DOT) {
      NextToken(lex);
      StrCpy(fname, lex->cur.val);
      NextToken(lex);
      if (lex->cur.type == TK_LPAREN) {
        StrCpy(mname, name);
        CatPrint(mname, "_%s", fname);
        node = ParseCallArgs(lex, mname);
      } else {
        node = NewNode(AST_MEMBER);
        StrCpy(node->val, name);
        node->left = NewNode(AST_IDENT);
        StrCpy(node->left->val, fname);
      }
    } 
    else {
      node = NewNode(AST_IDENT);
      StrCpy(node->val, name);
    }
  } else if (lex->cur.type == TK_LPAREN) {
    NextToken(lex);
    node = ParseExpr(lex);
    if (lex->cur.type == TK_RPAREN) NextToken(lex);
  }

  while (node && lex->cur.type == TK_LBRACK) {
    NextToken(lex);
    idxnode = NewNode(AST_INDEX);
    idxnode->left = node;
    idxnode->right = ParseExpr(lex);
    if (lex->cur.type == TK_RBRACK) NextToken(lex);
    node = idxnode;
  }
  return node;
}

CASTNode *MakeBinOp(I64 op, CASTNode *l, CASTNode *r) {
  CASTNode *n = NewNode(AST_BINOP);
  n->op = op;
  n->left = l;
  n->right = r;
  return n;
}

CASTNode *ParseMul(CLexer *lex) {
  CASTNode *left;
  I64 op;
  left = ParsePrimary(lex);
  while (lex->cur.type == TK_MUL || lex->cur.type == TK_DIV) {
    op = lex->cur.type;
    NextToken(lex);
    left = MakeBinOp(op, left, ParsePrimary(lex));
  }
  return left;
}

CASTNode *ParseAdd(CLexer *lex) {
  CASTNode *left;
  I64 op;
  left = ParseMul(lex);
  while (lex->cur.type == TK_PLUS || lex->cur.type == TK_MINUS) {
    op = lex->cur.type;
    NextToken(lex);
    left = MakeBinOp(op, left, ParseMul(lex));
  }
  return left;
}

CASTNode *ParseCmp(CLexer *lex) {
  CASTNode *left;
  I64 op;
  left = ParseAdd(lex);
  while (lex->cur.type == TK_LT || lex->cur.type == TK_GT ||
         lex->cur.type == TK_LTE || lex->cur.type == TK_GTE) {
    op = lex->cur.type;
    NextToken(lex);
    left = MakeBinOp(op, left, ParseAdd(lex));
  }
  return left;
}

CASTNode *ParseEquality(CLexer *lex) {
  CASTNode *left;
  I64 op;
  left = ParseCmp(lex);
  while (lex->cur.type == TK_EQ || lex->cur.type == TK_NE) {
    op = lex->cur.type;
    NextToken(lex);
    left = MakeBinOp(op, left, ParseCmp(lex));
  }
  return left;
}

CASTNode *ParseAnd(CLexer *lex) {
  CASTNode *left;
  left = ParseEquality(lex);
  while (lex->cur.type == TK_AND) {
    NextToken(lex);
    left = MakeBinOp(TK_AND, left, ParseEquality(lex));
  }
  return left;
}

CASTNode *ParseExpr(CLexer *lex) {
  CASTNode *left;
  left = ParseAnd(lex);
  while (lex->cur.type == TK_OR) {
    NextToken(lex);
    left = MakeBinOp(TK_OR, left, ParseAnd(lex));
  }
  return left;
}

CASTNode *ParseBlock(CLexer *lex) {
  CASTNode *block = NewNode(AST_BLOCK);
  CASTNode head;
  CASTNode *cur;
  CASTNode *stmt;
  I64 before;

  head.next = NULL;
  cur = &head;

  if (lex->cur.type == TK_LBRACE) NextToken(lex);
  while (lex->cur.type != TK_RBRACE && lex->cur.type != TK_EOF) {
    before = lex->pos;
    stmt = ParseStatement(lex);
    if (stmt) {
      cur->next = stmt;
      while (cur->next) cur = cur->next;
    }
    else if (lex->pos == before) NextToken(lex);
  }
  if (lex->cur.type == TK_RBRACE) NextToken(lex);

  block->body = head.next;
  return block;
}

I64 CompoundOp(I64 tk) {
  if (tk == TK_PLUS_EQ)  return TK_PLUS;
  if (tk == TK_MINUS_EQ) return TK_MINUS;
  if (tk == TK_MUL_EQ)   return TK_MUL;
  if (tk == TK_DIV_EQ)   return TK_DIV;
  return 0;
}

CASTNode *CopyLValue(CASTNode *n) {
  CASTNode *c;
  if (!n) return NULL;
  c = NewNode(n->type);
  StrCpy(c->val, n->val);
  c->op = n->op;
  c->left = CopyLValue(n->left);
  c->right = CopyLValue(n->right);
  return c;
}

CASTNode *ParseStatement(CLexer *lex) {
  CASTNode *stmt = NULL;
  CASTNode *elseblk;
  U8 callname[200];
  I64 cop;
  CASTNode *base;
  CASTNode *idxn;
  CASTNode *init;
  CASTNode *loop;
  CASTNode *step;
  CASTNode *tail;

  if (lex->cur.type == TK_VAR) {
    NextToken(lex);
    stmt = NewNode(AST_VAR_DECL);
    StrCpy(stmt->val, lex->cur.val);
    NextToken(lex);
    if (lex->cur.type == TK_ASSIGN) {
      NextToken(lex);
      stmt->left = ParseExpr(lex);
    }
    if (lex->cur.type == TK_SEMI) NextToken(lex);
  } 
  else if (lex->cur.type == TK_IF) {
    NextToken(lex);
    stmt = NewNode(AST_IF);
    if (lex->cur.type == TK_LPAREN) NextToken(lex);
    stmt->left = ParseExpr(lex);
    if (lex->cur.type == TK_RPAREN) NextToken(lex);
    stmt->body = ParseBlock(lex);
    if (lex->cur.type == TK_ELSE) {
      NextToken(lex);
      if (lex->cur.type == TK_IF) {
        elseblk = NewNode(AST_BLOCK);
        elseblk->body = ParseStatement(lex);
        stmt->else_block = elseblk;
      } else {
        stmt->else_block = ParseBlock(lex);
      }
    }
  }
  else if (lex->cur.type == TK_FOR) {
    NextToken(lex);
    if (lex->cur.type == TK_LPAREN) NextToken(lex);
    init = ParseStatement(lex);
    loop = NewNode(AST_WHILE);
    loop->left = ParseExpr(lex);
    if (lex->cur.type == TK_SEMI) NextToken(lex);
    step = ParseStatement(lex);
    if (lex->cur.type == TK_RPAREN) NextToken(lex);
    loop->body = ParseBlock(lex);
    if (step) {
      if (!loop->body->body) {
        loop->body->body = step;
      } else {
        tail = loop->body->body;
        while (tail->next) tail = tail->next;
        tail->next = step;
      }
    }
    if (init) {
      init->next = loop;
      stmt = init;
    } else {
      stmt = loop;
    }
  }
  else if (lex->cur.type == TK_WHILE) {
    NextToken(lex);
    stmt = NewNode(AST_WHILE);
    if (lex->cur.type == TK_LPAREN) NextToken(lex);
    stmt->left = ParseExpr(lex);
    if (lex->cur.type == TK_RPAREN) NextToken(lex);
    stmt->body = ParseBlock(lex);
  }
  else if (lex->cur.type == TK_RETURN) {
    NextToken(lex);
    stmt = NewNode(AST_RETURN);
    stmt->left = ParseExpr(lex);
    if (lex->cur.type == TK_SEMI) NextToken(lex);
  }
  else if (lex->cur.type == TK_PRINT) {
    NextToken(lex);
    if (lex->cur.type == TK_LPAREN) NextToken(lex);
    stmt = NewNode(AST_PRINT);
    stmt->left = ParseExpr(lex);
    if (lex->cur.type == TK_RPAREN) NextToken(lex);
    if (lex->cur.type == TK_SEMI) NextToken(lex);
  }
  else if (lex->cur.type == TK_IDENT) {
    U8 name[64];
    StrCpy(name, lex->cur.val);
    NextToken(lex);

    if (lex->cur.type == TK_LBRACK) {
      base = NewNode(AST_IDENT);
      StrCpy(base->val, name);
      while (lex->cur.type == TK_LBRACK) {
        NextToken(lex);
        idxn = NewNode(AST_INDEX);
        idxn->left = base;
        idxn->right = ParseExpr(lex);
        if (lex->cur.type == TK_RBRACK) NextToken(lex);
        base = idxn;
      }
      if (lex->cur.type == TK_ASSIGN) {
        NextToken(lex);
        stmt = NewNode(AST_SETIDX);
        stmt->left = base;
        stmt->right = ParseExpr(lex);
      } else if (CompoundOp(lex->cur.type)) {
        cop = CompoundOp(lex->cur.type);
        NextToken(lex);
        stmt = NewNode(AST_SETIDX);
        stmt->left = base;
        stmt->right = MakeBinOp(cop, CopyLValue(base), ParseExpr(lex));
      } else {
        stmt = NewNode(AST_EXPRSTMT);
        stmt->left = base;
      }
    } else if (lex->cur.type == TK_LPAREN) {
      stmt = NewNode(AST_EXPRSTMT);
      stmt->left = ParseCallArgs(lex, name);
    } else if (lex->cur.type == TK_ASSIGN) {
      NextToken(lex);
      stmt = NewNode(AST_ASSIGN);
      StrCpy(stmt->val, name);
      stmt->left = ParseExpr(lex);
    } else if (CompoundOp(lex->cur.type)) {
      cop = CompoundOp(lex->cur.type);
      NextToken(lex);
      stmt = NewNode(AST_ASSIGN);
      StrCpy(stmt->val, name);
      base = NewNode(AST_IDENT);
      StrCpy(base->val, name);
      stmt->left = MakeBinOp(cop, base, ParseExpr(lex));
    } else if (lex->cur.type == TK_DOT) {
      NextToken(lex);
      U8 field[64];
      StrCpy(field, lex->cur.val);
      NextToken(lex);
      if (lex->cur.type == TK_LPAREN) {
        StrCpy(callname, name);
        CatPrint(callname, "_%s", field);
        stmt = NewNode(AST_EXPRSTMT);
        stmt->left = ParseCallArgs(lex, callname);
      } else if (lex->cur.type == TK_ASSIGN) {
        NextToken(lex);
        stmt = NewNode(AST_SETIDX);
        base = NewNode(AST_MEMBER);
        StrCpy(base->val, name);
        base->left = NewNode(AST_IDENT);
        StrCpy(base->left->val, field);
        stmt->left = base;
        stmt->right = ParseExpr(lex);
      } else if (CompoundOp(lex->cur.type)) {
        cop = CompoundOp(lex->cur.type);
        NextToken(lex);
        stmt = NewNode(AST_SETIDX);
        base = NewNode(AST_MEMBER);
        StrCpy(base->val, name);
        base->left = NewNode(AST_IDENT);
        StrCpy(base->left->val, field);
        stmt->left = base;
        stmt->right = MakeBinOp(cop, CopyLValue(base), ParseExpr(lex));
      }
    }
    if (lex->cur.type == TK_SEMI) NextToken(lex);
  }

  return stmt;
}

#define IMP_MAX 64

class CImp {
  U8 name[128];
};

CImp imp_tab[IMP_MAX];
I64 imp_cnt = 0;

I64 ImpSeen(U8 *name) {
  I64 i;
  for (i = 0; i < imp_cnt; i++) {
    if (!StrCmp(imp_tab[i].name, name)) return 1;
  }
  return 0;
}

U0 ImpMark(U8 *name) {
  if (imp_cnt >= IMP_MAX) return;
  StrCpy(imp_tab[imp_cnt].name, name);
  imp_cnt++;
}

extern CASTNode *ParseTopLevel(CLexer *lex);

CASTNode *ParseModule(U8 *name) {
  U8 fname[256];
  U8 *buf;
  CLexer sub;
  CASTNode *ast;
  CASTNode *n;
  CASTNode head;
  CASTNode *tail;

  StrCpy(fname, name);
  if (!StrLastOcc(fname, ".")) CatPrint(fname, ".eeev");

  buf = FileRead(fname);
  if (!buf) {
    "eeevil: cannot import %s\n", fname;
    return NULL;
  }

  sub.src = buf;
  sub.pos = 0;
  NextToken(&sub);
  ast = ParseTopLevel(&sub);

  head.next = NULL;
  tail = &head;
  n = ast;
  while (n) {
    if (!(n->type == AST_FUNC && !StrCmp(n->val, "Main"))) {
      tail->next = n;
      tail = n;
    }
    n = n->next;
  }
  tail->next = NULL;

  Free(buf);
  return head.next;
}

CASTNode *ParseClassBody(CLexer *lex, U8 *cls) {
  CASTNode head;
  CASTNode *cur;
  CASTNode *m;
  CASTNode phead;
  CASTNode *pcur;
  CASTNode *p;
  U8 mname[200];
  I64 before;

  head.next = NULL;
  cur = &head;

  if (lex->cur.type == TK_LBRACE) NextToken(lex);
  while (lex->cur.type != TK_RBRACE && lex->cur.type != TK_EOF) {
    before = lex->pos;

    if (lex->cur.type == TK_VAR) {
      m = ParseStatement(lex);
      if (m) {
        cur->next = m;
        while (cur->next) cur = cur->next;
      }
    } else if (lex->cur.type == TK_IDENT) {
      StrCpy(mname, cls);
      CatPrint(mname, "_%s", lex->cur.val);
      NextToken(lex);
      if (lex->cur.type == TK_LPAREN) {
        NextToken(lex);
        m = NewNode(AST_FUNC);
        StrCpy(m->val, mname);
        phead.next = NULL;
        pcur = &phead;
        while (lex->cur.type == TK_IDENT) {
          p = NewNode(AST_IDENT);
          StrCpy(p->val, lex->cur.val);
          pcur->next = p;
          pcur = p;
          NextToken(lex);
          if (lex->cur.type == TK_COMMA) NextToken(lex);
        }
        if (lex->cur.type == TK_RPAREN) NextToken(lex);
        m->left = phead.next;
        m->body = ParseBlock(lex);
        cur->next = m;
        cur = m;
      }
    } else {
      NextToken(lex);
    }

    if (lex->pos == before) NextToken(lex);
  }
  if (lex->cur.type == TK_RBRACE) NextToken(lex);
  return head.next;
}

CASTNode *ParseTopLevel(CLexer *lex) {
  CASTNode head;
  head.next = NULL;
  CASTNode *cur = &head;
  CASTNode *imported;
  CASTNode *members;
  CASTNode *mem;
  CASTNode *nxt;
  CASTNode *blk;
  CASTNode fhead;
  CASTNode *ftail;
  CASTNode mhead;
  CASTNode *mtail;
  U8 modname[128];

  while (lex->cur.type != TK_EOF) {
    if (lex->cur.type == TK_IMPORT) {
      NextToken(lex);
      StrCpy(modname, lex->cur.val);
      NextToken(lex);
      if (lex->cur.type == TK_SEMI) NextToken(lex);
      if (!ImpSeen(modname)) {
        ImpMark(modname);
        imported = ParseModule(modname);
        if (imported) {
          cur->next = imported;
          while (cur->next) cur = cur->next;
        }
      }
    } else if (lex->cur.type == TK_CLASS) {
      NextToken(lex);
      CASTNode *cls = NewNode(AST_CLASS);
      StrCpy(cls->val, lex->cur.val);
      NextToken(lex);
      members = ParseClassBody(lex, cls->val);

      fhead.next = NULL;
      ftail = &fhead;
      mhead.next = NULL;
      mtail = &mhead;
      mem = members;
      while (mem) {
        nxt = mem->next;
        mem->next = NULL;
        if (mem->type == AST_FUNC) {
          mtail->next = mem;
          mtail = mem;
        } else {
          ftail->next = mem;
          ftail = mem;
        }
        mem = nxt;
      }

      blk = NewNode(AST_BLOCK);
      blk->body = fhead.next;
      cls->body = blk;
      cur->next = cls;
      cur = cls;
      if (mhead.next) {
        cur->next = mhead.next;
        while (cur->next) cur = cur->next;
      }
    } else if (lex->cur.type == TK_IDENT) {
      // Function declaration: Add(x, y) { ... }
      CASTNode *fn = NewNode(AST_FUNC);
      StrCpy(fn->val, lex->cur.val);
      NextToken(lex);
      if (lex->cur.type == TK_LPAREN) NextToken(lex);
      
      // Parse parameters
      CASTNode phead; phead.next = NULL;
      CASTNode *pcur = &phead;
      while (lex->cur.type == TK_IDENT) {
        CASTNode *p = NewNode(AST_IDENT);
        StrCpy(p->val, lex->cur.val);
        pcur->next = p;
        pcur = p;
        NextToken(lex);
        if (lex->cur.type == TK_COMMA) NextToken(lex);
      }
      if (lex->cur.type == TK_RPAREN) NextToken(lex);
      
      fn->left = phead.next;
      fn->body = ParseBlock(lex);
      cur->next = fn;
      cur = fn;
    } else {
      NextToken(lex);
    }
  }
  return head.next;
}

extern U0 EmitExpr(CASTNode *node, U8 *out);
extern U0 EmitIdx(CASTNode *node, U8 *out);
extern U0 EmitStatements(CASTNode *stmt, U8 *out, I64 indent);

U0 EmitIndent(U8 *out, I64 indent) {
  I64 i;
  for (i = 0; i < indent; i++) CatPrint(out, "  ");
}

#define K_I64 0
#define K_F64 1
#define K_ARR 2
#define K_CLS 3

#define SYM_MAX 512
#define FLD_MAX 512

class CSym {
  U8 name[64];
  I64 kind;
  U8 cls[64];
};

class CFld {
  U8 name[64];
  U8 cls[64];
  I64 idx;
};

CSym sym_tab[SYM_MAX];
I64 sym_cnt = 0;
CFld fld_tab[FLD_MAX];
I64 fld_cnt = 0;

U0 SymReset() {
  sym_cnt = 0;
}

U0 SymAdd(U8 *name, I64 kind, U8 *cls) {
  if (sym_cnt >= SYM_MAX) return;
  StrCpy(sym_tab[sym_cnt].name, name);
  sym_tab[sym_cnt].kind = kind;
  if (cls) StrCpy(sym_tab[sym_cnt].cls, cls);
  else sym_tab[sym_cnt].cls[0] = 0;
  sym_cnt++;
}

I64 SymKind(U8 *name) {
  I64 i;
  for (i = 0; i < sym_cnt; i++) {
    if (!StrCmp(sym_tab[i].name, name)) return sym_tab[i].kind;
  }
  return K_I64;
}

U8 *SymClass(U8 *name) {
  I64 i;
  for (i = 0; i < sym_cnt; i++) {
    if (!StrCmp(sym_tab[i].name, name)) {
      if (sym_tab[i].cls[0]) return sym_tab[i].cls;
      return NULL;
    }
  }
  return NULL;
}

U0 FldAdd(U8 *name, U8 *cls, I64 idx) {
  if (fld_cnt >= FLD_MAX) return;
  StrCpy(fld_tab[fld_cnt].name, name);
  StrCpy(fld_tab[fld_cnt].cls, cls);
  fld_tab[fld_cnt].idx = idx;
  fld_cnt++;
}

I64 FldIndex(U8 *cls, U8 *name) {
  I64 i;
  if (cls) {
    for (i = 0; i < fld_cnt; i++) {
      if (!StrCmp(fld_tab[i].name, name) && !StrCmp(fld_tab[i].cls, cls)) {
        return fld_tab[i].idx;
      }
    }
  }
  for (i = 0; i < fld_cnt; i++) {
    if (!StrCmp(fld_tab[i].name, name)) return fld_tab[i].idx;
  }
  return 0;
}

I64 ClsFieldCnt(U8 *cls) {
  I64 i;
  I64 n = 0;
  for (i = 0; i < fld_cnt; i++) {
    if (!StrCmp(fld_tab[i].cls, cls)) n++;
  }
  if (n < 1) n = 1;
  return n;
}

I64 ExprKind(CASTNode *n) {
  if (!n) return K_I64;
  if (n->type == AST_FNUM) return K_F64;
  if (n->type == AST_INDEX) return K_F64;
  if (n->type == AST_NEW) return K_F64;
  if (n->type == AST_MEMBER) return K_F64;
  if (n->type == AST_IDENT) return SymKind(n->val);
  if (n->type == AST_CALL) return K_F64;
  if (n->type == AST_UNOP) {
    if (n->op == TK_MINUS) return ExprKind(n->left);
    return K_I64;
  }
  if (n->type == AST_BINOP) {
    if (n->op == TK_EQ || n->op == TK_NE || n->op == TK_LT ||
        n->op == TK_GT || n->op == TK_LTE || n->op == TK_GTE ||
        n->op == TK_AND || n->op == TK_OR) return K_I64;
    if (ExprKind(n->left) == K_F64) return K_F64;
    if (ExprKind(n->right) == K_F64) return K_F64;
    return K_I64;
  }
  return K_I64;
}

#define BASE_MAX 128

class CBase {
  U8 name[64];
};

CBase base_tab[BASE_MAX];
I64 base_cnt = 0;

U0 BaseReset() {
  base_cnt = 0;
}

I64 IsBase(U8 *n) {
  I64 i;
  for (i = 0; i < base_cnt; i++) {
    if (!StrCmp(base_tab[i].name, n)) return 1;
  }
  return 0;
}

U0 BaseAdd(U8 *n) {
  if (base_cnt >= BASE_MAX) return;
  if (IsBase(n)) return;
  StrCpy(base_tab[base_cnt].name, n);
  base_cnt++;
}

U0 CollectBases(CASTNode *n) {
  while (n) {
    if (n->type == AST_MEMBER) BaseAdd(n->val);
    if (n->type == AST_INDEX) {
      if (n->left) {
        if (n->left->type == AST_IDENT) BaseAdd(n->left->val);
      }
    }
    CollectBases(n->left);
    CollectBases(n->right);
    CollectBases(n->body);
    CollectBases(n->else_block);
    n = n->next;
  }
}

U8 *BuiltinName(U8 *name) {
  if (!StrCmp(name, "netopen"))  return "EevNetOpen";
  if (!StrCmp(name, "netsend"))  return "EevNetSend";
  if (!StrCmp(name, "netrecv"))  return "EevNetRecv";
  if (!StrCmp(name, "netclose")) return "EevNetClose";
  if (!StrCmp(name, "httpget"))  return "EevHttpGet";
  if (!StrCmp(name, "prints"))   return "EevPrintS";
  if (!StrCmp(name, "abs"))      return "Abs";
  if (!StrCmp(name, "sqrt"))     return "Sqrt";
  if (!StrCmp(name, "exp"))      return "Exp";
  if (!StrCmp(name, "pow"))      return "Pow";
  if (!StrCmp(name, "ln"))       return "Ln";
  if (!StrCmp(name, "sin"))      return "Sin";
  if (!StrCmp(name, "cos"))      return "Cos";
  if (!StrCmp(name, "rand"))     return "Rand";
  if (!StrCmp(name, "free"))     return "Free";
  return name;
}

I64 UsesNet(CASTNode *n) {
  while (n) {
    if (n->type == AST_CALL) {
      if (!StrCmp(n->val, "netopen")  || !StrCmp(n->val, "netsend") ||
          !StrCmp(n->val, "netrecv")  || !StrCmp(n->val, "netclose") ||
          !StrCmp(n->val, "httpget")  || !StrCmp(n->val, "prints")) return 1;
    }
    if (UsesNet(n->left)) return 1;
    if (UsesNet(n->right)) return 1;
    if (UsesNet(n->body)) return 1;
    if (UsesNet(n->else_block)) return 1;
    n = n->next;
  }
  return 0;
}

U0 EmitIdx(CASTNode *node, U8 *out) {
  if (ExprKind(node) == K_I64) {
    EmitExpr(node, out);
  } else {
    CatPrint(out, "ToI64(");
    EmitExpr(node, out);
    CatPrint(out, ")");
  }
}

U0 EmitExpr(CASTNode *node, U8 *out) {
  CASTNode *arg;
  U8 *cls;
  if (!node) return;

  if (node->type == AST_BOOL) {
    CatPrint(out, "%s", node->val); // Emits TRUE or FALSE
  } else if (node->type == AST_STR) {
    CatPrint(out, "\"%s\"", node->val);
  } else if (node->type == AST_INPUT) {
    CatPrint(out, "GetI64(\"> \", 0)");
  } else if (node->type == AST_UNOP) {
    CatPrint(out, "(");
    if (node->op == TK_NOT)   CatPrint(out, "!");
    if (node->op == TK_MINUS) CatPrint(out, "-");
    EmitExpr(node->left, out);
    CatPrint(out, ")");
  } else if (node->type == AST_NUM || node->type == AST_IDENT) {
    CatPrint(out, "%s", node->val);
  } else if (node->type == AST_FNUM) {
    CatPrint(out, "%s", node->val);
  } else if (node->type == AST_INDEX) {
    if (node->left->type == AST_IDENT && IsBase(node->left->val)) {
      CatPrint(out, "_p_%s[", node->left->val);
      EmitIdx(node->right, out);
      CatPrint(out, "]");
    } else {
      CatPrint(out, "EevGet(");
      EmitExpr(node->left, out);
      CatPrint(out, ", ");
      EmitExpr(node->right, out);
      CatPrint(out, ")");
    }
  } else if (node->type == AST_MEMBER) {
    cls = SymClass(node->val);
    if (IsBase(node->val)) {
      CatPrint(out, "_p_%s[%d]", node->val, FldIndex(cls, node->left->val));
    } else {
      CatPrint(out, "EevGet(%s, %d)", node->val,
               FldIndex(cls, node->left->val));
    }
  } else if (node->type == AST_NEW) {
    CatPrint(out, "EevAlloc(%d)", ClsFieldCnt(node->val));
  } else if (node->type == AST_CALL) {
    if (!StrCmp(node->val, "alloc")) {
      CatPrint(out, "EevAlloc(");
      EmitExpr(node->left, out);
      CatPrint(out, ")");
    } else {
      CatPrint(out, "%s(", BuiltinName(node->val));
      arg = node->left;
      while (arg) {
        EmitExpr(arg, out);
        if (arg->next) CatPrint(out, ", ");
        arg = arg->next;
      }
      CatPrint(out, ")");
    }
  } else if (node->type == AST_BINOP) {
    CatPrint(out, "(");
    EmitExpr(node->left, out);

    // Arithmetic
    if (node->op == TK_PLUS)  CatPrint(out, " + ");
    if (node->op == TK_MINUS) CatPrint(out, " - ");
    if (node->op == TK_MUL)   CatPrint(out, " * ");
    if (node->op == TK_DIV)   CatPrint(out, " / ");

    // Comparison
    if (node->op == TK_EQ)    CatPrint(out, " == ");
    if (node->op == TK_NE)    CatPrint(out, " != ");
    if (node->op == TK_LT)    CatPrint(out, " < ");
    if (node->op == TK_GT)    CatPrint(out, " > ");
    if (node->op == TK_LTE)   CatPrint(out, " <= ");
    if (node->op == TK_GTE)   CatPrint(out, " >= ");

    // Logical
    if (node->op == TK_AND)   CatPrint(out, " && ");
    if (node->op == TK_OR)    CatPrint(out, " || ");

    EmitExpr(node->right, out);
    CatPrint(out, ")");
  }
}

U0 EmitStatements(CASTNode *stmt, U8 *out, I64 indent) {
  I64 kind;
  while (stmt) {
    if (stmt->type == AST_VAR_DECL) {
      EmitIndent(out, indent);
      kind = ExprKind(stmt->left);
      if (stmt->left && stmt->left->type == AST_NEW) {
        SymAdd(stmt->val, K_F64, stmt->left->val);
        CatPrint(out, "F64 %s = ", stmt->val);
      } else if (kind == K_F64) {
        SymAdd(stmt->val, K_F64, NULL);
        CatPrint(out, "F64 %s = ", stmt->val);
      } else {
        SymAdd(stmt->val, K_I64, NULL);
        CatPrint(out, "I64 %s = ", stmt->val);
      }
      if (stmt->left) EmitExpr(stmt->left, out);
      else CatPrint(out, "0");
      CatPrint(out, ";\n");
      if (IsBase(stmt->val)) {
        EmitIndent(out, indent);
        CatPrint(out, "_p_%s = ToI64(%s);\n", stmt->val, stmt->val);
      }
    } else if (stmt->type == AST_SETIDX) {
      EmitIndent(out, indent);
      if (stmt->left->type == AST_MEMBER && IsBase(stmt->left->val)) {
        CatPrint(out, "_p_%s[%d] = ", stmt->left->val,
                 FldIndex(SymClass(stmt->left->val), stmt->left->left->val));
        EmitExpr(stmt->right, out);
        CatPrint(out, ";
");
      } else if (stmt->left->type == AST_INDEX &&
                 stmt->left->left->type == AST_IDENT &&
                 IsBase(stmt->left->left->val)) {
        CatPrint(out, "_p_%s[", stmt->left->left->val);
        EmitIdx(stmt->left->right, out);
        CatPrint(out, "] = ");
        EmitExpr(stmt->right, out);
        CatPrint(out, ";
");
      } else {
        CatPrint(out, "EevSet(");
        if (stmt->left->type == AST_MEMBER) {
          CatPrint(out, "%s, %d", stmt->left->val,
                   FldIndex(SymClass(stmt->left->val), stmt->left->left->val));
        } else {
          EmitExpr(stmt->left->left, out);
          CatPrint(out, ", ");
          EmitExpr(stmt->left->right, out);
        }
        CatPrint(out, ", ");
        EmitExpr(stmt->right, out);
        CatPrint(out, ");
");
      }
    } else if (stmt->type == AST_ASSIGN) {
      EmitIndent(out, indent);
      CatPrint(out, "%s = ", stmt->val);
      EmitExpr(stmt->left, out);
      CatPrint(out, ";\n");
      if (IsBase(stmt->val)) {
        EmitIndent(out, indent);
        CatPrint(out, "_p_%s = ToI64(%s);\n", stmt->val, stmt->val);
      }
    } else if (stmt->type == AST_PRINT) {
      EmitIndent(out, indent);
      if (stmt->left && stmt->left->type == AST_STR) {
        CatPrint(out, "\"%s\\n\";\n", stmt->left->val);
      } else if (ExprKind(stmt->left) == K_F64) {
        CatPrint(out, "\"%%f\\n\", ");
        EmitExpr(stmt->left, out);
        CatPrint(out, ";\n");
      } else {
        CatPrint(out, "\"%%d\\n\", ");
        EmitExpr(stmt->left, out);
        CatPrint(out, ";\n");
      }
    } else if (stmt->type == AST_EXPRSTMT) {
      EmitIndent(out, indent);
      if (stmt->left->type == AST_CALL && !StrCmp(stmt->left->val, "printi")) {
        CatPrint(out, "\"%%d\\n\", (I64)(");
        EmitExpr(stmt->left->left, out);
        CatPrint(out, ");\n");
      } else {
        EmitExpr(stmt->left, out);
        CatPrint(out, ";\n");
      }
    } else if (stmt->type == AST_RETURN) {
      EmitIndent(out, indent);
      CatPrint(out, "return ");
      EmitExpr(stmt->left, out);
      CatPrint(out, ";\n");
    } else if (stmt->type == AST_IF) {
      EmitIndent(out, indent);
      CatPrint(out, "if (");
      EmitExpr(stmt->left, out);
      CatPrint(out, ") {\n");
      EmitStatements(stmt->body->body, out, indent + 1);
      EmitIndent(out, indent);
      CatPrint(out, "}");
      if (stmt->else_block) {
        CatPrint(out, " else {\n");
        EmitStatements(stmt->else_block->body, out, indent + 1);
        EmitIndent(out, indent);
        CatPrint(out, "}");
      }
      CatPrint(out, "\n");
    } else if (stmt->type == AST_WHILE) {
      EmitIndent(out, indent);
      CatPrint(out, "while (");
      EmitExpr(stmt->left, out);
      CatPrint(out, ") {\n");
      EmitStatements(stmt->body->body, out, indent + 1);
      EmitIndent(out, indent);
      CatPrint(out, "}\n");
    }
    stmt = stmt->next;
  }
}

U0 EmitHolyC(CASTNode *ast, U8 *outFilename) {
  U8 *out = CAlloc(524288);
  CASTNode *cur;
  CASTNode *field;
  CASTNode *p;
  I64 slot;
  I64 bi;

  CatPrint(out, "// Generated HolyC Code\n\n");
  CatPrint(out, "#include \"eeevcore.hc\"\n");
  if (UsesNet(ast)) CatPrint(out, "#include \"eeevnet.hc\"\n");
  CatPrint(out, "\n");

  fld_cnt = 0;
  cur = ast;
  while (cur) {
    if (cur->type == AST_CLASS) {
      slot = 0;
      field = cur->body->body;
      while (field) {
        if (field->type == AST_VAR_DECL) {
          FldAdd(field->val, cur->val, slot);
          slot++;
        }
        field = field->next;
      }
    }
    cur = cur->next;
  }

  cur = ast;
  while (cur) {
    if (cur->type == AST_FUNC) {
      SymReset();
      BaseReset();
      CollectBases(cur->body->body);
      if (!StrCmp(cur->val, "Main")) {
        CatPrint(out, "U0 Main()\n{\n");
      } else {
        CatPrint(out, "F64 %s(", cur->val);
        p = cur->left;
        while (p) {
          CatPrint(out, "F64 %s", p->val);
          SymAdd(p->val, K_F64, NULL);
          if (p->next) CatPrint(out, ", ");
          p = p->next;
        }
        CatPrint(out, ")\n{\n");
      }
      for (bi = 0; bi < base_cnt; bi++) {
        CatPrint(out, "  F64 *_p_%s;\n", base_tab[bi].name);
      }
      p = cur->left;
      while (p) {
        if (IsBase(p->val)) {
          CatPrint(out, "  _p_%s = ToI64(%s);\n", p->val, p->val);
        }
        p = p->next;
      }
      EmitStatements(cur->body->body, out, 1);
      CatPrint(out, "}\n\n");
    }
    cur = cur->next;
  }

  CatPrint(out, "Main;\n");
  FileWrite(outFilename, out, StrLen(out));
  Free(out);
}

U0 CompileEEEV(U8 *inFilename) {
  U8 *buffer = FileRead(inFilename);
  if (!buffer) {
    "Error loading file: %s\n", inFilename;
    return;
  }

  CLexer lex;
  lex.src = buffer;
  lex.pos = 0;
  imp_cnt = 0;
  NextToken(&lex);

  CASTNode *ast = ParseTopLevel(&lex);

  U8 outFilename[128];
  U8 *ext;
  StrCpy(outFilename, inFilename);
  ext = StrLastOcc(outFilename, ".");
  if (ext) *ext = 0;
  CatPrint(outFilename, ".HC");

  EmitHolyC(ast, outFilename);
  Free(buffer);

  "Successfully compiled %s -> %s\n", inFilename, outFilename;
  ExeFile(outFilename);
}
