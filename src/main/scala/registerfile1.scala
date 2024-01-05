package single_cycle

import chisel3 . _
import chisel3 . util . _

class register extends Module {
val io = IO ( new Bundle {
    val ren = Input(Bool())
     val data = Input(UInt(32.W))
      val rs1 = Input(UInt(5.W))
      val rs2 = Input(UInt(5.W))
      val rd = Input(UInt(5.W))
      val rs1out = Output(UInt(32.W))
      val rs2out = Output(UInt(32.W))
})
io.rs1out := 0.U
io.rs2out := 0.U


val registerfile = Mem (32 , UInt (32. W ) )
when(io.ren && io.rd =/= 0.U){
    registerfile(io.rd) := io.data
    io.rs1out := registerfile(io.rs1)
    io.rs2out := registerfile(io.rs2)
}.otherwise{
    io.rs1out := registerfile(io.rs1)
    io.rs2out := registerfile(io.rs2)
}


   

}