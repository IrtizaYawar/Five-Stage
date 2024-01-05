package single_cycle

import chisel3 . _
import chisel3 . util . _
class Pc extends Module  {
    val io = IO (new Bundle{
        //val address = Input (UInt (32.W))
        val addressout = Output (UInt(32 .W))
    })
    val counter = RegInit(0.U(32.W))
    counter := (counter +4.U)/4.U
    io.addressout:= counter

}


