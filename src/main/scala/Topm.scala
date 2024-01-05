package single_cycle
import chisel3 . _
import chisel3 . util . _

class top extends Module {
    val io = IO (new Bundle{
    val out = Output (UInt(32.W))
    
        
        })
// val datapa = Module(new Datapath)
val topp = Module(new top)
val sync = Module(new syncmem("/Users/Saffy Yawar/OneDrive/Documents/single_cycle/src/main/ins.txt"))
//  ./Users/Saffy Yawar/OneDrive/Documents/single_cycle/src/main/ins.txt
 sync.io.addr := datapa.io.Pcout
 datapa.io.insin  := sync.io.inst
 io.out := datapa.io.out
}
