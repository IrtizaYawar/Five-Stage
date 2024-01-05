package single_cycle

import chisel3._
import chisel3.util._

class Fetch extends Module {
  val io = IO(new Bundle {
    val pcsel = Input(Bool())
    val aluout = Input(UInt(32.W))
    val instruction = Output(UInt(32.W))
    val address_out = Output(UInt(32.W))
    val pc4_out = Output(UInt(32.W))
    
  })
  val inmem = Module(new InstMem("C:/Users/Saffy Yawar/Scala-Chisel-Learning-Journey/src/main/scala/gcd/inMem.txt"))
  val pc = RegInit(0.U(32.W))
 // io.pcsel := 0.B
  io.address_out:= pc
  inmem.io.addr:=pc
  pc := Mux(io.pcsel,io.aluout,pc+4.U)
  io.pc4_out:=pc
  inmem.io.addr:= pc
  io.instruction:=inmem.io.inst

}