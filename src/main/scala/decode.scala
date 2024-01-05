package single_cycle

import chisel3._
import chisel3.util._

class Decode extends Module {
  val io = IO(new Bundle {
   val in = Input(UInt(32.W))
   val pc4_in =  Input(UInt(32.W))
   val pc4out = Output(UInt(32.W))
   val pco =  Input(UInt(32.W))
   val pcout =  Output(UInt(32.W))
    val  Opcode = Output(UInt(7.W))
    val aluop = Output(UInt(4.W))
    val iformat =Output(Bool()) 
    val rformat =Output(Bool()) 
    val sformat = Output(Bool())
    val bformat = Output(Bool())
    val jalformate = Output(Bool())
    val luiformate = Output(Bool())
    val Auipcformate = Output(Bool())
    val jalrformate = Output(Bool())
    val rd = Output(UInt(5.W))
    // val rdin =Input(UInt(5.W))
    val fun_3 = Output(UInt(3.W))
    val rs1 = Output(UInt(5.W))
    val rs2 = Output(UInt(5.W))
    val imm = Output(UInt(32.W)) 
    val mem_wr_en = Output (Bool())
    val Wr_en = Output(Bool())
    val Wr_back = Output (UInt(2.W))
    val bran_fn3 = Output(UInt(3.W))
    val btake = Input(Bool())
    val pcsel = Output(Bool())
    val RS1 =  Output(UInt(32.W))
    val RS2 =  Output(UInt(32.W))
    val RD = Input(UInt(32.W))
  })

  val cu = Module (new  controlunit)
  val reg = Module (new  register)
  cu.io.in:= io.in
  io.imm:= cu.io.imm
reg.io.data := 0.U
// io.btake :=0.B
//io.rdin :=0.U
  io.Opcode := cu.io.Opcode
  io.aluop := cu.io.aluop
  io.iformat := cu.io.iformat
  io.rformat := cu.io.rformat
  io.sformat := cu.io.sformat
  io.bformat := cu.io.bformat
  io.jalformate := cu.io.jalformate
  io.luiformate := cu.io.luiformate
  io.Auipcformate := cu.io.Auipcformate
  io.jalrformate := cu.io.jalrformate
  cu.io.btake  := io.btake

  io.rd := cu.io.rd
  io.fun_3 := cu.io.fun_3
  io.rs1 := cu.io.rs1
  io.rs2 := cu.io.rs2
  io.imm := cu.io.imm
  io.mem_wr_en := cu.io.mem_wr_en
  io. Wr_en := cu.io. Wr_en
  io.Wr_back := cu.io.Wr_back
  io.bran_fn3 := cu.io.bran_fn3
  //io.btake := cu.io.btake
  io.pcsel := cu.io.pcsel

   reg.io.rd := cu.io.rd
   reg.io.rs1 := cu.io.rs1
   reg.io.rs2 := cu.io.rs2
   reg.io.ren := cu.io.Wr_en
   reg.io.rd := io.RD

   reg.io.rs1  := cu.io.rs1
   reg.io.rs2 := cu.io.rs2

   io.pcout := io.pco
   io.RS1 := reg.io.rs1out
   io.RS2 := reg.io.rs2out
   io.pc4out := io.pc4_in

}

