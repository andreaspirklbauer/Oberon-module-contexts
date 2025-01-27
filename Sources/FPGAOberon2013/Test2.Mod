MODULE Test2 IN Oberon;
  IMPORT Texts, Oberon, Test1 IN Oberon;
  VAR W: Texts.Writer;

  PROCEDURE Go1*;
  BEGIN Texts.WriteString(W, "Calling procedure Test1.Go1 in context Oberon");
    Texts.WriteLn(W); Texts.Append(Oberon.Log, W.buf); Test1.Go1
  END Go1;

  PROCEDURE Go2*;
  BEGIN Texts.WriteString(W, "Hello from module Test2 in context Oberon");
    Texts.WriteLn(W); Texts.Append(Oberon.Log, W.buf)
  END Go2;

BEGIN Texts.OpenWriter(W)
END Test2.

ORP.Compile Test1.Mod/s ~
ORP.Compile Test2.Mod/s ~

Test1.Go1

Test2.Go1
Test2.Go2
