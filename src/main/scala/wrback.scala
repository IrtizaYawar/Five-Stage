package single_cycle

import chisel3._
import chisel3.util._

class writeback extends Module {
  val io = IO(new Bundle {
  val Dout = Input(UInt(32.W))  
  val aout = Input(UInt(32.W))
   val a_out = Output(UInt(32.W))
   val rdo = Input(UInt(5.W))
   val rdout = Output(UInt(5.W))
   val wrenout  = Input(Bool())
   val wrbackout = Input(UInt(2.W))
   val RD = Output(UInt(32.W))
   val pcout =  Input(UInt(32.W))
    val brtaken = Input(Bool())
    val pcsel = Input(Bool())
  })
  when(io.wrbackout===0.U)
       {
        io.RD:=io.Dout
       }
       .elsewhen(io.wrbackout===1.U)
       {
        io.RD:=io.aout
       }
       .elsewhen(io.wrbackout===2.U)
       {
        io.RD:=io.pcout+4.U
       }
       .otherwise
       {
        io.RD:=0.U
       }
       io.a_out := io.aout
       io.rdout := io.rdo










}