package single_cycle

import chisel3._
import chisel3.util._

class controlunit extends Module {
  val io = IO(new Bundle {
    val in = Input(UInt(32.W))
    val  Opcode = Output(UInt(7.W))
    val aluop = Output(UInt(4.W))
   // val l_j_jr_au = Output(UInt(20.W))
     val iformat =Output(Bool()) 
     val rformat =Output(Bool()) 
     val sformat = Output(Bool())
    val bformat = Output(Bool())
    val jalformate = Output(Bool())
    val luiformate = Output(Bool())
    val Auipcformate = Output(Bool())
    val jalrformate = Output(Bool())
    val rd = Output(UInt(5.W))
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
    //val fun_7 = Output(UInt(7.W))

    

  })
        io.Opcode := (io.in(6,0))
        io.iformat:=0.B
        io.rformat:=0.B
        io.imm := 0.U
        io.aluop:= 0.U
        io.rs1 := 0.U
        io.rs2 := 0.U
        io.rd := 0.U
        io.fun_3:=0.U
        io.sformat:=0.B
        val f3 = io.in(14,12)
        val f7 = io.in(31,25)
        io.bran_fn3:=0.U
        io.mem_wr_en:=0.U
        io.Wr_back := 0.U
        io.pcsel:=0.B
        io.bformat :=0.B
        io.Wr_en:=0.B
        io.jalformate:=0.B
        io.luiformate:=0.B
        io.Auipcformate:=0.B
        io.jalrformate:=0.B
        //io.l_j_jr_au:=0.U
            

    when (io.Opcode === "b0110011".U ){//rtype
        io.rformat :=1.B
        io.Wr_en := 1.B
        io.Wr_back :=1.U
        io. rd :=(io.in(11,7))
        io. aluop :=Cat(f3,f7(5))
        io. rs1 :=(io.in(19,15))
        io. rs2  :=(io.in(24,20))
           io.bran_fn3:=0.U
    }
    .elsewhen(io.Opcode === "b0010011".U){//itype
        io.iformat := 0.B
        io.Wr_en :=1.B
        io.Wr_back :=1.U
        io. rd :=(io.in(11,7))
        io. aluop :=Cat(f3,0.U)
        when(f3===5.U||f3===1.U){
            io. aluop :=Cat(f3,f7(5))
        }
        .otherwise{
            io. aluop :=Cat(f3,0.U)
        }
        io. rs1 :=(io.in(19,15))
           io.bran_fn3:=0.U
        //io.imm := io.in(31,20)
            io.imm := Cat(Fill(19,io.in(31)),io.in(31,20))

    }
    .elsewhen(io.Opcode === "b0000011".U){//LOAD

     io.Wr_en:=1.B
     io.rd:=(io.in(11,7))
     io.rs1:=(io.in(20,15))
     io.aluop:=0.U
     io.mem_wr_en:=0.B
     io.Wr_back:=0.U
     io.rs2:=0.B
     io.fun_3 := f3
        io.bran_fn3:=0.U
     io.imm := Cat(Fill(20,io.in(31)),io.in(31,20))
}

   .elsewhen(io.Opcode === "b0100011".U){//store
    io.Wr_en:=0.B
    io.sformat:=1.B
    io.rs1:=(io.in(19,15))
     io.rs2:=(io.in(24,20))
    io.fun_3 := f3 
       io.imm := Cat(Fill(20,io.in(31)),io.in(31,25),io.in(11,7))
      io.aluop:= 0.U
      io.mem_wr_en:=1.B
      io.Wr_back:=0.U
      io.bran_fn3:=0.U
}

.elsewhen(io.Opcode === "b1100011".U){//branch
    io.bformat:=1.B
    io.rs1:=(io.in(19,15))
    io.rs2:=(io.in(24,20))
    io.imm := Cat(Fill(19,io.in(31)),io.in(31),io.in(7),io.in(30,25),io.in(11,8),0.U)
    io.aluop := 0.U
    io.Wr_back := 0.U
    io.mem_wr_en := 0.B
    io.Wr_en :=0.B
    io.bran_fn3:=(io.in(14,12))
    io.rd:=0.U
    when(io.btake){
    io.pcsel:=1.U
    }
}

 .elsewhen(io.Opcode === "b1101111".U){//jal
    io.jalformate:=1.B
    io.rd:=(io.in(11,7))
    io.rs1:=0.U
    io.rs2:=0.U
    io.mem_wr_en:=0.B
    io.Wr_back:=2.U
    io.Wr_en:=1.B
    io.pcsel:=1.B
    io.imm := ((Cat(Fill(11,io.in(31)),io.in(31),io.in(19,12),io.in(20),io.in(30,21),0.U)))
    io.aluop:=0.U
    io.jalformate:= 1.B
 }

  .elsewhen(io.Opcode === "b0110111".U){//lui
    io.luiformate:=1.B
     io.rd:=(io.in(11,7))
     io.rs1:=0.U
    io.rs2:=0.U
    io.mem_wr_en:=0.B
    io.Wr_en:=1.B
    io.Wr_back:=1.U
    io.pcsel:=0.B
    io.imm := Cat(io.in(31, 12),Fill (12, 0.U))
    io.aluop:=0.B

    
}
 .elsewhen(io.Opcode === "b1100111".U){//jalr
    io.jalrformate:=1.B
     io.rd:=(io.in(11,7))
     io.rs1:=(io.in(19,15))
     io.rs2:=0.U
     io.mem_wr_en:=0.B
     io.Wr_en:=1.B
     io.Wr_back:=2.U
     io.aluop:=0.B
     io.pcsel:=1.B
     io.imm:=Cat(Fill(11,io.in(31)),io.in(31,20))
     
 }
  .elsewhen(io.Opcode === "b1100111".U){//Auipc
    io.Auipcformate:=1.B
    io.rd:=0.B
    io.rs1:=0.B
    io.rs2:=0.B
    io.mem_wr_en:=0.B
    io.Wr_back:=0.U
    io.Wr_en:=0.B
    io.pcsel:=1.B
    io.imm := Cat(io.in(31, 12),Fill (12, 0.U))
    io.aluop:=0.U
}
.otherwise{
     io.mem_wr_en:=0.U
        io.Wr_back := 0.U
        io.Wr_en:=0.B
        io.bformat :=0.B
        io.jalformate:=0.B
        io.luiformate:=0.B
        io.Auipcformate:=0.B
        io.jalrformate:=0.B
        // io.l_j_jr_au:=0.B
        io.imm:=0.U

}
}