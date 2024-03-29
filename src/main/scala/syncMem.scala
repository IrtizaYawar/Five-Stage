package single_cycle

import chisel3 . _
import chisel3 . util . _
import chisel3 . util . experimental . loadMemoryFromFile
import scala . io . Source
class syncmemIO extends Bundle  {
val addr = Input ( UInt ( 32 .W ) )
val inst = Output ( UInt ( 32 . W ) )
//val currentaddr = Output(UInt(32.W))
}
class syncmem ( initFile : String ) extends Module {
val io = IO (new syncmemIO )
// INST_MEM_LEN in Bytes or INST_MEM_LEN / 4 in words
val sync = Mem (1024,UInt(32.W))
loadMemoryFromFile ( sync , initFile )
io . inst := sync.read ( io . addr / 4. U )
}


