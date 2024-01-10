package single_cycle

import chisel3._
import chisel3.util._

class maintop extends Module {
  val io = IO(new Bundle {
      val out = Output (SInt(32.W))
      val insin = Input(UInt(32.W))
      val pcout = Output(UInt(32.W))

  })

  val fetch = Module (new Fetch)
  val decode = Module (new  Decode)
  val Execute = Module (new execute)
  val Memory = Module(new memory)
  val writeback = Module(new writeback)

  fetch.io.inst :=io.insin
  io.pcout:=0.U
  //fetch to decode
  val ifidins = Reg(UInt(32.W))
  ifidins:=fetch.io.instruction
  decode.io.in:=ifidins

  val ifidaddr = Reg(UInt(32.W))
  ifidaddr :=fetch.io.address_out
  decode.io.pco := ifidaddr

  val ifidpc4 = Reg(UInt(32.W))
  ifidpc4 :=fetch.io.pc4_out
  decode.io.pc4_in :=ifidpc4

  fetch.io.pcsel  := 0.B  

  decode.io.btake  := Execute.io.br_taken  
  
  decode.io.RD := Execute.io.out  

  
  
// decode to execute
//   val idiepc4o =  Reg(UInt(32.W))
  Execute.io.pc4out := decode.io.pc4out
//   Execute.io.pc4out :=idiepc4o
//   val idiepco = Reg(UInt(32.W))
  Execute.io.pcout := decode.io.pcout
//   Execute.io.pcout :=idiepco
//   val idieOpcd = Reg(UInt(7.W))
  Execute.io.Opcode :=  decode.io.Opcode
//   Execute.io.Opcode :=idieOpcd
//   val idiealuop = Reg(UInt(4.W))
  Execute.io.aluop := decode.io.aluop
//   Execute.io.aluop :=idiealuop
//   val idieif = Reg(Bool())
  Execute.io.iformat := decode.io.iformat
//   Execute.io.iformat := idieif

//   val idierf = Reg(Bool())
  Execute.io.rformat  := decode.io.rformat
//   Execute.io.rformat :=idierf

//   val idiesf = Reg(Bool())
   Execute.io.sformat := decode.io.sformat
//   Execute.io.sformat :=idiesf

//   val idiebf = Reg(Bool())
  Execute.io.bformat := decode.io.bformat
//   Execute.io.bformat :=idiebf

//   val idiejf = Reg(Bool())
  Execute.io.jalformate  := decode.io.jalformate
//   Execute.io.jalformate :=idiejf

  
//   val idieluf = Reg(Bool())
   Execute.io.luiformate := decode.io.luiformate
//   Execute.io.luiformate :=idieluf

//   val idieaup = Reg(Bool())
  Execute.io.Auipcformate := decode.io.Auipcformate
//   Execute.io.Auipcformate :=idieaup

//    val idiejrl = Reg(Bool())
  Execute.io.jalrformate := decode.io.jalrformate
//   Execute.io.jalrformate :=idiejrl

//   val idierd = Reg(UInt(5.W))
  Execute.io.rd := decode.io.rd
//   Execute.io.rd :=idierd

//   val idiefun3 = Reg(UInt(5.W))
   Execute.io.fun_3 := decode.io.fun_3
//   Execute.io.fun_3 :=idiefun3

//   val idiers1 = Reg(UInt(5.W))
  Execute.io.rs1  := decode.io.rs1
//   Execute.io.rs1 :=idiers1
  
//   val idiers2 = Reg(UInt(5.W))
  Execute.io.rs2 := decode.io.rs2
//   Execute.io.rs2 :=idiers2

   
//   val idieimm = Reg(UInt(32.W))
  Execute.io.imm  := decode.io.imm
//   Execute.io.imm :=idieimm

//   val idiememwren = Reg(Bool())
  Execute.io.mem_wr_en := decode.io.mem_wr_en
//   Execute.io.mem_wr_en :=idiememwren

//    val idieWren = Reg(Bool())
  Execute.io.Wr_en  := decode.io.Wr_en
//   Execute.io.Wr_en :=idieWren

  
//    val idieWrback = Reg (UInt(2.W))
   Execute.io.Wr_back := decode.io.Wr_back
//   Execute.io.Wr_back :=idieWrback

//   val idiebranfn3 = Reg(UInt(3.W))
  Execute.io.bran_fn3 := decode.io.bran_fn3
//   Execute.io.bran_fn3 :=idiebranfn3
  
  
//   val idiepcsel = Reg(Bool())
  Execute.io.pcsel := decode.io.pcsel
//   Execute.io.pcsel :=idiepcsel

//   val idieRS1 = Reg(UInt(32.W))
  Execute.io.RS1 := decode.io.RS1
//   Execute.io.RS1 :=idieRS1

//    val idieRS2 = Reg(UInt(32.W))
   Execute.io.RS2 := decode.io.RS2
//   Execute.io.RS2 :=idieRS2

  //Execute to memory

//   val ieimout = Reg(UInt(32.W))
   Memory.io.out := Execute.io.out
//   Memory.io.out := ieimout

//   val ieimpc_sel = Reg(Bool())
   Memory.io.pc_sel  := Execute.io.pc_sel
//   Memory.io.pc_sel := ieimpc_sel

//   val ieimfun3 = Reg(Bool())
  Memory.io.fun3 := Execute.io.fn3
//   Memory.io.fun3 :=ieimfun3

//   val ieimbrtaken = Reg(Bool())
  Memory.io.br_taken := Execute.io.br_taken
//   Memory.io.br_taken := ieimbrtaken
   
//   val ieimrdout = Reg(UInt(5.W))
   Memory.io.rdout := Execute.io.rdout
//   Memory.io.rdout := ieimrdout

   
  // val ieimrdout = Reg(UInt(5.W))
  // ieirdout := Execute.io.rdout
  // Memory.io.rdout := ieirdout

//   val ieimrs2out= Reg(UInt(5.W))
  Memory.io.rs2out := Execute.io.rs2out
//   Memory.io.rs2out := ieimrs2out
   
   
//   val ieimpc_out = Reg(UInt(32.W))
   Memory.io.pc_out := Execute.io.pc_out
//   Memory.io.pc_out := ieimpc_out

//    val ieimmemwren= Reg(Bool())
   Memory.io.memwren := Execute.io.memwren
//   Memory.io.memwren := ieimmemwren

//   val ieimwren= Reg(Bool())
   Memory.io.wren  := Execute.io.wren
//   Memory.io.wren := ieimwren

  
//   val ieimwrback= Reg(UInt(2.W))
  Memory.io.wrback := Execute.io.wrback
//   Memory.io.wrback := ieimwrback

//   val ieimRS_2= Reg(UInt(32.W))
  Memory.io.RS_2 := Execute.io.RS_2
//   Memory.io.RS_2 := ieimRS_2

  //memory to wrback

//   val imiwDout = Reg(UInt(32.W))
  writeback.io.Dout := Memory.io.Dout
//   writeback.io.Dout :=  imiwDout

//   val imiwpcout = Reg(UInt(32.W))
   writeback.io.pcout := Memory.io.pcout
//   writeback.io.pcout :=  imiwpcout

//   val imiwaout = Reg(UInt(32.W))
  writeback.io.aout := Memory.io.aout
//   writeback.io.aout :=  imiwaout

//    val imiwrdo = Reg(UInt(5.W))
  writeback.io.rdo := Memory.io.rdo
//   writeback.io.rdo :=  imiwrdo

//   val imiwpcsel = Reg(Bool())
  writeback.io.pcsel := Memory.io.pcsel
//   writeback.io.pcsel :=  imiwpcsel

//   val imiwrenout = Reg(Bool())
  writeback.io.wrenout := Memory.io.wrenout
//   writeback.io.wrenout :=  imiwrenout

//   val imiwwrbackout = Reg(Bool())
  writeback.io.wrbackout  := Memory.io.wrbackout
//   writeback.io.wrbackout :=  imiwwrbackout
 
//   val imiwbrtaken = Reg(Bool())
   writeback.io.brtaken  := Memory.io.brtaken
//   writeback.io.brtaken :=  imiwbrtaken

decode.io.RD := writeback.io.RD
 fetch.io.aluout:=writeback.io.a_out


io.out := Execute.io.out.asSInt
}

