package single_cycle
import chisel3 . _
import chisel3 . util . _

class top extends Module {
    val io = IO (new Bundle{
    val out = Output (UInt(32.W))
    
        
        })
// val datapa = Module(new Datapath)
val topcore = Module(new maintop)
val sync = Module(new syncmem("/Users/Saffy Yawar/OneDrive/Documents/single_cycle/src/main/ins.txt"))
//  ./Users/Saffy Yawar/OneDrive/Documents/single_cycle/src/main/ins.txt
 sync.io.addr := topcore.io.pcout
 topcore.io.insin  := sync.io.inst
 io.out:=0.U
//  topcore.fetch.io. := topcore.io.out
}
//  syncMem.io.addr:=topcore.fetch.io.pc_out
//     topCore.fetch.io.ins:=syncMem.io.inst
// syncMem.io.addr:=TopCore.io.pcout
//     TopCore.io.ins:=syncMem.io.inst