package single_cycle

import chisel3._
import chisel3.util._

class memory extends Module {
  val io = IO(new Bundle {
     //val Wr_en = Input(Bool())
   // val address = Input(UInt(32.W))
   // val datain = Input(UInt(32.W))
    val Dout = Output(UInt(32.W))
    val fun3 = Input(UInt(3.W))
     val br_taken = Input(Bool())
     val brtaken = Output(Bool())
     val pc_sel = Input(Bool())
      val pcsel = Output(Bool())


     val out = Input(UInt(32.W))
     val aout = Output(UInt(32.W))
        val rdout = Input(UInt(5.W))
        val rdo = Output(UInt(5.W))
            val rs2out = Input(UInt(5.W))
            val wren  = Input(Bool())
            val wrenout  = Output(Bool())
            val pc_out =  Input(UInt(32.W))
            val pcout =  Output(UInt(32.W))
            val wrback = Input(UInt(2.W))
            val wrbackout = Output(UInt(2.W))
            val RS_2 = Input(UInt(32.W))
            val memwren = Input (Bool())
      })

      val dmem = Module(new Datamem)
        //  io.fun3 :=0.U
      dmem.io.Wr_en := io.wren
      dmem.io.address := io.out
      dmem.io.datain := io.RS_2
      io.Dout := dmem.io.Dout
      dmem.io.fun3 := io.fun3

      io.wrenout := io.wren
      io.wrbackout := io.wrback
      io.rdo := io.rdout
      io.aout := io.out
      io.pcout := io.pc_out
      io.brtaken := io.br_taken
      io.pcsel := io.pc_sel
}