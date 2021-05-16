MODULE Test1 IN Oberon;
  IMPORT Texts, Oberon;
  VAR W: Texts.Writer;

  PROCEDURE Go1*;
  BEGIN Texts.WriteString(W, "Hello from module Test1 in context Oberon");
    Texts.WriteLn(W); Texts.Append(Oberon.Log, W.buf)
  END Go1;

BEGIN Texts.OpenWriter(W)
END Test1.
