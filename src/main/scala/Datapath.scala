package single_cycle

import chisel3._
import chisel3.util._

class Datapath extends Module {
  val io = IO(new Bundle {
    val Pcout= Output(UInt(32.W))
    val insin = Input(UInt(32.W))
      val out = Output (UInt(32.W))

  })
      val pc = Module (new Pc)
      // Donttouch(pc)
     val im = Module (new InstMem ("C:/Users/Saffy Yawar/Scala-Chisel-Learning-Journey/src/main/scala/gcd/inMem.txt"))
     val reg = Module (new  register)
      val cu = Module (new  controlunit)
      val alu = Module (new ALUD)
      val dmem = Module(new Datamem)
      val Bran = Module(new BranchControl)
      //val syn = Module(new syncmem(""))

      val pc_r = RegInit(0.U(32.W))
     

    //   when  (Bran.io.br_taken){
    //     pc:=alu.io.out

      pc_r := Mux(cu.io.pcsel,alu.io.out.asUInt(),pc_r+4.U)
       io.Pcout := pc_r
    //   .otherwise{
    //     pc:=pc+4.U
    //   }

    
  im.io.addr:=pc_r
        cu.io.in:=im.io.inst
        reg.io.ren:=cu.io.Wr_en
       // reg.io.data:=Mux(cu.io.Wr_back,alu.io.out,pc+4.U)
       when(cu.io.Wr_back===0.U)
       {
        reg.io.data:=dmem.io.Dout
       
       }
       .elsewhen(cu.io.Wr_back===1.U)
       {
        reg.io.data:=alu.io.out
       }
       .elsewhen(cu.io.Wr_back===2.U)
       {
        reg.io.data:=pc_r+4.U
       }
       .otherwise
       {
        reg.io.data:=0.U
       }
        reg.io.rs1:= cu.io.rs1
        reg.io.rs2:=cu.io.rs2
        reg.io.rd:=cu.io.rd
        alu.io.aluop:=cu.io.aluop
         
        alu.io.in_A:=Mux((cu.io.bformat && Bran.io.br_taken) || cu.io.jalformate || cu.io.jalrformate ,pc_r,reg.io.rs1out)
        
        reg.io.ren:=cu.io.Wr_en
        dmem.io.fun3 := 0.U
        when(cu.io.in(14,12) === 3.U)
        {
          dmem.io.fun3:= cu.io.fun_3
        }
        
        dmem.io.Wr_en:=cu.io.mem_wr_en
         dmem.io.address:=alu.io.out
         dmem.io.datain:=reg.io.rs2out
       // reg.io.data:=Mux(cu.io.Wr_back,alu.io.out,0.U)//dmem.io.Dout)
        //branch fun3
        Bran.io.fnct3:=cu.io.bran_fn3
        cu.io.btake:=Bran.io.br_taken
        Bran.io.arg_x:=reg.io.rs1out
        Bran.io.arg_y:=reg.io.rs2out
        Bran.io.branch := cu.io.bformat

        //alu.io.in_B:=reg.io.rs2out
        when( cu.io.rformat ){
            alu.io.in_B:=reg.io.rs2out 
        }
        .otherwise{
         
         alu.io.in_B := cu.io.imm 
         
        }
    //io.out := Mux(cu.io.Wr_back,alu.io.out,0.U)
     when(cu.io.Wr_back===0.U)
       {
        io.out:=dmem.io.Dout
       }
       .elsewhen(cu.io.Wr_back===1.U)
       {
        io.out:=alu.io.out
       }
       .elsewhen(cu.io.Wr_back===2.U)
       {
        io.out:=pc_r+4.U
       }
       .otherwise
       {
        io.out:=0.U
       }

}
