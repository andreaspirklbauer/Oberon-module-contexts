# Oberon-module-contexts
Module contexts for the Oberon-07 programming language and the Project Oberon 2013 and Extended Oberon systems. Module contexts are described in [**Documentation/ProposalForModuleContexts2008.pdf**](Documentation/ProposalForModuleContexts2008.pdf). See also
http://www.ocp.inf.ethz.ch/wiki/Documentation/Language?action=download&upname=contexts.pdf.

Note: In this repository, the term "Project Oberon 2013" refers to a re-implementation of the original "Project Oberon" on an FPGA development board around 2013, as published at www.projectoberon.com.

**PREREQUISITES**: A current version of Project Oberon 2013 (see http://www.projectoberon.com) or Extended Oberon (see http://github.com/andreaspirklbauer/Oberon-extended).

------------------------------------------------------
**1. About module contexts**

1. Module contexts are specified within the *source text* of a module, as an optional feature. If a context is specified, the name of the source file itself typically (but not necessarily) contains a prefix indicating its module context, for example *Oberon.Texts.Mod* or "EO.Texts.Mod*.
2. If a module context is specified within the source text of a module, the compiler generates the output files *contextname.modulename.smb* and *contextname.modulename.rsc*, i.e. the module context is encoded in the symbol and object file names.
3. If no module context is specified within the source text of a module, the compiler generates the output files *modulename.smb* and *modulename.rsc*, i.e. no context is assumed.
4. On an Project Oberon 2013 system (http://www.projectoberon.com), the module context "Oberon" is implicitly specified at run time, i.e. the module loader first looks for *Oberon.modulename.rsc*, then for *modulename.rsc*.
5. On an Extended Oberon system (http://github.com/andreaspirklbauer/Oberon-extended), the module context "EO" is implicitly specified at run time, i.e. the module loader first looks for *EO.modulename.rsc*, then for *modulename.rsc*.
6. A module cannot be loaded under more than one context name on the same system.
7. A module belonging to a context can only import modules belonging to the same context or no context (implementation restriction).

------------------------------------------------------
**2. Preparing your system to use module contexts**

Convert the downloaded files to Oberon format (Oberon uses CR as line endings) using the command [**dos2oberon**](dos2oberon), also available in this repository (example shown for Mac or Linux):

     for x in *.Mod ; do ./dos2oberon $x $x ; done

Import the files to your Oberon system. If you use an emulator (e.g., **https://github.com/pdewacht/oberon-risc-emu**) to run the Oberon system, click on the *PCLink1.Run* link in the *System.Tool* viewer, copy the files to the emulator directory, and execute the following command on the command shell of your host system:

     cd oberon-risc-emu
     for x in *.Mod ; do ./pcreceive.sh $x ; sleep 1 ; done

Build a new Oberon inner core and load it onto the boot area of the local disk:

Project Oberon 2013:

     ORP.Compile Kernel.Mod/s FileDir.Mod/s Files.Mod/s Modules.Mod/s ~  # use the "old" compiler here!
     ORL.Link Modules ~
     ORL.Load Modules.bin ~

Extended Oberon:

     ORP.Compile Kernel.Mod/s Disk.Mod/s FileDir.Mod/s Files.Mod/s Modules.Mod/s ~  # use the "old" compiler here!
     ORL.Link Modules ~
     ORL.Load Modules.bin ~

Note that at present only the compiler, but not the boot linker uses module contexts. Thus, the *inner core* of the Oberon system must be compiled with the "old" compiler, before it is linked and loaded onto the boot area of the local disk.

**Restart the system NOW**

*Then* rebuild the Oberon compiler:

     ORP.Compile ORS.Mod/s ORB.Mod/s ~
     ORP.Compile ORG.Mod/s ORP.Mod/s ~
     ORP.Compile ORL.Mod/s ORTool.Mod/s ~
     System.Free ORTool ORP ORG ORB ORS ORL ~


------------------------------------------------------
**3. Testing module contexts on your system**

The test programs *Test1* and *Test2* are provided. The example below is for Project Oberon 2013 (context "Oberon").

**Test program 1 written in context "Oberon"**

     MODULE Test1 IN Oberon;
       IMPORT Texts, Oberon;
       VAR W: Texts.Writer;

       PROCEDURE Go1*;
       BEGIN Texts.WriteString(W, "Hello from module Test1 in context Oberon");
         Texts.WriteLn(W); Texts.Append(Oberon.Log, W.buf)
       END Go1;

     BEGIN Texts.OpenWriter(W)
     END Test1.

**Test program 2 imports test program 1 in context "Oberon"**

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

To build the test programs:

     ORP.Compile Test1.Mod/s ~
     ORP.Compile Test2.Mod/s ~
     System.Free Test2 Test1 ~

To execute the test programs:

     Test1.Go1

     Test2.Go1
     Test2.Go2

     System.Directory Oberon.Test*

The last command will display the generated object and symbol files for the test programs, namely:

     Oberon.Test1.rsc
     Oberon.Test1.smb
     Oberon.Test2.rsc
     Oberon.Test2.smb
