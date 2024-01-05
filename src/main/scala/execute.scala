package single_cycle

import chisel3._
import chisel3.util._

class execute extends Module {
  val io = IO(new Bundle {
    
    val out = Output(UInt(32.W))

    
    val br_taken = Output (Bool())

    val pc4out = Input(UInt(32.W))
    val pcout =  Input(UInt(32.W))
    val pc_out =  Output(UInt(32.W))
    val  Opcode = Input(UInt(7.W))
    val aluop = Input(UInt(4.W))
    val iformat =Input(Bool()) 
    val rformat =Input(Bool()) 
    val sformat = Input(Bool())
    val bformat = Input(Bool())
    val jalformate = Input(Bool())
    val luiformate = Input(Bool())
    val Auipcformate = Input(Bool())
    val jalrformate = Input(Bool())
    val rd = Input(UInt(5.W))
    val rdout = Output(UInt(5.W))
    val fun_3 = Input(UInt(3.W))
    val fn3 = Output(UInt(3.W))
    val rs1 = Input(UInt(5.W))
    val rs2 = Input(UInt(5.W))
    val rs2out = Output(UInt(5.W))
    val imm = Input(UInt(32.W)) 
    val mem_wr_en = Input (Bool())
    val memwren = Output (Bool())
    val Wr_en = Input(Bool())
    val wren = Output(Bool())
    val Wr_back = Input (UInt(2.W))
    val wrback = Output(UInt(2.W))
    val bran_fn3 = Input(UInt(3.W))
    val pcsel = Input(Bool())
     val pc_sel = Output(Bool())
    val RS1 =  Input(UInt(32.W))
    val RS2 =  Input(UInt(32.W))
    val RS_2 = Output(UInt(32.W))
  
   
  })
  val alu = Module (new ALUD)
  val Bran = Module(new BranchControl)
  io.br_taken:=0.U

  io.fn3  := io.fun_3
  //alu.io.in_A := io.in_A
  alu.io.in_A:=Mux((io.bformat && Bran.io.br_taken) || io.jalformate || io.jalrformate ,io.pcout,io.RS1)
  //alu.io.in_B := io.in_B
  when(io.rformat ){
            alu.io.in_B:=io.RS2 
        }
        .otherwise{
         
         alu.io.in_B := io.imm 
        }
  alu.io.aluop := io.aluop
  io.out := alu.io.out

  // Bran.io.fnct3 := io.fnct3
  // Bran.io.branch := io.branch
  // Bran.io.arg_x := io.arg_x
  // Bran.io.arg_y := io.arg_y
  io.br_taken := Bran.io.br_taken
  Bran.io.fnct3:=io.bran_fn3
        //cu.io.btake:=Bran.io.br_taken
        Bran.io.arg_x:=io.RS1
        Bran.io.arg_y:=io.RS2
        Bran.io.branch := io.bformat

        io.memwren := io.mem_wr_en
        io.wrback := io.Wr_back
        io.RS_2 := io.RS2
        io.rdout := io.rd
        io.rs2out := io.rs2
       io.wren := io.Wr_en

       io.pc_out := io.pcout
       io.pc_sel :=io.pcsel
}