package single_cycle

import chisel3._
import chisel3.util._
object aluop{
  val aluADD = 0.U(4.W)
  val aluSUB = 1.U(4.W)
  val aluSLL = 2.U(4.W)
  val aluSLT = 4.U(4.W)
  val aluSLTU = 6.U(4.W) 
  val aluXOR = 8.U(4.W)
  val aluSRL = 10.U(4.W)
  val aluSRA = 11.U(4.W)
  val aluOR = 12.U(4.W)
  val aluAND = 14.U(4.W)
}
import aluop._
class ALUD extends Module {
  val io = IO(new Bundle {
    val in_A = Input(UInt(32.W))
    val in_B = Input(UInt(32.W))
    val aluop = Input (UInt(4.W))
    val out = Output(UInt(32.W))
  
  })

  io.out := 0.U

  // Handle different ALU operations based on fun3 and fun7
  switch(io.aluop) {
    is(0.U) {
      io.out := io.in_A + io.in_B
    }
    is(1.U) { // SLL
          io.out := io.in_A - io.in_B
    }
    is(2.U){

      io.out := io.in_A << (io.in_B(4, 0).asUInt)
    }
    is(4.U) { // SLT
      io.out := (io.in_A.asSInt < io.in_B.asSInt).asUInt
    }
    is(6.U) { // SLTU
      io.out := (io.in_A < io.in_B).asUInt
    }
    is(8.U) { // XOR
      io.out := io.in_A ^ io.in_B
    }
    is(10.U) { // SRL
        io.out := io.in_A >> (io.in_B(4, 0).asUInt)
     
    }
     is(11.U) { // SRA
        io.out := (io.in_A.asSInt >> (io.in_B(4, 0).asUInt)).asUInt
      }
    is(12.U) { // OR
      io.out := io.in_A | io.in_B
    }
    is(14.U) { // AND
      io.out := io.in_A & io.in_B
    }
  }
}
